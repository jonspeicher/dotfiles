# .irbrc is the user-specific global configuration file for the interactive Ruby shell, irb.  It
# must exist in $HOME or be specified by $IRBRC, with $IRBRC having higher precedence. It will
# override all other system- and tree-specific configuration files. Configuration within this file
# will be merged with command-line options, with configuration within this file overriding command-
# line options where applicable. See:
#
#     http://www.ruby-doc.org/docs/ProgrammingRuby/html/irb.html
#
# for more information.

# Add tab completion.

require 'irb/completion'

# Add some small amount of detail to some output.

IRB.conf[:VERBOSE] = true

# Remove the extended prompt.

IRB.conf[:PROMPT_MODE] = :SIMPLE

# Define a function to be used within IRB as a shortcut for viewing Ruby documentation. This is the
# equivalent of the ri command-line tool.

def ri(*args)
  system(%{ri #{args.map {|arg| arg.to_s}.join(" ")}})
end
