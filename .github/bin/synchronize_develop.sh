#!/bin/bash

# This script creates a PR to sync commits from a release branch into develop after a release is merged into main.
# It cherry-picks all commits from release/X.Y.Z that are not in develop, mimicking "git flow release finish 'X.Y.Z'".
# It respects protected branches by creating a PR to develop.

set -e  # Exit on any error

# vX.Y.Z
v_version=$1 # ${{ env.V_VERSION }}

# release/X.Y.Z or hotfix/X.Y.Z
branch=$2 # ${{ github.event.pull_request.head.ref }}

# Create a new branch for syncing
sync_branch="sync-$v_version-to-develop"

echo "v_version : $v_version"
echo "branch : $branch"
echo "sync_branch : $sync_branch"

# Checkout develop and create sync branch
git checkout develop
git checkout -b "$sync_branch"

# Fetch the release/hotfix branch explicitly
git fetch origin $branch

# Merge the release/hotfix branch into the temporary branch
git merge --no-ff $branch

# Push the syncing branch to the repository
git push origin $sync_branch


pr_title="Sync $branch to develop"
pr_body="Automatic PR to sync $branch with develop after merge into main."

# Must exist in Github repository (means to be created)
pr_label="synchronization"

echo "pr_title: $pr_title"
echo  "pr_body: $pr_body"

# Create a PR to merge sync branch into develop
gh pr create --base develop --head "$sync_branch" --title "$pr_title" --body "$pr_body" --label "$pr_label"
echo "PR created successfully"
