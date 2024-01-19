# Common utilities.

PWD = ENV['PWD'] || ::Dir.pwd

def path_with_tilde(abs_path)
  home = ENV['HOME']
  abs_path.sub(/#{home}/, "~")
end