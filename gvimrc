" .gvimrc is the user-specific global configuration file for Vim when Vim is running in graphical
" user interface mode. See:
"
"     http://vim.wikia.com/wiki/Open_vimrc_file
"
" for more information, including a description of configuration file, command-line option, and
" environment variable precedence.

" Remove the toolbar and the tearoff menu options.

set guioptions-=T
set guioptions-=t

" Set the font.

" TBD: This is likely to be Windows-specific; do I need something common or platform-specific
" files?

set guifont=Meslo_LG_S:h10:cANSI

" Set the window dimensions as appropriate for this host. There's no good reason not to do this
" unconditionally when running the GUI.

call ResizeVimWindowForHost()
