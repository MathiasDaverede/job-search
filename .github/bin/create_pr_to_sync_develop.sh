#!/bin/bash

# This script creates a PR to sync commits from a release branch into develop after a release is merged into main.
# It cherry-picks all commits from release/X.Y.Z that are not in develop, mimicking "git flow release finish 'X.Y.Z'".
# It respects protected branches by creating a PR to develop.

set -e  # Exit on any error

repo=$1 # ${{ github.repository }}
version=$2 # ${{ env.VERSION }}
v_version="v$version"

# Create a new branch for syncing
sync_branch="sync/main-to-develop-$v_version"

echo "version : $version"
echo "v_version : $v_version"
echo "sync_branch : $sync_branch"

# Checkout develop and create sync branch
git checkout develop
git pull origin develop
git checkout -b "$sync_branch"

# Find the merge commit of the release in main
merge_commit=$(git log --merges --first-parent --grep="Merge branch 'release/$version'" origin/main -1 --pretty=%H)
echo "Merge commit for release/$version: $merge_commit"

# Get the second parent of the merge commit (tip of release/X.Y.Z)
release_tip=$(git rev-parse "$merge_commit^2" 2>/dev/null || echo "$merge_commit")
echo "Release tip (release/$version): $release_tip"

# Find commits in release/X.Y.Z that are not in develop
# Use merge-base to find the common ancestor between release/X.Y.Z and develop
merge_base=$(git merge-base "$release_tip" origin/develop)
echo "Merge base between release/$version and develop: $merge_base"

# Get all commits from release/X.Y.Z
commits=$(git log --pretty=format:"%H" "$merge_base".."$release_tip")
echo -e "Commits to cherry-pick:\n$commits"

if [ -n "$commits" ]; then
  while IFS= read -r commit; do
    echo "Cherry-picking commit: $commit"

    git cherry-pick "$commit" || {
      echo "Conflicts detected during cherry-pick. Please resolve manually." >&2
      exit 1
    }
  done <<< "$commits"
else
  debug "No commits to sync from release/$version"
fi

# Push the sync branch
git push origin "$sync_branch"

# Create a PR to merge sync branch into develop
pr_title="Sync main $v_version to develop"
pr_body="This PR synchronizes develop with main for release $v_version, including all changes from release/$version."

echo "pr_title: $pr_title"
echo  "pr_body: $pr_body"

gh pr create --base develop --head "$sync_branch" --title "$pr_title" --body "$pr_body" --repo "$repo" --label synchronization
echo "PR created successfully"