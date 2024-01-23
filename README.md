# compnav - Complete Shell Navigation

Easily navigate to parent directories, recent directories, repos, and more.

This project aims to provide improved versions of utilities like `up`, `bd`, `z`, `autojump`, and
`h`, with [`fzf`](https://github.com/junegunn/fzf/) as the selection engine.

## Use cases

When navigating in the shell, 99% of the time I want to do one of the following:

- [x] Go up to a parent directory
  - Provided by compnav's `up` function (can be renamed to whatever you want).
- [x] Jump to a recent directory
  - Provided by compnav's `z` function (can be renamed to whatever you want).
- [x] Jump to a repo
  - Provided by compnav's `h` function (can be renamed to whatever you want).
- [ ] Go down to a child subdir
  - Provided by fzf's Alt-C (but see improved config below that uses
    [`bfs`](https://github.com/tavianator/bfs)).
- [ ] Easily select from command history
  - Provided by fzf's Ctrl-R

## Installation / Setup

### Prerequisites

You will need:

1. [`fzf`](https://github.com/junegunn/fzf/) (it's great, please consider
   [sponsoring](https://github.com/sponsors/junegunn) them!)
2. Ruby (hopefully old versions work, though I haven't tested it).

### Installation

1. Clone this repo somewhere, like `~/bin`.

2. Add the following to `.bashrc`/`.zshrc`:

```sh
# REQUIRED:
export COMPNAV_DIR="$HOME/bin/compnav"
export COMPNAV_H_REPOS_DIR="$HOME/Repos"

[ -f "$COMPNAV_DIR/compnav.sh" ] && source "$COMPNAV_DIR/compnav.sh"
```

3. **NOTE:** make sure you are not loading the interactive shell startup scripts (the ones ending
   with `rc`) from `.profile`! Otherwise, anytime `cd` is invoked it will update the
   recent-directories list, even if it's invoked from non-interactive scripts.

4. Open a new shell session; you can now start using `up`, `z`, and `h`!

### Optional Configuration

You can optionally pass additional parameters to `fzf`:

```sh
# OPTIONAL:
#
# Show a nice preview of the directory structure.
# Uses eval to resolve ~.
export COMPNAV_FZF_OPTS="
  --height 80%
  --preview='eval tree -C {} | head -n 50'
  --preview-window=border-double,bottom"
# `z`: Always accept the first match (just an example, personally I don't recommend it).
# export COMPNAV_FZF_Z_OPTS="--select-1 --exit-0 --sync --bind 'start:accept'"
```

These work in addition to the standard `FZF_DEFAULT_OPTS`, which is always applied first whenever
`fzf` is invoked.

### `fzf`: find child subdirectory (Alt-C) with `bfs`

First make sure that you have [`bfs`](https://github.com/tavianator/bfs) installed, and consider
[sponsoring](https://github.com/sponsors/tavianator) them!

Next add this to `.bashrc`/`.zshrc`:

```sh
export FZF_ALT_C_COMMAND="bfs -color -not -name '.' -nohidden -type d -printf '%P\n' 2>/dev/null"
```

And optionally consider setting something like this for a nice preview of directories (on Mac,
requires [installing `tree`](https://superuser.com/a/359727)):

```sh
# Print tree structure in the preview window
export FZF_ALT_C_OPTS="
  --height 80%
  --preview='tree -C {} | head -n 50'
  --preview-window=border-double,bottom"
```

### Full Example Config

TODO

## Improvements over existing tools