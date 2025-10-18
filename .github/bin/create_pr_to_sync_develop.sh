#!/bin/bash

set -e  # Exit on any error

new_version=$1 # ${{ env.NEW_VERSION }}

pr_title="Sync develop with main after release $new_version"

pr_body="This PR synchronizes the develop branch with main after merging release $new_version.\n\n"
pr_body+="If merge conflicts occur:\n"
pr_body+="1. Create a branch 'sync-main-$new_version-to-develop' from develop.\n"
pr_body+="2. Merge main into this branch and resolve conflicts.\n"
pr_body+="3. Push the branch to origin.\n"
pr_body+="4. Update this PR to use 'sync-main-$new_version-to-develop' as the source branch.\n"
pr_body+="5. Verify tests pass before merging."

echo "pr_title: $pr_title"
echo -e "pr_body:\n$pr_body"

pr_url=$(gh pr create --base develop --head main --title "$pr_title" --body "$pr_body" --label synchronization)

echo "pr_url: $pr_url"

pr_number=$(echo "$pr_url" | grep -oE '[0-9]+$')

echo "pr_number=$pr_number" >> $GITHUB_OUTPUT

# Verify if there are conflicts in PR
conflict_status=$(gh api repos/{owner}/{repo}/pulls/$pr_number | jq -r .mergeable)

echo "conflict_status=$conflict_status" >> $GITHUB_OUTPUT

if [ "$conflict_status" = "false" ]; then
    comment="This PR has merge conflicts.\n"
    comment+="Since 'main' is protected, please resolve them manually:\n"
    comment+="1. Create a branch 'sync-main-$new_version-to-develop' from develop.\n"
    comment+="2. Merge main into this branch and resolve conflicts.\n"
    comment+="3. Push the branch to origin.\n"
    comment+="4. Update this PR to use 'sync-main-$new_version-to-develop' as the source branch.\n"
    comment+="5. Verify tests pass."
    
    gh pr comment $pr_number --body $comment
else
    echo "No merge conflicts detected in PR #$pr_number"
fi