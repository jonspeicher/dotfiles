These are my dotfiles. There are many others like them, but these ones are mine.

copydot.py is a work-in-progress intended to help me manage my dual Windows and OS X
life. It needs a lot of work, and so do my dotfiles in general, particularly with
respect to git and vim. I hope to do this work soon.

NOTE: The whole platform concept hinges on the idea that files with extensions that are also not
dotfiles are platform-specific, period, end of story. As soon as a file winds up in .dotfiles that
is neither a dotfile (i.e. all extension) nor platform-specific that has an extension, that platform
concept needs to change, but it's not a big deal (the extension could be .platform-foo and the regex
matching would need to be tweaked, or get uglier, but it's not an unsolvable problem). Make sure to
note this in the readme in some way. This means that any executable file that has an extension, like
dotlink.py itself, will be treated as though it's part of the 'py' platform, but that's ok for now,
because dotlink.py is treated as a special-case built-in ignored file already. I'm scratching my own
itch with this, not building a Swiss Army knife for the world.

Also is it worth noting that the regex syntax used in the ignore file is applied with match rather
than search?

Plugin instructions (clean these up):

To install a new plugin:

        git submodule add url vim/bundle/path
        git submodule init && git submodule update
        git add .
        git commit -m "Install foo bundle as a submodule to vim/bundle/path" or whatever

To pull all plugins:

        git submodule foreach git pull [origin master]

To remove a plugin:

        delete the relevant section from .gitmodules
        delete the relevant section from .git/config
        run git rm --cached vim/bundle/path (no trailing slash!)
        commit and delete the now-untracked submodule files

To clone:

        git clone https://github.com/jonspeicher/dotfiles ~/.dotfiles
        git submodule init
        git submodule update

To link (eventually):

        cd ~
        .dotfiles/dotlink.py platform

Dotfile precedence is awful, with /etc files, tree-local files, ~/ files, command-line options,
shell options, and environment variables all entering the equation, and various schemes for merging,
overriding, or chaining config. In general the assumption is that simply linking these files into
~ is enough. Where there are issues or other requirements I'll try to note it in the file, and I'll
try to provide a link to more information regarding the mess in the file header where I can. If
there are really crazy special exceptions I'll note them.
