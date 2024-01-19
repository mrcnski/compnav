# Compnav setup. See readme for instructions.
#
# Source this only from interactive shell startup scripts (like .bashrc or zshrc).

up() { 
  # Start fzf with any given arguments as the query.
  # Don't show the interactive fzf finder if there's 1 or 0 matches.

  # --sync --bind 'start:accept' accepts the first match for you when fzf finishes listing.
  # Remove if you don't want this behavior.
  dir=$(ruby "$COMPNAV_DIR/up.rb" | \
    fzf --query "$*" --select-1 --exit-0 --sync --bind 'start:accept') &&
  # Use eval to expand home directory if present.
  cd "$(eval echo "$dir")" || return; 
}

z() {
  # See comments on up().
  dir=$(ruby "$COMPNAV_DIR/z.rb" | \
    fzf --tac --query "$*" --select-1 --exit-0) &&
  cd "$(eval echo "$dir")" || return
}

h() {
  query_args=""
  # Only seed initial query to fzf if a repo link is not given.
  [[ $1 != http* ]] && query_args="$*"
  # See comments on up().
  dir=$(ruby "$COMPNAV_DIR/h.rb" "$COMPNAV_H_REPOS_DIR" "$1" | \
    fzf --tac --query "$query_args" --select-1 --exit-0) &&
  cd "$(eval echo "$dir")" || return
}

cd() {
  builtin cd "$@" || return;
  # If the dir existed and was different than the old dir, update .z file.
  [ "$OLDPWD" = "$PWD" ] || ruby "$COMPNAV_DIR/z.rb" --add "$PWD"
}

# Add the initial pwd at shell session startup.
ruby "$COMPNAV_DIR/z.rb" --add "$PWD"