#!/bin/bash

VERSION_TYPE_CURRENT_VERSION="current_version"
VERSION_TYPE_RELEASE="Release"
VERSION_TYPE_HOTFIX="Hotfix"

DATE_FORMAT_Y_M_D="%Y-%m-%d"
DATE_FORMAT_Y_M_D_H_M_S_Z="%Y-%m-%d %H:%M:%S %z"

# feat, chore(CI), etc.
# Group 1: Full type + Scope (e.g., fix or chore(CI))
# Group 2: Type only (e.g., fix)
# Group 3: Scope only (e.g., (CI))
CHANGELOG_TYPES_PATTERN="((feat|fix|chore|docs|refactor|style|test|perf|ci|build)(\([A-Za-z]+\))?)"

# There are more that i don't use :
# Automatically close an issue :
#   close, closes, closed,
#   fix, fixes, fixed,
#   resolve, resolves, resolved,
# Common Unofficial Keywords :
#   relates to, related to,
#   ref, refs,
#   see, addresses, part of
#   re (reopen an issue but unsupported by Github),
# Group 6: Action
CHANGELOG_ACTIONS_PATTERN="(close|fix|resolve)"

# We are looking for lines containing :
#   type(scope): title ([action #issue_number])
#     - feat: a feature [closes #1]
#     - fix: a bug fix [fixes #2]
#     - fix: another bug fix [resolves #3]
#     - chore(CI): a chore
# Group 1: Full type + Scope (e.g., fix ou chore(CI))
# Group 2: Type only (e.g., fix)
# Group 3: Scope only (e.g., (CI))
# Group 4: Description (non-greedy)
# Group 5: Full optional closure (e.g., [fix #2])
# Group 6: Action (e.g., fix)
# Group 7: Issue number (e.g., 2)
CHANGELOG_PATTERN="^\s*-\s*$CHANGELOG_TYPES_PATTERN:\s*(.*?)(\s*\($CHANGELOG_ACTIONS_PATTERN\s*#([0-9]+)\))?\s*$"

CHANGELOG_DELIMITER="####"

# Debug function to print to stderr
debug() {
  echo -e "$@" >&2
}

# @param date        (string) "YYYY-MM-DDTHH:MM:SSZ"
# @param date_format (string) a valid format like globals variables above
#
# @returns (string)
#
# @note Exits with status 1 if the input date is invalid.
format_date() {
  local date=$1
  local date_format=$2

  echo $(date -d "$date" +"$date_format")
}

# @param version_type (string) Release or Hotfix
# @param v_version    (string) vX.Y.Z
# @param date         (string)
#
# @return (string)
get_version_header() {
  local version_type=$1
  local v_version=$2
  local date=$3
  
  echo -e "## [${v_version#v}] - $(format_date $date $DATE_FORMAT_Y_M_D)\n"
  echo -e "[$version_type ${v_version}](https://github.com/$repo/releases/tag/${v_version})\n"
}

# @param tag (string) vX.Y.Z
#
# @return (string)
is_hotfix_tag() {
  local tag=$1
  local patch_number=$(echo $tag | perl -ne '/^v([0-9]+)\.([0-9]+)\.([0-9]+)/ && print $3')

  if [[ $patch_number == "0" ]]; then
    echo "false"
  else
    echo "true"
  fi
}

# @param version_type (string)
# @param from_date    (string)
# @param to_date      (string)
#
# @return (string)
get_prs() {
  local version_type=$1

  debug "get_prs()"
  debug "version_type : $version_type"

  # "gh pr list" options
  # --search : GitHub search query to filter PRs (e.g., is:merged, merged:>=date)
  # --limit : set maximum number of PRs to fetch (default is 30, increased for larger projects)
  # --json : output PR data in JSON format with specified fields
  #   available fields for --json:
  #     number, title, body, state, createdAt, updatedAt, closedAt, mergedAt, labels,
  #     author, assignees, reviewers, headRefName, baseRefName, headRefOid, baseRefOid,
  #     mergeCommit, additions, deletions, url, id, isDraft, milestone, commitCount, changedFiles
  # --jq : filter and transform JSON output into a formatted string
  #   .[] : Iterate over each PR in the JSON array
  #   \(.field) : extract a field specified in --json (e.g., .title, .number)
  #   \(.field | map(.name) | join(",")) : concatenate array field values (e.g., labels) into a comma-separated string
  #   \(.field | gsub("\n"; "||")) : replace "\n" by "||" in field content, otherwise new lines will be interpreted as a PR
  local prs
  local options=()
  local jq_filters

  # A current version PR is not merged yet and by default "gh pr list" get opened PRs
  if ! [[ $version_type == $VERSION_TYPE_CURRENT_VERSION ]]; then
    local from_date=$2
    local to_date=$3
    
    debug "Merged between $(format_date $from_date "$DATE_FORMAT_Y_M_D_H_M_S_Z") and $(format_date $to_date "$DATE_FORMAT_Y_M_D_H_M_S_Z")"

    options+=("--search" "merged:>=$from_date merged:<=$to_date")
  fi

  options+=("--json" "title,labels,body")
  jq_filters='.[] | "\(.title)|\(.labels | map(.name) | join(","))|\(.body | gsub("\n"; "||"))"'

  options+=("--jq" "$jq_filters")

  debug "options: ${options[*]}"
  debug "jq_filters: $jq_filters"

  prs=$(gh pr list "${options[@]}")

  debug "prs _________________"
  debug "$prs"
  debug "_____________________\n"

  echo "$prs"
}

# @param version_type (string)
# @param from_date    (string)
# @param to_date      (string)
#
# @return (string)
get_version_changes() {
  local version_type=$1

  debug "get_version_changes()"
  debug "version_type : $version_type"

  local prs

  if [[ $version_type == $VERSION_TYPE_CURRENT_VERSION ]]; then
    prs=$(get_prs $version_type)
  else
    local from_date=$2
    local to_date=$3

    debug "Between $(format_date $from_date "$DATE_FORMAT_Y_M_D_H_M_S_Z") and $(format_date $to_date "$DATE_FORMAT_Y_M_D_H_M_S_Z")"

    prs=$(get_prs $version_type $from_date $to_date)
  fi

  local added=""
  local fixed=""
  local changed=""
  local breaking=""

  while IFS='|' read -r pr_title pr_labels pr_body; do
    debug "pr_title : $pr_title"

    # PRs titles must be like :
    #   version_type : X.Y.Z - summary
    #     Release : 1.0.0 - First release
    #     Hotfix : 1.0.1 - First bug correction
    if ! [[ "$pr_title" =~ ^(Release|Hotfix)\ : ]]; then
      debug "Wrong PR title syntaxe '^(Release|Hotfix)\ :' : Skipped"
      continue
    fi

    debug "pr_labels : $pr_labels"

    
    if [ -z "$pr_body" ]; then
      debug "No description : skipped"
      continue
    fi

    body_lines=$(echo "$pr_body" | tr '||' '\n')

    while IFS='\n' read -r line; do
      local type=$(echo "$line" | perl -ne "print \$1 if /$CHANGELOG_PATTERN/")
      local title=$(echo "$line" | perl -ne "print \$4 if /$CHANGELOG_PATTERN/")
      local issue_number=$(echo "$line" | perl -ne "print \$7 if /$CHANGELOG_PATTERN/")

      if [[ "$type" == "" ]] || [[ "$title" == "" ]]; then
          continue
      fi

      local changelog_entry=$type

      if [ -n "$issue_number" ]; then
        changelog_entry+=" [#$issue_number](https://github.com/$repo/issues/$issue_number)"
      fi

      changelog_entry+=": $title"

      debug "Body line : $line"
      #debug "Body line (hex) : $(echo -n "$line" | od -c)"
      debug "type : $type"
      debug "title : $title"
      debug "issue_number : $issue_number"
      debug "changelog_entry : $changelog_entry"

      if [[ $type =~ ^feat ]]; then
        added+="- $changelog_entry\n"
      elif [[ $type =~ ^fix ]]; then
        fixed+="- $changelog_entry\n"
      else
        changed+="- $changelog_entry\n"
      fi

      # Check for breaking change label
      if echo $labels | grep -q "breaking"; then
        breaking+="- $title\n"
      fi
    done <<< "$body_lines"
  done <<< "$prs"

  debug "\n"
  debug "breaking __________________"
  debug "$breaking"
  debug "___________________________\n"
  debug "added _____________________"
  debug "$added"
  debug "___________________________\n"
  debug "fixed _____________________"
  debug "$fixed"
  debug "___________________________\n"
  debug "changed ___________________"
  debug "$changed"
  debug "___________________________\n"

  # Output sections only if not empty
  [ -n "$breaking" ] && echo -e "### Breaking Changes\n" && echo -e "$breaking"
  [ -n "$added" ] && echo -e "### Added\n" && echo -e "$added"
  [ -n "$fixed" ] && echo -e "### Fixed\n" && echo -e "$fixed"
  [ -n "$changed" ] && echo -e "### Changed\n" && echo -e "$changed"

  # For example if "$changed" is empty [ -n "$changed" ] will fail with an exit code 1
  return 0
}

# Manage current release or hotfix
#
# @param futur_tag (string)
manage_current_version() {
  debug "manage_current_version()"

  local futur_tag=$1
  local today_date=$(date --iso-8601=seconds) # Format YYYY-MM-DDTHH:MM:SSZ

  local version_type=$VERSION_TYPE_RELEASE

  if [[ $(is_hotfix_tag $futur_tag) == "true" ]]; then
    version_type=$VERSION_TYPE_HOTFIX
  fi

  debug "futur_tag : $futur_tag ($(format_date $today_date "$DATE_FORMAT_Y_M_D_H_M_S_Z"))"
  debug "version_type : $version_type"

  get_version_header $version_type $futur_tag $today_date >> "CHANGELOG.md"
  get_version_changes $VERSION_TYPE_CURRENT_VERSION >> "CHANGELOG.md"
}

# Manage releases and hotfixes between tags
#
# @param tags_array (array)
manage_versions_between_tags() {
  debug "manage_versions_between_tags()"

  local -a tags_array=("$@")

  debug "tags_array : ${tags_array[*]}"
  
  for ((i=1; i < ${#tags_array[@]}; i++)); do
    version_tag="${tags_array[$i-1]}"
    version_date=$(git log -1 --format=%cd --date=iso8601-strict $version_tag)
    previous_tag="${tags_array[$i]}"
    previous_date=$(git log -1 --format=%cd --date=iso8601-strict $previous_tag)
    
    local version_type=$VERSION_TYPE_RELEASE

    if [ $(is_hotfix_tag $version_tag) == "true" ]; then
      version_type=$VERSION_TYPE_HOTFIX
    fi

    debug "version_tag : $version_tag ($(format_date $version_date "$DATE_FORMAT_Y_M_D_H_M_S_Z"))"
    debug "version_type : $version_type"
    debug "previous_tag : $previous_tag ($(format_date $previous_date "$DATE_FORMAT_Y_M_D_H_M_S_Z"))"

    get_version_header $version_type $version_tag $version_date >> "CHANGELOG.md"
    get_version_changes $version_type $previous_date $version_date >> "CHANGELOG.md"
  done
}

# From the beginning to the first tag
#
# @param first_tag (string)
manage_first_release() {
  debug "manage_first_release()"

  local first_tag=$1
  local release_date=$(git log -1 --format=%cd --date=iso8601-strict $first_tag)
  local first_commit=$(git rev-list --max-parents=0 HEAD)
  local first_commit_date=$(git log -1 --format=%cd --date=iso8601-strict $first_commit)

  debug "first_tag : $first_tag ($(format_date $release_date "$DATE_FORMAT_Y_M_D_H_M_S_Z"))"
  debug "first_commit : $first_commit ($(format_date $first_commit_date "$DATE_FORMAT_Y_M_D_H_M_S_Z"))"

  get_version_header $VERSION_TYPE_RELEASE $first_tag $release_date >> "CHANGELOG.md"
  get_version_changes $VERSION_TYPE_RELEASE $first_commit_date $release_date >> "CHANGELOG.md"
}
