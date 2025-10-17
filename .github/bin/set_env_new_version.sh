#!/bin/bash

set -e  # Exit on any error

pr_branch=$1 # ${{ github.event.pull_request.head.ref }}

version=$(echo "$pr_branch" | sed -E 's/^(release|hotfix)\/([0-9]+\.[0-9]+\.[0-9]+)$/\2/')

echo "NEW_VERSION=v$version" >> "$GITHUB_ENV" # ${{ env.NEW_VERSION }}
