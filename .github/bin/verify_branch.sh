#!/bin/bash

target_branch=$1 # ${{ github.base_ref }}
source_branch=$2 # ${{ github.event.pull_request.head.ref }}

echo "Target branch '$target_branch'."
echo "Source branch '$source_branch'."

if [ "$target_branch" = "develop" ]; then
  if ! [[ $source_branch =~ ^feature/|^(release|hotfix)/[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: For target branch 'develop', the source branch name '$source_branch' does not follow the convention (feature/* or release/X.Y.Z or hotfix/X.Y.Z)."
    exit 1
  fi
fi

if [ "$target_branch" = "main" ]; then
  if ! [[ $source_branch =~ ^(release|hotfix)/[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: For target branch 'main', the source branch name '$source_branch' does not follow the convention (release/X.Y.Z or hotfix/X.Y.Z)."
    exit 1
  fi
fi

echo "Branch name '$source_branch' is valid."
