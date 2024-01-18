# Compnav setup. See readme for instructions.
#
# Source this only from interactive shell startup scripts (like .bashrc or zshrc).

up() { cd "$(ruby "$COMPNAV_DIR/up.rb" "$@")" || return; }

z() {
  # Start fzf with the first argument, if given, as the query.
  # Don't show the interactive fzf finder if there's 1 or 0 matches.
  dir=$(ruby "$COMPNAV_DIR/z.rb" | \
    fzf $([ -n "$1" ] && echo "--query $1") --select-1 --exit-0) &&
  # Use eval to expand home directory if present.
  cd "$(eval echo "$dir")" || return
}

h() {
  # See comments on z().
  dir=$(ruby "$COMPNAV_DIR/h.rb" "$COMPNAV_H_REPOS_DIR" "$1" | \
    fzf $([ -n "$1" ] && echo "--query $1") --select-1 --exit-0) &&
  cd "$(eval echo "$dir")" || return
}

cd() {
  builtin cd "$@" || return;
  # If the dir existed and was different than the old dir, update .z file.
  [ "$OLDPWD" = "$PWD" ] || ruby "$COMPNAV_DIR/z.rb" --add "$PWD"
}

# Add the initial pwd at shell session startup.
ruby "$COMPNAV_DIR/z.rb" --add "$PWD"