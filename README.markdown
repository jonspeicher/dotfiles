These are my dotfiles. There are many others like them, but these ones are mine.

Plugin instructions:

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
