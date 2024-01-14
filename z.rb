# Since we can't change the current shell directory from a script, this only outputs the new new
# directory. You can make a function, like:
#
# z() { cd $(ruby ~/bin/z.rb $@) }
#
# And you should also hook into `cd`:
#
# cd() {
#    builtin cd "$@" || return
#    [ "$OLDPWD" = "$PWD" ] || z --add $PWD
#  }

Z_FILE = File.join(ENV['HOME'], '/.z').freeze
Z_HEADER = 'shnav-z'.freeze
Z_VERSION = '0.0.1'.freeze

# Add the passed-in dir to the recent-dirs list as the most recent one.
def add_dir_to_z_file(dir_to_add)
  # Remove any trailing slashes
  dir_to_add = dir_to_add.chomp('/')

  z_dirs = []
  if File.file?(Z_FILE)
    File.open(Z_FILE, 'r') do |file|
      # Check the header. If it's a .z file created by a different z utility, nuke it.
      header = file.gets
      if !header.nil? && header.start_with?(Z_HEADER)
        # Read all lines from .z, removing our dir if it is present.
        file.each { |line| line=line.chomp; z_dirs.push line if line != dir_to_add }
      end
    end
  end

  File.open(Z_FILE, "w") do |file|
    file.write "#{Z_HEADER} #{Z_VERSION}\n"
    # Write dirs to .z
    z_dirs.each { |z_dir| file.write "#{z_dir}\n" }
    file.write dir_to_add
  end
end

# Change to a dir matching the passed-in dir fragment.
def change_to_dir_from_fragment(dir_fragment)
  # TODO: If there's only one possible match, just print it and return.

  # TODO: First print dirs that match on the basename.

  # TODO: Then, print dirs that match in any other part of the path.
end

if ARGV.empty?
  # TODO: Display most recent dirs and allow user to select one.
elsif ARGV.length == 2 && ARGV[0] == '--add'
  add_dir_to_z_file ARGV[1]
elsif ARGV.length == 1
  change_to_dir_from_fragment ARGV[0]
else
  # Invalid usage, don't change the directory.
  puts Dir.pwd
end
