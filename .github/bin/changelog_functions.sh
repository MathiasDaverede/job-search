#!/bin/bash

# Debug function to print to stderr
debug() {
  echo -e "$@" >&2
}

get_release_lines() {
  local v_version=$1
  local date=$2
  local display_date=$(echo "$date" | cut -d'T' -f1) # YYYY-MM-DD

  echo -e "## [${v_version#v}] - $display_date\n"
  echo -e "[Release ${v_version}](https://github.com/$repo/releases/tag/${v_version})\n"
}

# Function to get PR titles for commits between two refs (from_ref..to_ref) on a target branch
# Uses `gh pr list` to fetch merged PRs associated with commits
get_pr_changes() {
  local from_date=$1
  local to_date=$2
  local prs
  
  debug "Fetching PRs merged between $from_date and $to_date"

  # --search : GitHub search query to filter PRs (e.g., is:merged, merged:>=date)
  # --limit : set maximum number of PRs to fetch (default is 30, increased for larger projects)
  # --json : output PR data in JSON format with specified fields
  #   available fields for --json:
  #     number, title, body, state, createdAt, updatedAt, closedAt, mergedAt, labels,
  #     author, assignees, reviewers, headRefName, baseRefName, headRefOid, baseRefOid,
  #     mergeCommit, additions, deletions, url, id, isDraft, milestone, commitCount, changedFiles
  # --jq : filter and transform JSON output into a formatted string
  #   .[] : Iterate over each PR in the JSON array
  #   \(.field) : extract a field specified in --json (e.g., .title, .number)
  #   \(.field | map(.name) | join(",")) : concatenate array field values (e.g., labels) into a comma-separated string
  prs=$(gh pr list \
    --search "merged:>=$from_date merged:<=$to_date" \
    --json title,labels \
    --jq '.[] | "\(.title)|\(.labels | map(.name) | join(","))"')

  local added=""
  local fixed=""
  local changed=""
  local breaking=""

  while IFS= read -r pr_info; do
    local pr_title=$(echo "$pr_info" | cut -d'|' -f1)
    local labels=$(echo "$pr_info" | cut -d'|' -f2)

    # PRs titles must be like :
    # type: title ([action #issue_number])
    # feat: a feature [closes #1]
    # fix: a bug fix [fixes #2]
    # fix: another bug fix [resolves #3]
    # chore(CI): a chore
    if ! [[ "$pr_title" =~ ^(feat|fix|chore|docs|refactor|style|test|perf|ci|build) ]]; then
      debug "PR title : $pr_title => skipped"
      continue
    fi

    # ^([a-z]+(\([A-Za-z]+\))?) => Captures one or more lowercase letters (e.g., chore, feat) optionally followed by a scope in parentheses (e.g., (CI)) at the start
    # (:.*) => Captures the colon and everything following it
    local type=$(echo $pr_title | perl -ne '/^([a-z]+(\([A-Za-z]+\))?)(:.*)/ && print $1')

    # ^([a-z]+(\([A-Za-z]+\))?): => Captures one or more lowercase letters (e.g., chore, feat) optionally followed by a scope in parentheses (e.g., (CI)), then a colon and a space
    # (.*?) => Captures the title in a non-greedy way until an optional [action #number] or end of string
    # ( \[[a-z]+ #([0-9]+)\])?$ => Optionally captures a space followed by [action #number] at the end
    local title=$(echo $pr_title | perl -ne '/^([a-z]+(\([A-Za-z]+\))?): (.*?)( \[[a-z]+ #([0-9]+)\])?$/ && print $3')

    # ( \[[a-z]+ #([0-9]+)\]) => Captures the number after # in a [action #number] structure
    local issue_number=$(echo $pr_title | perl -ne '/\[[a-z]+ #([0-9]+)\]/ && print $1')

    local changelog_entry=$type

    if [ -n "$issue_number" ]; then
      changelog_entry+=" [#$issue_number](https://github.com/$repo/issues/$issue_number)"
    fi

    changelog_entry+=": $title"

    debug "pr_info : $pr_info"
    debug "pr_title : $pr_title"
    debug "labels : $labels"
    debug "type : $type"
    debug "title : $title"
    debug "issue_number : $issue_number"
    debug "changelog_entry : $changelog_entry"

    if [[ $type == "feat" ]]; then
      added+="- $changelog_entry\n"
    elif [[ $type == "fix" ]]; then
      fixed+="- $changelog_entry\n"
    elif [[ $type =~ (chore|docs|refactor|style|test|perf|ci|build) ]]; then
      changed+="- $changelog_entry\n"
    fi

    # Check for breaking change label
    if echo $labels | grep -q "breaking"; then
      breaking+="- $title\n"
    fi
  done <<< $prs

  # Output sections only if not empty
  [ -n "$breaking" ] && echo -e "### Breaking Changes\n" && echo -e "$breaking"
  [ -n "$added" ] && echo -e "### Added\n" && echo -e "$added"
  [ -n "$fixed" ] && echo -e "### Fixed\n" && echo -e "$fixed"
  [ -n "$changed" ] && echo -e "### Changed\n" && echo -e "$changed"
}

# PRs merged : features into develop (so contained in current release)
# From last tag to now
manage_current_release() {
  debug "manage_current_release()"

  local futur_tag=$1
  local last_tag=$2

  local today_date=$(date --iso-8601=seconds) # Format YYYY-MM-DDTHH:MM:SSZ
  local from_date

  if [ -n "$last_tag" ]; then
    from_date=$(git log -1 --format=%cd --date=iso8601-strict $last_tag)
  else
    # When creating the first release, there is no tag yet
    from_date="1970-01-01T00:00:00Z"
  fi

  debug "futur_tag : $futur_tag"
  debug "today_date : $today_date"
  debug "last_tag : $last_tag"
  debug "from_date : $from_date"

  get_release_lines $futur_tag $today_date >> "CHANGELOG.md"
  get_pr_changes $from_date $today_date >> "CHANGELOG.md" || echo "No changes." >> "CHANGELOG.md"
}

# PRs merged : features into main
# From a tag to the next
manage_releases_between_tags() {
  debug "manage_releases_between_tags()"

  local -a tags_array=("$@")

  debug "tags_array : ${tags_array[*]}"
  
  for ((i=1; i < ${#tags_array[@]}; i++)); do
    release_tag="${tags_array[$i-1]}"
    release_date=$(git log -1 --format=%cd --date=iso8601-strict $release_tag)
    previous_tag="${tags_array[$i]}"
    previous_date=$(git log -1 --format=%cd --date=iso8601-strict $previous_tag)

    debug "release_tag : $release_tag"
    debug "release_date : $release_date"
    debug "previous_tag : $previous_tag"
    debug "previous_date : $previous_date"

    get_release_lines $release_tag $release_date >> "CHANGELOG.md"
    get_pr_changes $previous_date $release_date >> "CHANGELOG.md" || echo "No changes." >> "CHANGELOG.md"
  done
}

# PRs merged : features into main
# From the beginning to the first tag
manage_first_release() {
  debug "manage_first_release()"

  local first_tag=$1

  local first_commit=$(git rev-list --max-parents=0 HEAD)
  local first_commit_date=$(git log -1 --format=%cd --date=iso8601-strict $first_commit)
  local release_date=$(git log -1 --format=%cd --date=iso8601-strict $first_tag)

  debug "first_tag : $first_tag"
  debug "release_date : $release_date"
  debug "first_commit : $first_commit"
  debug "first_commit_date : $first_commit_date"

  get_release_lines $first_tag $release_date >> "CHANGELOG.md"
  get_pr_changes $first_commit_date $release_date >> "CHANGELOG.md" || echo "No changes." >> "CHANGELOG.md"
}
