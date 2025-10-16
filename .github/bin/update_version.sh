#!/bin/bash

set -e  # Exit on any error

pr_branch="$1"

if [[ ! "$pr_branch" =~ ^(release|hotfix)/[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Error: PR branch must be 'release/X.Y.Z' or 'hotfix/X.Y.Z'" >&2
  exit 1
fi

version=$(echo "$pr_branch" | sed -E 's/^(release|hotfix)\/([0-9]+\.[0-9]+\.[0-9]+)$/\2/')

echo "NEW_VERSION=v$version" >> "$GITHUB_ENV"
echo "${{ env.NEW_VERSION }}" > VERSION.md