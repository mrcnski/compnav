# Complete Shell Navigation: better `up`, `z`, and `h`

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
  - Already provided by fzf's Alt-C (but see improved config below that uses
    [`bfs`](https://github.com/tavianator/bfs)).
- [ ] Easily select from command history
  - Already provided by fzf's Ctrl-R

## Installation / Setup

### Prerequisites

You will need:

1. [`fzf`](https://github.com/junegunn/fzf/) (it's great, please consider
   [sponsoring ❤️](https://github.com/sponsors/junegunn) them!)
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

3. **NOTE:** make sure that you are not loading the interactive shell startup scripts (the ones
   ending with `rc`) from `.profile`! Otherwise, anytime `cd` is invoked it will update the
   recent-directories list, even if it's invoked from non-interactive scripts.

4. Open a new shell session; you can now start using `up`, `z`, and `h`!

### Optional Configuration

<details>
You can optionally pass additional parameters to <code>fzf</code>:

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

These work in addition to the standard <code>FZF_DEFAULT_OPTS</code>, which is always applied first
whenever <code>fzf</code> is invoked.
</details>

### `fzf`: find child subdirectory (Alt-C) with `bfs`

<details>
First make sure that you have <a href="https://github.com/tavianator/bfs"><code>bfs</code></a> installed, and consider
<a href="https://github.com/sponsors/tavianator">sponsoring ❤️</a> them!

Next add this to .bashrc/.zshrc:

```sh
export FZF_ALT_C_COMMAND="bfs -color -not -name '.' -nohidden -type d -printf '%P\n' 2>/dev/null"
```

And optionally consider setting something like this for a nice preview of directories (on Mac,
requires <a href="https://superuser.com/a/359727">installing <code>tree</code></a>):

```sh
# Print tree structure in the preview window
export FZF_ALT_C_OPTS="
  --height 80%
  --preview='tree -C {} | head -n 50'
  --preview-window=border-double,bottom"
```
</details>

### Full Example Config

For a full example config, see [.zsh-example](.zsh-example)!

## Improvements over existing tools

Why'd I make this? A few reasons:

- I ran into bugs with the existing tools.
- The existing `z` works based on "frecency", which offends me on a linguistic and technical level.
  compnav only considers "recency", which is predictable, more often what you want, and simpler.
- The existing `z` always jumps to the first result, not giving the user a chance to resolve
  ambiguity. `compnav` integrates with `fzf` in true Unix fashion, allowing a separate tool to do
  what it does best and take on the job of a selection interface. (If you want the behavior of
  always accepting the first result, that is also possible with some easy configuration.)
- By integrating with `fzf` we get fuzzy selection for free, for all the commands.
- compnav's `h` takes advantage of z's recent-directories index to show projects in recency order.
- The existing tools are mostly written in bash gobbledygook. compnav uses the bare minimum of bash.
  compnav is written in well-commented Ruby and is easy to read, understand, and modify.

## [License](LICENSE)

The MIT License (MIT)

Copyright (c) 2024 Marcin Swieczkowski