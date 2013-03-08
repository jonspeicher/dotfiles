# .irbrc is the user-specific global configuration file for the interactive Ruby shell, irb. See:
#
#     http://www.ruby-doc.org/docs/ProgrammingRuby/html/irb.html
#
# for more information, including a description of configuration file, command-line option, and
# environment variable precedence.

# On certain systems (e.g. Mac OS X) there may be additional configuration files that are worth
# loading, and irb won't do it by default.

['/etc/irbrc'].each { |file| load file if File.exist? file }

# Add some small amount of detail to some output.

IRB.conf[:VERBOSE] = true

# Define a function to be used within IRB as a shortcut for viewing Ruby documentation. This is the
# equivalent of the ri command-line tool.

def ri(*args)
  system(%{ri #{args.map {|arg| arg.to_s}.join(" ")}})
end
