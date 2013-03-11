" .vimrc is the user-specific configuration file for vim.
"
" TBD: tabs vs spaces, indenting, newline at end of file, trailing whitespace trimming
" TBD: Look into textwidth and making the long-line column dependent on that, and consider setting
"      textwidth based on filetype?
" TBD: make a function to run, mapped to a key, that sets the size to 100x50 or whatever (using
"      "set lines=50" and "set columns=100", and otherwise just leave the size at whatever the
"      terminal is, so that vim popping up in another terminal window as part of a git command (for
"      example) doesn't resize the terminal window automatically but so that I can invoke the
"      function quickly expand a vim window to a good size if I want
" TBD: make a function to change to the working directory of the current file and potentially
"      launch Ack from there as well, see:
"      http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file
" TBD: figure out Ctrl-6/Ctrl-^ and why they're different on Windows vs. Mac
" TBD: map Caps Lock to Ctrl on Windows?
" TBD: another problem is that when I have vim open in one Terminal in OS X I can't do 'vim foo'
"      from a different terminal command prompt and have the file open in my other vim instance; I
"      think there's a command-line switch I'm using on Windows that I could look at, maybe make a
"      shell alias, or maybe this is the problem that MacVim solves
" TBD: vim doesn't seem to want to reload a file changed outside of vim on my Mac
" TBD: something somewhere wants to wrap this file at 80 columns

" Apparently this prevents some security exploits.

set modelines=0

" I'm told that the cool kids use pathogen.

runtime bundle/pathogen/autoload/pathogen.vim
execute pathogen#infect()

" Use vim settings rather than vi settings. This must be first-ish since it changes other options
" as a side-effect.

set nocompatible

" Allow hiding of buffers instead of closing them so that changes aren't lost when using :e!.

set hidden

" When running under Windows, remove the 't' flag from GUI options to kill
" tearoff menu options.

" TBD: This can apparently go in a gvimrc or something.
" See http://vim.wikia.com/wiki/Open_vimrc_file

" TBD: When the substitution happens here, there apparently is no T for toolbar in guioptions, and
" so the toolbar appears, presumably because it is added in to the guioptions later (when?); the
" substitution appears to be case-insensitive, and I don't know why, and I don't know what the &
" means.

" TBD: More links to read:
" http://daddy.platte.name/2007/05/remove-menu-bar-and-toolbar-from-gvim.html
" http://vim.wikia.com/wiki/Open_vimrc_file
" http://stackoverflow.com/questions/846879/remove-the-toolbar-in-gvim
" http://vim.wikia.com/wiki/Hide_toolbar_or_menus_to_see_more_text

"let &guioptions = substitute(&guioptions, "t", "", "g")

" Highlight the current line, enable line numbers, display incomplete commands in the last line,
" and show a long-line indicator column.

set cursorline
set number
set showcmd
set colorcolumn=100

" Set up the status line and ensure that it is always displayed. This obviates the ruler option in
" this configuration.

set statusline=%<[%n]\ %f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set laststatus=2

" Use enhanced command-line completion display, and complete with the longest
" common substring on the first press of the completion character, followed by
" a list.

"set wildmode=longest,list
set wildmenu

" Enable incremental search and search highlighting. Also, make searches case-sensitive only if
" they contain upper-case characters.

set incsearch
set hlsearch
set ignorecase smartcase

" Set up the preferred font and color scheme, and turn on syntax highlighting.

" TBD: When the substitution happens here, there apparently is a T for toolbar in guioptions, and
" so the sustitution removes it, and no toolbar appears.

let &guioptions = substitute(&guioptions, "t", "", "g")
set guifont=Consolas:h10:cANSI
color Tomorrow-Night
syntax on

" Set up handy development tools including paren match jumping, autoindent, and tab expansion with
" smarts.

set showmatch
set autoindent
set expandtab
set smarttab

" Write the file when switching away from the buffer and read the file if it changes outside of
" vim.

set autoread
set autowrite

" Enable file type detection, file type plugins, and indent files for language-specific indending.

filetype plugin indent on

" Strip trailing whitespace from lines in selected file types.

autocmd FileType c,cpp,python,ruby autocmd BufWritePre <buffer> :%s/\s\+$//e

" Allow backspacing beyond the start of the insert point.

set backspace=indent,eol,start

" If we're going to do this, do this.

map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
map <Down> <Nop>

" Make Y consistent with C and D. Normally yy yanks a whole line, and Y is a synonym for YY. This
" change makes Y yank to the end of the current line, more like C and D.

nnoremap Y y$

" Use <C-L> to clear the highlighting of :set hlsearch.

if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif
