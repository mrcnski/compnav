# Compnav setup. See readme for instructions.
#
# Source this only from interactive shell startup scripts (like .bashrc or zshrc).

up() { 
  # Pass COMPNAV_FZF_UP_OPTS to fzf if set, or use the default set of options.
  # 
  # --select-1 --exit-0: Don't show the interactive fzf finder if there's 1 or 0 matches.
  # --sync --bind 'start:accept': Accepts the first match for you when fzf finishes listing.
  dir=$(COMPNAV_FZF_UP_OPTS="${COMPNAV_FZF_UP_OPTS:---select-1 --exit-0 --sync --bind 'start:accept'}" \
    ruby "$COMPNAV_DIR/up.rb" "$*") &&
    # Use eval to expand home directory if present.
    cd "$(eval echo "$dir")" || return; 
}

z() {
  # See comments on up().
  dir=$(COMPNAV_FZF_Z_OPTS="${COMPNAV_FZF_Z_OPTS:---select-1 --exit-0}" \
    ruby "$COMPNAV_DIR/z.rb" "$*") &&
    cd "$(eval echo "$dir")" || return;
}

h() {
  # See comments on up().
  dir=$(COMPNAV_FZF_H_OPTS="${COMPNAV_FZF_H_OPTS:---select-1 --exit-0}" \
    ruby "$COMPNAV_DIR/h.rb" "$*") &&
    cd "$(eval echo "$dir")" || return;
}

cd() {
  builtin cd "$@" || return;
  # If the new dir exists and is different than the old dir, update .z file.
  [ "$OLDPWD" = "$PWD" ] || ruby "$COMPNAV_DIR/z.rb" --add "$PWD"
}

# Add the initial pwd at shell session startup.
ruby "$COMPNAV_DIR/z.rb" --add "$PWD"