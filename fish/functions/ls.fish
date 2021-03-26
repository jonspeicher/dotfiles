function ls --description "List contents of directory"
    # fish 3.2.1 seems to have a bug where, at least on macOS, it tries to
    # append -F to the arguments to ls after it has figured out which color
    # flag is supported but fails because it is appending to the wrong
    # variable. Override it with a sledgehammer.
    command ls -GHF $argv
end
