#!/bin/bash

# This script regenerates the entire CHANGELOG.md file based on PRs titles and descriptions.
# It assumes:
# - PRs titles are like :
#   version_type : X.Y.Z - summary
#     Release : 1.0.0 - First release
#     Hotfix : 1.0.1 - First bug correction
# - PRs descriptions contain lines like :
#   type(scope): title (action #issue_number)
#     - feat: a feature (closes #1)
#     - fix: a bug fix (fixes #2)
#     - fix: another bug fix (resolves #3)
#     - chore(CI): a chore
# - Git tags (e.g., vX.Y.Z) exist for previous versions (e.g., releases or hotfixes).
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

manage_current_version $v_version

if [[ $v_version != "v1.0.0" ]]; then
    # Get all tags (vX.Y.Z) sorted by version (from newest to oldest)
    tags=$(git tag -l 'v*' --sort=-v:refname)

    debug "Tags found :\n$tags"

    # Convert tags to array
    readarray -t tags_array <<< $tags

    first_tag=${tags_array[-1]}

    manage_versions_between_tags ${tags_array[@]}
    manage_first_release $first_tag
fi
