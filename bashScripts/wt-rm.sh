#!/usr/bin/env bash
# Remove a worktree created by wt-new.sh (and, by default, its branch).
#
# Usage: bashScripts/wt-rm.sh <name> [--keep-branch]
#   <name>          worktree/branch name to remove
#   --keep-branch   keep the branch, only remove the worktree folder
set -euo pipefail

name="${1:?usage: wt-rm.sh <name> [--keep-branch]}"
keep_branch="${2:-}"

repo_root="$(git rev-parse --show-toplevel)"
wt_dir="${SM_WT_DIR:-$(dirname "$repo_root")/sm-worktrees}"
dest="$wt_dir/$name"

git -C "$repo_root" worktree remove "$dest"
echo "Removed worktree: $dest"

if [[ "$keep_branch" != "--keep-branch" ]]; then
  git -C "$repo_root" branch -d "$name" \
    || echo "Branch '$name' not fully merged; delete with: git branch -D $name"
fi
