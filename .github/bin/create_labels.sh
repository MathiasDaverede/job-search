#!/bin/bash

# This script creates repository labels if they don't exist and sets dynamic labels.

set -e # Exit on any error

repository=$1 # ${{ github.repository }}
branch=$2   # ${{ github.event.pull_request.head.ref }}

echo "repository: $repository"
echo "head_ref: $head_ref"

declare -A labels=(
  ["synchronization"]="fef2c0|Automatic synchronization PR from release or hotfix to develop"
  ["feature"]="2fac4aff|New feature"
  ["release"]="43469fff|Release that contains some features"
  ["hotfix"]="a43a2eff|Hotfix to debug production fast"
)

# For PR auto created to sync develop
if [[ "$branch" == release/* ]]; then
  dynamic_label="release"
elif [[ "$branch" == hotfix/* ]]; then
  dynamic_label="hotfix"
fi

for label in "${!labels[@]}"; do
  # Extract color and description from associative array
  IFS='|' read -r color description <<< "${labels[$label]}"
  
  if ! gh api repos/"$repository"/labels/"$label" >/dev/null 2>&1; then
    echo "Label '$label' does not exist. Creating it..."
    gh label create "$label" --color "$color" --description "$description" --force
  else
    echo "Label '$label' already exists. Skipping creation."
  fi
done

# For PR auto created to sync develop
echo "LABEL_SYNCHRONISATION=synchronization" >> "$GITHUB_ENV" # ${{ env.LABEL_SYNCHRONISATION }}
echo "DYNAMIC_LABEL=$dynamic_label" >> "$GITHUB_ENV" # ${{ env.DYNAMIC_LABEL }}
