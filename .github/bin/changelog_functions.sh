#!/bin/bash

# Debug function to print to stderr
debug() {
  echo -e "$@" >&2
}

get_release_lines() {
  local v_version=$1
  local date=$2

  echo -e "## [${v_version#v}] - $date\n"
  echo -e "[Release ${v_version}](https://github.com/$repo/releases/tag/${v_version})\n"
}

# Function to get PR titles for commits between two refs (from_ref..to_ref) on a target branch
# Uses `gh pr list` to fetch merged PRs associated with commits
get_pr_changes() {
  local from_ref=$1
  local to_ref=$2
  local target_branch="$3" # develop or main
  local prs
  local commits

  debug "Fetching commits from $from_ref to $to_ref for branch $target_branch"

  # Get commit SHAs in range (use --first-parent to focus on merge commits)
  commits=$(git log --first-parent --pretty=format:"%H" "$from_ref..$to_ref" --branches=$target_branch)

  # Initialize arrays for categorized changes
  local added=""
  local fixed=""
  local changed=""
  local breaking=""

  # Iterate over commits to find associated PRs
  while IFS= read -r commit; do
    # Find PR associated with the commit
    pr_info=$(gh pr list --state merged --repo "$repo" --search "$commit" --json title,labels,mergedAt --jq '.[] | "\(.title)|\(.labels[].name)|\(.mergedAt)"' || echo "")

    debug "pr_info :\n$pr_info"

    pr_info=$(gh api -H "Accept: application/vnd.github+json" "/repos/$repo/pulls?state=closed&sort=updated&direction=desc&per_page=100" \
      --jq ".[] | select(.merge_commit_sha == \"$commit\" or .head.sha == \"$commit\") | \"\(.title)|\(.labels[].name)|\(.merged_at)\"" || echo "")

    debug "pr_info 2 :\n$pr_info"

    if [ -z "$pr_info" ]; then
      debug "No PR found for commit $commit, skipping"
      continue
    fi

    # if [ -n "$pr_info" ]; then
      title=$(echo "$pr_info" | cut -d'|' -f1)
      labels=$(echo "$pr_info" | cut -d'|' -f2)

      debug "pr_info :\n$pr_info"
      debug "title : $title"
      debug "labels :\n$labels"

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
    # fi
  done <<< "$commits"

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
  local today_date=$(date +%Y-%m-%d)

  debug "futur_tag : $futur_tag"
  debug "last_tag : $last_tag"
  debug "today_date : $today_date"

  get_release_lines $futur_tag $today_date >> "CHANGELOG.md"
  get_pr_changes $last_tag "HEAD" "develop" >> "CHANGELOG.md" || echo "No changes." >> "CHANGELOG.md"
}

# PRs merged : features into main
# From a tag to the next
manage_releases_between_tags() {
  debug "manage_releases_between_tags()"

  local -a tags_array=("$@")

  debug "tags_array : ${tags_array[*]}"
  
  for ((i=1; i < ${#tags_array[@]}; i++)); do
    previous_tag="${tags_array[$i]}"
    current_tag="${tags_array[$i-1]}"
    release_date=$(git log -1 --format=%cd --date=format:%Y-%m-%d $current_tag)

    debug "previous_tag : $previous_tag"
    debug "current_tag : $current_tag"
    debug "release_date : $release_date"

    get_release_lines $current_tag $release_date >> "CHANGELOG.md"
    get_pr_changes $previous_tag $current_tag "main" >> "CHANGELOG.md" || echo "No changes." >> "CHANGELOG.md"
  done
}

# PRs merged : features into main
# From the beginning to the first tag
manage_first_release() {
  debug "manage_first_release()"

  local first_commit=$1
  local first_tag=$2

  release_date=$(git log -1 --format=%cd --date=format:%Y-%m-%d $first_tag)

  debug "first_commit : $first_commit"
  debug "first_tag : $first_tag"
  debug "release_date : $release_date"

  get_release_lines $first_tag $release_date >> "CHANGELOG.md"
  get_pr_changes $first_commit $first_tag "main" >> "CHANGELOG.md" || echo "No changes." >> "CHANGELOG.md"
}
