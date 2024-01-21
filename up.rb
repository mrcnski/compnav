# Forwards all parent directories on to fzf for selection.
# See the readme for detailed instructions.

$LOAD_PATH << File.join(File.dirname(__FILE__))
require 'util'

cwd = PWD
parent_dirs = []

while cwd != '/'
  cwd = File.dirname(cwd)
  parent_dirs.push cwd
end

pipe_to_fzf_and_print(parent_dirs.join("\n"), false, 'COMPNAV_FZF_UP_OPTS')