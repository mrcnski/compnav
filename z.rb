# Since we can't change the current shell directory from a script, this only outputs the new
# directory. Please see README for instructions.

$LOAD_PATH << File.join(File.dirname(__FILE__))
require 'util'

Z_FILE = File.join(ENV['HOME'], '/.z').freeze
Z_HEADER = 'compnav-z'.freeze
Z_VERSION = '0.0.1'.freeze

def read_z_dirs(dir_to_skip)
  z_dirs = []

  if File.file?(Z_FILE)
    File.open(Z_FILE, 'r') do |file|
      # Check the header. If it's a .z file created by a different z utility, nuke it.
      header = file.gets
      if !header.nil? && header.start_with?(Z_HEADER)
        # Read all lines from .z, removing our dir if it is present.
        # We add our dir to the end of the file later.
        z_dirs = file
          .map { |line| line.chomp }
          .filter { |line| !line.strip.empty? && line != dir_to_skip }
      end
    end
  end

  z_dirs
end

return if defined? REQUIRING_Z

if ARGV.length == 2 && ARGV[0] == '--add'
  # Add the passed-in dir to the recent-dirs list as the most recent one (last line of .z).

  # Remove any trailing slashes
  dir_to_add = ARGV[1].chomp('/')

  z_dirs = read_z_dirs dir_to_add

  File.open(Z_FILE, "w") do |file|
    file.write "#{Z_HEADER} #{Z_VERSION}\n"
    # Write dirs to .z
    z_dirs.each { |z_dir| file.write "#{z_dir}\n" }
    file.write dir_to_add
  end

  exit
end

z_dirs = read_z_dirs(PWD).map { |z_dir| path_with_tilde(z_dir) }.join("\n")

pipe_to_fzf_and_print(z_dirs, true, 'COMPNAV_FZF_Z_OPTS')
