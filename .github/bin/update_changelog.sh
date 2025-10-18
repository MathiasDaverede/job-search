#!/bin/bash

set -e  # Exit on any error

repo=$1 # ${{ github.repository }}
new_version=$2 # ${{ env.NEW_VERSION }}

echo "Repository '$repo'."
echo "New version '$new_version'."

changelog_header="# Changelog\n\n"
changelog_header+="All notable changes to this project are documented in this file.\n\n"

changelog_content="## $new_version - $(date +%Y-%m-%d)\n"
changelog_content+="[Release $new_version](https://github.com/$repo/releases/tag/$new_version)\n\n"

# Get the previous tag to determine the date range for merged PRs
previous_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
if [ -n "$previous_tag" ]; then
  tag_date=$(git log -1 --format=%ci "${previous_tag}" | cut -d' ' -f1)
else
  tag_date="1970-01-01"
fi

# Fetch PRs merged into develop since the last tag
pr_list=$(gh pr list --repo "$repo" --state merged --base develop --search "merged:>$tag_date" --json number,title,mergedAt --jq '.[] | "\(.number) \(.title)"')

# Process merged PRs
pr_found=0
while IFS= read -r pr; do
  echo "PR: '$pr'."

  if [[ $pr =~ ^([0-9]+)[[:space:]]+(feat|fix):[[:space:]]*(.+?)([[:space:]]*\[closes[[:space:]]*#([0-9]+)\])?$ ]]; then
    pr_number="${BASH_REMATCH[1]}"
    type="${BASH_REMATCH[2]}"
    description="${BASH_REMATCH[3]}"
    issue_number="${BASH_REMATCH[5]}" # Will be empty if [closes #N] is not present
    pr_found=1

    echo "pr_number: '$pr_number'."
    echo "type: '$type'."
    echo "description: '$description'."
    echo "issue_number: '$issue_number'."

    if [ -n "$issue_number" ]; then
      issue_title=$(gh issue view "${issue_number}" --repo "${repo}" --json title --jq .title 2>/dev/null || echo "Issue not found")

      echo "issue_title: '$issue_title'."

      if [ -n "$issue_title" ] && [ "$issue_title" != "Issue not found" ]; then
        changelog_content+="- ${type} [#${issue_number}](https://github.com/${repo}/issues/${issue_number}) ${issue_title}\n"
      else
        echo "Warning: Issue #${issue_number} not found for PR #${pr_number}, using PR title" >&2
        changelog_content+="- ${type} [#${pr_number}](https://github.com/${repo}/pull/${pr_number}) ${description}\n"
      fi
    else
      echo "Info: No issue linked for PR #${pr_number}, using PR title" >&2
      changelog_content+="- ${type} [#${pr_number}](https://github.com/${repo}/pull/${pr_number}) ${description}\n"
    fi
  else
    pr_number=$(echo "${pr}" | cut -d' ' -f1)
    echo "Warning: Skipping PR #${pr_number}: Title does not match 'feat|fix' format" >&2
  fi
done <<< "${pr_list}"

if [ ${pr_found} -eq 0 ]; then
  echo "Warning: No merged PRs found in develop since ${tag_date}, changelog will only include header" >&2
fi

# Ensure a newline before appending existing content
changelog_content+="\n"

echo -e "changelog_header :\n$changelog_header\n"
echo -e "changelog_content :\n$changelog_content\n"
echo -e "CHANGELOG.md :\n$(cat CHANGELOG.md)"

# Write to CHANGELOG.md
if [ -f CHANGELOG.md ]; then
  echo -e "${changelog_header}${changelog_content}$(cat CHANGELOG.md)" > CHANGELOG.md
else
  echo -e "${changelog_header}${changelog_content}" > CHANGELOG.md
fi