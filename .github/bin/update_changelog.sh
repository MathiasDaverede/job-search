#!/bin/bash

# This script regenerates the entire CHANGELOG.md file based on merged Pull Request titles.
# It assumes:
# - PR titles follow Conventional Commits (e.g., feat:, fix:, chore:).
# - PRs are merged into develop (features) or main (releases or hotfixes).
# - Git tags (e.g., vX.Y.Z) exist for previous releases.
# - Overwrites CHANGELOG.md completely to allow header/structure changes.

set -e # Exit on error

source .github/bin/changelog_functions.sh

repo=$1 # ${{ github.repository }}
v_version=$2 # ${{ env.V_VERSION }}

changelog_header="# Changelog\n\n"
changelog_header+="All notable changes to this project are documented in this file.\n\n"
changelog_header+="The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),  \n"
changelog_header+="and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).\n"

echo -e $changelog_header > "CHANGELOG.md"

# Get all tags (vX.Y.Z) sorted by version (from newest to oldest)
tags=$(git tag -l 'v*' --sort=-v:refname)

debug "Tags found :\n$tags"

# Convert tags to array
readarray -t tags_array <<< $tags

last_tag=${tags_array[0]}
first_tag="${tags_array[-1]}"

debug_prs

manage_current_release $v_version $last_tag
manage_releases_between_tags ${tags_array[@]}
manage_first_release $first_tag

# Handle changes before first tag (if any)
# if [ ${#TAG_ARRAY[@]} -gt 0 ]; then
#   first_tag="${TAG_ARRAY[-1]}"

#   debug "first_tag : $first_tag"

#   echo -e "\n## [${first_tag#v}] - $(git log -1 --format=%cd --date=format:%Y-%m-%d "$first_tag")" >> "$changelog_file"
#   get_pr_changes "" "$first_tag" >> "$changelog_file" || echo "No changes." >> "$changelog_file"
# fi
