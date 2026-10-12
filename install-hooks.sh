#!/bin/sh
# Installs the commit-msg hook into the git repo you run this from.
# Usage: cd path/to/repo && sh /path/to/pre_commit_hooks/install-hooks.sh
set -e

src_dir=$(cd "$(dirname "$0")" && pwd)
hooks_dir=$(git rev-parse --git-path hooks)

mkdir -p "$hooks_dir"
cp "$src_dir/hooks/commit-msg" "$hooks_dir/commit-msg"
chmod +x "$hooks_dir/commit-msg"
echo "Installed commit-msg hook into $hooks_dir"
