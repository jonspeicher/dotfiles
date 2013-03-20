" .vimrc is the user-specific global configuration file for Vim. See:
"
"     http://vim.wikia.com/wiki/Open_vimrc_file
"
" for more information, including a description of configuration file, command-line option, and
" environment variable precedence.

" TBD: tabs vs spaces, indenting, newline at end of file, trailing whitespace trimming
" TBD: Look into textwidth and making the long-line column dependent on that, and consider setting
"      textwidth based on filetype?
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

" Baseline options ---------------------------------------------------------------------------------

" Apparently this prevents some security exploits.

set modelines=0

" Use vim settings rather than vi settings. This must be first-ish since it changes other options
" as a side-effect.

set nocompatible

" I'm told that the cool kids use pathogen.

runtime bundle/pathogen/autoload/pathogen.vim
execute pathogen#infect()

" Buffer management --------------------------------------------------------------------------------

" Allow hiding of buffers instead of closing them so that changes aren't lost when using :e!.

set hidden

" Write the file when switching away from the buffer and read the file if it changes outside of
" vim.

set autoread
set autowrite

" Visual appearance --------------------------------------------------------------------------------

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

" Finding stuff ------------------------------------------------------------------------------------

" Use enhanced command-line completion display, and complete with the longest common substring on
" the first press of the completion character, followed by a list.

set wildmenu
set wildmode=longest,full

" Enable incremental search and search highlighting. Also, make searches case-sensitive only if they
" contain upper-case characters. It should be noted that setting ignorecase affects the substitute
" command and function as well, which can have side-effects if substitute() is used to, for example,
" modify guioptions as in the stock vimrc_example.vim.

set incsearch
set hlsearch
set ignorecase smartcase

" Development conveniences and configuration -------------------------------------------------------

" Set up the preferred color scheme and turn on syntax highlighting.

color Tomorrow-Night
syntax on

" Set up handy development tools including paren match jumping, autoindent, and tab expansion with
" smarts.

set showmatch
set autoindent
set expandtab
set smarttab

" File-type-specific configuration -----------------------------------------------------------------

" Enable file type detection, file type plugins, and indent files for language-specific indenting.

filetype plugin indent on

" Strip trailing whitespace from lines in selected file types.

autocmd FileType c,cpp,python,ruby autocmd BufWritePre <buffer> :%s/\s\+$//e

" Key mapping and behavior -------------------------------------------------------------------------

" Change the leader key. This should be done before any key mappings using <Leader>.

let mapleader=","

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

" Clear the search highlighting when clearing and redrawing the screen with Ctrl-L.

nnoremap <silent> <C-L> :nohlsearch<CR><C-L>


" Quickly resize the current vim window (whether it is gvim or vim in a terminal) to something
" reasonable.

function! ResizeVimWindow()
  set lines=44
  set columns=105
endfunction
nmap <silent> <Leader>r :call ResizeVimWindow()<CR>
