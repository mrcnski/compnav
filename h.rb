# Jump to a repository directory on the system that adheres to the following directory structure:
#
# $COMPNAV_H_REPOS_DIR/<git-host>/<user>/<repo>
#
# For example:
#
# ~/Repos/github.com/mrcnski/compnav
#
# This works by assembling a list of all applicable directories and passing them on to fzf.
#
# If the passed-in argument is a link to a repo, h.rb first clones the repo into the h directory
# structure and then passes on the single directory.

$LOAD_PATH << File.join(File.dirname(__FILE__))
REQUIRING_Z = true
require 'z'
require 'util'

COMPNAV_H_REPOS_DIR=ENV['COMPNAV_H_REPOS_DIR'].freeze
# First argument passed by user when invoking h, may be a repo link.
H_ARG=ARGV[0].freeze

# Check if H_ARG is a repo link that we should clone into h directory structure.
if H_ARG.start_with? 'http'  
  without_protocol = H_ARG.split('://')[1]
  host, user, repo = without_protocol.split('/')
  if host.include? 'www.'
    host = host.split('www.')[1]
  end
  
  # Create host directory if it doesn't exist.
  host_dir = File.join(COMPNAV_H_REPOS_DIR, host)
  if !Dir.exist? host_dir
    Dir.mkdir host_dir
  end
  
  # Create user directory if it doesn't exist.
  user_dir = File.join(host_dir, user)
  if !Dir.exist? user_dir
    Dir.mkdir user_dir
  end
  
  # Clone repo into user directory if it doesn't exist.
  repo_dir = File.join(user_dir, repo)
  if !Dir.exist? repo_dir
    Dir.chdir(user_dir) do
      system("git clone #{H_ARG}")
    end
  end
  
  puts path_with_tilde repo_dir
  exit
end

# Assemble list of applicable repo directories.
# We cross-reference with .z to output the repos with the most recent last.
h_dirs = [] # all repos on disk
unvisited_dirs = [] # repos not in .z
# Get all dirs from z, including the current pwd which we filter later.
z_dirs = read_z_dirs nil
Dir.chdir(COMPNAV_H_REPOS_DIR) do
  Dir.glob('*').select { |f| File.directory? f }.each { |d_host| Dir.chdir(d_host) do
    Dir.glob('*').select { |f| File.directory? f }.each { |d_user| Dir.chdir(d_user) do
      Dir.glob('*').select { |f| File.directory? f }
        .map { |d_repo| File.expand_path d_repo }
        .filter { |d_repo| d_repo != PWD }
        .each { |d_repo|
          h_dirs.push d_repo
          if !z_dirs.include? d_repo
            unvisited_dirs.push d_repo
          end
        }
    end }
  end }
end

# unvisited_dirs has all repos that are not in .z,
# now remove all dirs from z_dirs that are not repos.
z_dirs = z_dirs.filter { |d| h_dirs.include? d and d != PWD }

fzf_input = unvisited_dirs.concat(z_dirs).map { |d| path_with_tilde d }.join("\n")

pipe_to_fzf_and_print(fzf_input, true, 'COMPNAV_FZF_H_OPTS')