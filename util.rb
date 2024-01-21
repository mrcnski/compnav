# Common utilities.

PWD = ENV['PWD'] || ::Dir.pwd

def path_with_tilde(abs_path)
  home = ENV['HOME']
  abs_path.sub(/#{home}/, "~")
end

def pipe_to_fzf_and_print(fzf_input, reverse, env_var)
  tac = if reverse; "--tac" else "" end
  query = ARGV.join(' ')
  compnav_fzf_opts = (ENV['COMPNAV_FZF_OPTS'] || "").delete("\n")
  compnav_fzf_cmd_opts = (ENV[env_var] || "").delete("\n")
  # --query: Start fzf with any given arguments as the query.
  fzf_cmd = "fzf #{tac} --query \"#{query}\" #{compnav_fzf_opts} #{compnav_fzf_cmd_opts}"

  puts `echo "#{fzf_input}" | #{fzf_cmd}`
end