# Since we can't change the current shell directory from a script, this only outputs the new new
# directory. You can make a function, like:
#
# up() { cd $(ruby ~/bin/up.rb $@) }

if ARGV.empty?
  puts '..'
else
  cwd = File.dirname(Dir.pwd)
  arg = ARGV[0].downcase

  while cwd != '/'
    dir = File.basename(cwd).downcase
    if dir.include? arg
      puts cwd
      return
    end
    cwd = File.dirname(cwd)
  end

  # Not found.
  puts Dir.pwd
end
