#!/bin/bash

set -e  # Exit on any error

pr_branch=$1 # ${{ github.event.pull_request.head.ref }}

# Check if the PR branch is empty
if [ -z "$pr_branch" ]; then
  echo "Error: No PR branch provided."
  exit 1
fi

version=$(echo "$pr_branch" | sed -E 's/^(release|hotfix)\/([0-9]+\.[0-9]+\.[0-9]+)$/\2/')
new_version="v$version"

echo "NEW_VERSION=$new_version" >> "$GITHUB_ENV" # ${{ env.NEW_VERSION }}
echo "$new_version" > VERSION.md
