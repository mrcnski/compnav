# Output all parent directories, which can be forwarded to fzf for selection.
# See the readme for detailed instructions.

cwd = ENV['PWD'] || ::Dir.pwd

while cwd != '/'
  cwd = File.dirname(cwd)
  puts cwd
end