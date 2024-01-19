# Output all parent directories, which can be forwarded to fzf for selection.
# See the readme for detailed instructions.

$LOAD_PATH << File.join(File.dirname(__FILE__))
require 'util'

cwd = PWD

while cwd != '/'
  cwd = File.dirname(cwd)
  puts cwd
end