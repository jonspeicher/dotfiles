# .irbrc is the user-specific configuration file for the Ruby REPL irb.
#
# Most of this comes from melange396's .irbrc on GitHub:
# http://github.com/melange396/my.irbrc/blob/master/.irbrc

require 'irb/completion'          # Adds tab completion
IRB.conf[:VERBOSE] = true         # Adds some small amount of detail to some output
IRB.conf[:PROMPT_MODE] = :SIMPLE  # Removes the icky extended prompt

# Shortcut for rubydocs

def ri(*args)
  system(%{ri #{args.map {|arg| arg.to_s}.join(" ")}})
end