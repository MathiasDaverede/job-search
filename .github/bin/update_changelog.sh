#!/bin/bash

# This script regenerates the entire CHANGELOG.md file based on merged Pull Request titles.
# It assumes:
# - PR titles follow Conventional Commits (e.g., feat:, fix:, chore:).
# - PRs are merged into develop (features) or main (releases or hotfixes).
# - Git tags (e.g., vX.Y.Z) exist for previous releases.
# - Overwrites CHANGELOG.md completely to allow header/structure changes.

set -e # Exit on error

repo=$1 # ${{ github.repository }}
version=$2 # ${{ env.NEW_VERSION }}

changelog_file="CHANGELOG.md"
date=$(date +%Y-%m-%d)

# Function to get PR titles for commits between two refs (from_ref..to_ref)
# Uses `gh pr list` to fetch merged PRs associated with commits
get_pr_changes() {
  local from_ref="$1"
  local to_ref="$2"
  local prs
  local commits

  # Get commit SHAs in range (use --first-parent to focus on merge commits)
  commits=$(git log --first-parent --pretty=format:"%H" "$from_ref".."$to_ref")

  echo -e "commits :\n$commits"

  # Initialize arrays for categorized changes
  local added=""
  local fixed=""
  local changed=""
  local breaking=""

  # Iterate over commits to find associated PRs
  while IFS= read -r commit; do
    # Find PR associated with the commit
    pr_info=$(gh pr list --state merged --repo "$repo" --search "$commit" --json title,labels,mergedAt --jq '.[] | "\(.title)|\(.labels[].name)|\(.mergedAt)"' || echo "")

    echo -e "pr_info :\n$pr_info"

    if [ -n "$pr_info" ]; then
      title=$(echo "$pr_info" | cut -d'|' -f1)
      labels=$(echo "$pr_info" | cut -d'|' -f2)

      echo "title : $title"
      echo -e "labels :\n$labels"

      # TODO label breaking ?

      # Categorize based on PR title prefix
      if [[ "$title" =~ ^feat: ]]; then
        added+="- $title\n"
      elif [[ "$title" =~ ^fix: ]]; then
        fixed+="- $title\n"
      elif [[ "$title" =~ ^(chore|docs|refactor|style|test|perf|ci|build): ]]; then
        changed+="- $title\n"
      fi

      # Check for breaking change label
      if echo "$labels" | grep -q "breaking"; then
        breaking+="- $title\n"
      fi
    fi
  done <<< "$commits"

  # Output sections only if not empty
  [ -n "$breaking" ] && echo "### Breaking Changes" && echo -e "$breaking"
  [ -n "$added" ] && echo "### Added" && echo -e "$added"
  [ -n "$fixed" ] && echo "### Fixed" && echo -e "$fixed"
  [ -n "$changed" ] && echo "### Changed" && echo -e "$changed"
}

# Start fresh: overwrite CHANGELOG with header
changelog_header="# Changelog\n\n"
changelog_header+="All notable changes to this project are documented in this file.\n\n"
changelog_header+="The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),\n"
changelog_header+="and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html)."

echo -e $changelog_header > "$changelog_file"

# Get all tags sorted by version (assuming vX.Y.Z format)
tags=$(git tag -l 'v*' --sort=-v:refname)

# Convert tags to array
readarray -t TAG_ARRAY <<< "$tags"

# Current version (not yet tagged, use HEAD)
echo -e "\n## [${version}] - ${date}" >> "$changelog_file"
get_pr_changes "${TAG_ARRAY[0]}" HEAD >> "$changelog_file" || echo "No changes." >> "$changelog_file"

# Loop over previous tags (from newest to oldest, excluding the first which is latest)
for ((i=1; i<${#TAG_ARRAY[@]}; i++)); do
  prev_tag="${TAG_ARRAY[$i]}"
  curr_tag="${TAG_ARRAY[$i-1]}"
  
  # Get release date from tag commit
  release_date=$(git log -1 --format=%cd --date=format:%Y-%m-%d "$curr_tag")
  
  echo -e "\n## [${curr_tag#v}] - ${release_date}" >> "$changelog_file"
  get_pr_changes "$prev_tag" "$curr_tag" >> "$changelog_file" || echo "No changes." >> "$changelog_file"
done

# Handle changes before first tag (if any)
if [ ${#TAG_ARRAY[@]} -gt 0 ]; then
  first_tag="${TAG_ARRAY[-1]}"
  echo -e "\n## [${first_tag#v}] - $(git log -1 --format=%cd --date=format:%Y-%m-%d "$first_tag")" >> "$changelog_file"
  get_pr_changes "" "$first_tag" >> "$changelog_file" || echo "No changes." >> "$changelog_file"
fi

# Add the updated CHANGELOG to git (for commit in workflow)
git add "$changelog_file"