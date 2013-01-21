" .vimrc is the user-specific configuration file for vim.
"
" TBD: tabs vs spaces, indenting, newline at end of file, long lines

" Use vim settings rather than vi settings. This must be first since it changes
" other options as a side-effect.

set nocompatible

" Allow hiding of buffers instead of closing them so that changes aren't lost
" when using :e!.

set hidden

" When running under Windows, remove the 't' flag from GUI options to kill
" tearoff menu options.

" TBD: This can apparently go in a gvimrc or something.
" See http://vim.wikia.com/wiki/Open_vimrc_file

let &guioptions = substitute(&guioptions, "t", "", "g")

" Set the window size.

set lines=55
set columns=120

" Highlight the current line, enable line numbers, always display a status line,
" and display incomplete commands in the last line.

set cursorline
set number
set showcmd

" Set up the status line and ensure that it is always displayed. This obviates
" the ruler option in this configuration.

set laststatus=2
set statusline=%<[%n]\ %f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

" Use enhanced command-line completion display, and complete with the longest
" common substring on the first press of the completion character, followed by
" a list.

"set wildmode=longest,list
set wildmenu

" Enable incremental search and search highlighting. Also, make searches
" case-sensitive only if they contain upper-case characters.

set incsearch
set hlsearch
set ignorecase smartcase

" Set up the preferred font and color scheme, and turn on syntax highlighting.

set guifont=Consolas:h10:cANSI
color Tomorrow-Night
syntax on

" Set up handy development tools including paren match jumping, autoindent, 
" and smart tabs.

set showmatch
set autoindent
set expandtab
set smarttab

" Write the file when switching away from the buffer and read the file if it
" changes outside of vi.

set autoread
set autowrite

" Enable file type detection, file type plugins, and indent files for
" language-specific indending.

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

" Make Y consistent with C and D. Normally yy yanks a whole line, and Y is a
" synonym for YY. This change makes Y yank to the end of the current line,
" more like C and D.

nnoremap Y y$

" Use <C-L> to clear the highlighting of :set hlsearch.

if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif
