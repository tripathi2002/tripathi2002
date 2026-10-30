#!/usr/bin/env bash
set -euo pipefail
USER_NAME="${USER_NAME:-tripathi2002}"
list=$(gh api "users/$USER_NAME/repos?per_page=100&sort=updated&type=owner" \
  --jq "[.[] | select(.fork|not) | select(.name != \"$USER_NAME\")] | sort_by(.pushed_at) | reverse | .[:5][] | \"- [\(.name)](\(.html_url))\" + (if .description and .description != \"\" then \" — \(.description)\" else \"\" end)")
awk -v list="$list" '
/<!-- LATEST_REPOS:START -->/ {print; print list; skip=1; next}
/<!-- LATEST_REPOS:END -->/ {skip=0}
!skip {print}' README.md > README.tmp && mv README.tmp README.md
