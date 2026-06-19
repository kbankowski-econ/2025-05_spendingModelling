#!/usr/bin/env bash
# Create a git worktree for parallel (agent) work on this repo.
#
# Usage: bashScripts/wt-new.sh <name> [base-branch]
#   <name>        branch + folder name for the new worktree (e.g. feat-multipliers)
#   [base-branch] branch/commit to fork from (default: main)
#
# Worktrees are created as siblings of the repo under $SM_WT_DIR
# (default: <repo-parent>/sm-worktrees). Git LFS objects are shared with the
# main checkout, so only the smudged working files cost disk per worktree.
#
# Each worktree gets a rewritten copy of the gitignored
# +utils/+call/paths.m so MATLAB/Dynare runs against the worktree itself,
# not the main checkout. Local .claude/settings.local.json is copied too.
set -euo pipefail

name="${1:?usage: wt-new.sh <name> [base-branch]}"
base="${2:-main}"

repo_root="$(git rev-parse --show-toplevel)"
wt_dir="${SM_WT_DIR:-$(dirname "$repo_root")/sm-worktrees}"
dest="$wt_dir/$name"

mkdir -p "$wt_dir"

# Create the worktree on a new branch forked from base.
git -C "$repo_root" worktree add -b "$name" "$dest" "$base"

# Copy + rewrite the machine-local MATLAB paths file (gitignored, not carried
# over by `worktree add`). project_path must point at the worktree.
src_paths="$repo_root/+utils/+call/paths.m"
if [[ -f "$src_paths" ]]; then
  sed "s|^project_path .*|project_path        = \"$dest\";|" \
    "$src_paths" > "$dest/+utils/+call/paths.m"
  echo "paths.m copied; project_path -> $dest"
else
  echo "WARNING: $src_paths not found; create +utils/+call/paths.m in the worktree manually."
fi

# Copy local Claude settings if present (gitignored).
src_settings="$repo_root/.claude/settings.local.json"
if [[ -f "$src_settings" ]]; then
  mkdir -p "$dest/.claude"
  cp "$src_settings" "$dest/.claude/settings.local.json"
  echo "settings.local.json copied"
fi

echo "Worktree ready: $dest  (branch: $name, base: $base)"
