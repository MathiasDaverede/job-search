#!/bin/bash

target_branch=${{ github.base_ref }}
source_branch=${{ github.event.pull_request.head.ref }}

echo "Target branch '$target_branch'."
echo "Source branch '$source_branch'."

if [ "$target_branch" = "develop" ]; then
  if ! [[ $source_branch =~ ^feature/ ]]; then
    echo "Error: For target branch 'develop', the source branch must start with 'feature/'."
    exit 1
  fi
fi

if [ "$target_branch" = "main" ]; then
  if ! [[ $source_branch =~ ^(release|hotfix)/[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: For target branch 'main', the source branch must be in the format 'release/X.Y.Z' or 'hotfix/X.Y.Z'."
    exit 1
  fi
fi