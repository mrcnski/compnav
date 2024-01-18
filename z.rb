# Since we can't change the current shell directory from a script, this only outputs the new
# directory. Please see README for instructions on hooking this up with cd and fzf.

Z_FILE = File.join(ENV['HOME'], '/.z').freeze
Z_HEADER = 'shnav-z'.freeze
Z_VERSION = '0.0.1'.freeze

def path_with_tilde(abs_path)
  home = ENV['HOME']
  abs_path.sub(/#{home}/, "~")
end

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

def print_most_recent_dirs
  z_dirs = read_z_dirs Dir.pwd

  z_dirs.reverse.each { |z_dir| puts path_with_tilde(z_dir) }
end

# Add the passed-in dir to the recent-dirs list as the most recent one (last line of .z).
def add_dir_to_z_file(dir_to_add)
  # Remove any trailing slashes
  dir_to_add = dir_to_add.chomp('/')

  z_dirs = read_z_dirs dir_to_add

  File.open(Z_FILE, "w") do |file|
    file.write "#{Z_HEADER} #{Z_VERSION}\n"
    # Write dirs to .z
    z_dirs.each { |z_dir| file.write "#{z_dir}\n" }
    file.write dir_to_add
  end
end

if ARGV.empty?
  print_most_recent_dirs
elsif ARGV.length == 2 && ARGV[0] == '--add'
  add_dir_to_z_file ARGV[1]
end
