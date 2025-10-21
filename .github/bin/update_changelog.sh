#!/bin/bash

# This script regenerates the entire CHANGELOG.md file based on merged Pull Request titles.
# It assumes:
# - PR titles follow Conventional Commits (e.g., feat:, fix:, chore:).
# - PRs are merged into develop (features) or main (releases or hotfixes).
# - Git tags (e.g., vX.Y.Z) exist for previous releases.
# - Overwrites CHANGELOG.md completely to allow header/structure changes.

set -e # Exit on error

repo=$1 # ${{ github.repository }}
v_version=$2 # ${{ env.V_VERSION }}

changelog_file="CHANGELOG.md"
date=$(date +%Y-%m-%d)

# Debug function to print to stderr
debug() {
  echo -e "$@" >&2
}

print_release_lines() {
  local v_version=$1
  local date=$2

  echo -e "## [$v_version#v] - $date\n" >> $changelog_file
  echo -e "[Release ${v_version}](https://github.com/$repo/releases/tag/${v_version})\n" >> $changelog_file
}

# Function to get PR titles for commits between two refs (from_ref..to_ref) on a target branch
# Uses `gh pr list` to fetch merged PRs associated with commits
get_pr_changes() {
  local from_ref=$1
  local to_ref=$2
  local target_branch="$3" # develop or main
  local prs
  local commits

  # Get commit SHAs in range (use --first-parent to focus on merge commits)
  commits=$(git log --first-parent --pretty=format:"%H" "$from_ref".."$to_ref" -- "$target_branch")

  # Initialize arrays for categorized changes
  local added=""
  local fixed=""
  local changed=""
  local breaking=""

  # Iterate over commits to find associated PRs
  while IFS= read -r commit; do
    # Find PR associated with the commit
    pr_info=$(gh pr list --state merged --repo "$repo" --search "$commit" --json title,labels,mergedAt --jq '.[] | "\(.title)|\(.labels[].name)|\(.mergedAt)"' || echo "")

    if [ -n "$pr_info" ]; then
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
    fi
  done <<< "$commits"

  # Output sections only if not empty
  [ -n "$breaking" ] && echo -e "### Breaking Changes\n" && echo -e "$breaking"
  [ -n "$added" ] && echo -e "### Added\n" && echo -e "$added"
  [ -n "$fixed" ] && echo -e "### Fixed\n" && echo -e "$fixed"
  [ -n "$changed" ] && echo -e "### Changed\n" && echo -e "$changed"
}

# Start fresh: overwrite CHANGELOG with header
changelog_header="# Changelog\n\n"
changelog_header+="All notable changes to this project are documented in this file.\n\n"
changelog_header+="The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),  \n"
changelog_header+="and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).\n"

echo -e $changelog_header > $changelog_file

# Get all tags sorted by version (assuming vX.Y.Z format)
tags=$(git tag -l 'v*' --sort=-v:refname)

debug "Tags found :\n$tags"

# Convert tags to array
readarray -t TAG_ARRAY <<< $tags

last_tag=${TAG_ARRAY[0]}

debug "last_tag : $last_tag"
debug "date : $date"

# Current version (no tag yet, use PRs merged into develop since last tag)
echo -e "## [$v_version#v] - $date\n" >> $changelog_file
echo -e "[Release ${v_version}](https://github.com/$repo/releases/tag/${v_version})\n" >> $changelog_file

print_release_lines $v_version $date

# Use develop as the target branch for the current version
# No tags exist yet, get all PRs merged into develop
get_pr_changes $last_tag "HEAD" "develop" >> $changelog_file || echo "No changes." >> $changelog_file

# Loop over previous tags (from newest to oldest, excluding the first which is latest)
for ((i=1; i<${#TAG_ARRAY[@]}; i++)); do
  prev_tag="${TAG_ARRAY[$i]}"
  curr_tag="${TAG_ARRAY[$i-1]}"

  debug "prev_tag : $prev_tag"
  debug "curr_tag : $curr_tag"
  
  # Get release date from tag commit
  release_date=$(git log -1 --format=%cd --date=format:%Y-%m-%d $curr_tag)

  debug "release_date : $release_date"

  print_release_lines $curr_tag $release_date
  
  get_pr_changes $prev_tag $curr_tag "main" >> $changelog_file || echo "No changes." >> $changelog_file
done

first_commit=$(git rev-list --max-parents=0 HEAD)
first_tag="${TAG_ARRAY[-1]}"
date_first_tag=$(git log -1 --format=%cd --date=format:%Y-%m-%d "$first_tag")

debug "first_commit : $first_commit"
debug "first_tag : $first_tag"
debug "date_first_tag : $date_first_tag"

echo -e "## [${first_tag#v}] - $date_first_tag\n" >> $changelog_file
echo -e "[Release ${first_tag}](https://github.com/$repo/releases/tag/${first_tag})\n" >> $changelog_file

get_pr_changes $first_commit $first_tag "main" >> $changelog_file || echo "No changes." >> $changelog_file

# Handle changes before first tag (if any)
# if [ ${#TAG_ARRAY[@]} -gt 0 ]; then
#   first_tag="${TAG_ARRAY[-1]}"

#   debug "first_tag : $first_tag"

#   echo -e "\n## [${first_tag#v}] - $(git log -1 --format=%cd --date=format:%Y-%m-%d "$first_tag")" >> "$changelog_file"
#   get_pr_changes "" "$first_tag" >> "$changelog_file" || echo "No changes." >> "$changelog_file"
# fi
