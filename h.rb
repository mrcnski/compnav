# Jump to a repository directory on the system that adheres to the following directory structure:
#
# $COMPNAV_H_REPOS_DIR/<git-host>/<user>/<repo>
#
# For example:
#
# ~/Repos/github.com/mrcnski/compnav
#
# This works by assembling a list of all applicable directories and passing them on (ideally to
# fzf). If the passed-in argument is a link to a repo, h.rb first clones the repo into the h
# directory structure and then passes on the directory.

$LOAD_PATH << File.join(File.dirname(__FILE__))
require 'z'
require 'util'

exit if ARGV.length == 0

COMPNAV_H_REPOS_DIR=File.expand_path(ARGV[0]).freeze
# Optional argument passed by user when invoking h.
H_ARG=ARGV[1].freeze

# TODO: Check if need to clone H_ARG

# Assemble list of applicable repo directories.
# We cross-reference with .z to output the repos with the most recent first.
h_dirs = [] # all repos
unvisited_dirs = [] # repos not in .z
# Get all dirs from z, including the current pwd which we filter later.
z_dirs = read_z_dirs(nil).reverse
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

puts(z_dirs.map{ |d| path_with_tilde d })
puts(unvisited_dirs.map { |d| path_with_tilde d })