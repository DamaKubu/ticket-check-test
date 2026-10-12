#!/bin/sh
# Installs the commit-msg hook into one repo, or into every repo under a folder.
# Usage:
#   sh install-hooks.sh                 # the repo you're in
#   sh install-hooks.sh ~/projects      # every git repo under ~/projects
# Re-run after cloning new repos. Safe to re-run: it updates its own hook and
# never overwrites a different commit-msg hook that's already there.

src_dir=$(cd "$(dirname "$0")" && pwd)
src="$src_dir/hooks/commit-msg"
marker="ticket-commit-msg-hook"

install_into() {
  repo="$1"
  hooks_dir=$(git -C "$repo" rev-parse --git-path hooks) || return
  case "$hooks_dir" in /*) ;; *) hooks_dir="$repo/$hooks_dir" ;; esac
  dest="$hooks_dir/commit-msg"

  if [ -f "$dest" ] && ! grep -q "$marker" "$dest"; then
    echo "skip  $repo (already has its own commit-msg hook)"
    return
  fi
  mkdir -p "$hooks_dir"
  cp "$src" "$dest" && chmod +x "$dest" && echo "ok    $repo"
}

target="${1:-.}"
if git -C "$target" rev-parse --is-inside-work-tree >/dev/null 2>&1 && [ -z "$1" ]; then
  install_into "$(git -C "$target" rev-parse --show-toplevel)"
else
  find "$target" -maxdepth 4 -name .git -prune -print 2>/dev/null | while read -r gitdir; do
    install_into "$(dirname "$gitdir")"
  done
fi
