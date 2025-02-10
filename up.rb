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

parent_dirs = parent_dirs.join("\n")

if ARGV.length >= 1 && ARGV[0] == '--fzf'
  pipe_to_fzf_and_print(parent_dirs, false, 'COMPNAV_FZF_UP_OPTS')
else
  puts parent_dirs
end
