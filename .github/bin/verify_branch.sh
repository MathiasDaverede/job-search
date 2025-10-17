#!/bin/bash

target_branch=$1 # ${{ github.base_ref }}
source_branch=$2 # ${{ github.event.pull_request.head.ref }}

echo "Target branch '$target_branch'."
echo "Source branch '$source_branch'."

# Check if the target branch is empty
if [ -z "$target_branch" ]; then
  echo "Error: No target branch provided."
  exit 1
fi

# Check if the source branch is empty
if [ -z "$source_branch" ]; then
  echo "Error: No source branch provided."
  exit 1
fi

if [ "$target_branch" = "develop" ]; then
  if ! [[ $source_branch =~ ^feature/|^sync-develop-v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: For target branch 'develop', the source branch name '$source_branch' does not follow the convention (feature/* or sync-develop-vX.Y.Z)."
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
