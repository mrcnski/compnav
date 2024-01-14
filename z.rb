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

if ARGV.empty?
    # Display most recent dirs and allow user to select one.
else
    if ARGV[0] == "--add"
        # Add the passed-in dir to the recent-dirs list as the most recent one.
        # TODO: remove any trailing slashes
    else
        # Change to a dir matching the passed-in dir fragment.
    end
end