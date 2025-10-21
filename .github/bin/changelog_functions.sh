#!/bin/bash

# Debug function to print to stderr
debug() {
  echo -e "$@" >&2
}

debug_prs1() {
  local prs

  debug "debug_prs1"

  prs=$(gh pr list \
    --search "is:merged" \
    --limit 100)

  debug "List of merged feature PRs:"
  debug "-------------------"
  while IFS= read -r pr_info; do
    local title=$(echo "$pr_info" | cut -d'|' -f1)
    local labels=$(echo "$pr_info" | cut -d'|' -f2)
    local merged_at=$(echo "$pr_info" | cut -d'|' -f3)
    local base_branch=$(echo "$pr_info" | cut -d'|' -f4)

    debug "pr_info: $pr_info"
    debug "PR Title: $title"
    debug "Labels: $labels"
    debug "Merged At: $merged_at"
    debug "Base Branch: $base_branch"
    debug "-------------------"
  done <<< "$prs"
}

debug_prs2() {
  local prs

  debug "Debugging all merged feature PRs (title starting with 'feat:')"

  # Récupérer toutes les PRs fusionnées avec un titre commençant par "feat:"
  prs=$(gh pr list \
    --search "is:merged" \
    --limit 100 --json title,labels,mergedAt,baseRefName)

  if [ -z "$prs" ]; then
    debug "No feature PRs found"
    return
  fi

  debug "List of merged feature PRs:"
  debug "-------------------"
  while IFS= read -r pr_info; do
    local title=$(echo "$pr_info" | cut -d'|' -f1)
    local labels=$(echo "$pr_info" | cut -d'|' -f2)
    local merged_at=$(echo "$pr_info" | cut -d'|' -f3)
    local base_branch=$(echo "$pr_info" | cut -d'|' -f4)

    debug "PR Title: $title"
    debug "Labels: $labels"
    debug "Merged At: $merged_at"
    debug "Base Branch: $base_branch"
    debug "-------------------"
  done <<< "$prs"
}

debug_prs3() {
  local prs

  debug "Debugging all merged feature PRs (title starting with 'feat:')"

  # Récupérer toutes les PRs fusionnées avec un titre commençant par "feat:"
  prs=$(gh pr list \
    --search "is:merged" \
    --limit 100 --json number,title,labels,mergedAt,baseRefName \
    --jq '.[] | "\(.number)|\(.title)|\(.labels | map(.name) | join(","))|\(.mergedAt)|\(.baseRefName)"' || echo "")

  if [ -z "$prs" ]; then
    debug "No feature PRs found"
    return
  fi

  debug "List of merged feature PRs:"
  debug "-------------------"
  while IFS= read -r pr_info; do
    local title=$(echo "$pr_info" | cut -d'|' -f1)
    local labels=$(echo "$pr_info" | cut -d'|' -f2)
    local merged_at=$(echo "$pr_info" | cut -d'|' -f3)
    local base_branch=$(echo "$pr_info" | cut -d'|' -f4)

    debug "PR Title: $title"
    debug "Labels: $labels"
    debug "Merged At: $merged_at"
    debug "Base Branch: $base_branch"
    debug "-------------------"
  done <<< "$prs"
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

  prs=$(gh pr list \
    --search "merged:>=$from_date merged:<=$to_date" \
    --limit 100 --json title,labels,mergedAt \
    --jq '.[] | "\(.title)|\(.labels[].name)|\(.mergedAt)"' || echo "")

  if [ -z "$prs" ]; then
    debug "No PRs found between $from_date and $to_date"
    debug "No changes."
    return
  fi

  local added=""
  local fixed=""
  local changed=""
  local breaking=""

  while IFS= read -r pr_info; do
    title=$(echo "$pr_info" | cut -d'|' -f1)
    labels=$(echo "$pr_info" | cut -d'|' -f2)
    merged_at=$(echo "$pr_info" | cut -d'|' -f3)

    debug "pr_info :\n$pr_info"
    debug "title : $title"
    debug "labels :\n$labels"
    debug "merged_at : $merged_at"

    # Categorize based on PR title prefix
    if [[ "$title" =~ ^feat: ]]; then
      added+="- $title\n"
    elif [[ "$title" =~ ^fix: ]]; then
      fixed+="- $title\n"
    elif [[ "$title" =~ ^(chore|docs|refactor|style|test|perf|ci|build): ]]; then
      changed+="- $title\n"
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
