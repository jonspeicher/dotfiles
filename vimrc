" .vimrc is the user-specific global configuration file for Vim. See:
"
"     http://vim.wikia.com/wiki/Open_vimrc_file
"
" for more information, including a description of configuration file, command-line option, and
" environment variable precedence.

" TBD: tabs vs spaces, indenting, newline at end of file, trailing whitespace trimming
" TBD: Look into textwidth and making the long-line column dependent on that, and consider setting
"      textwidth based on filetype?
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

" TBD: It would be nice if this was variable for OS X and Windows, maybe with a platform-specific
" 'include' file or a conditional? Or is there a way to figure the best size? Maybe have a
" constant defined in a platform-specific file that is included at the top of this file?
"
" Actually, hostname() exists and returns the hostname of a given machine, and
" vimscript supports dictionary types:
"
" :let sizes = {'latrice': {'lines': 44, 'columns': 105}}
" :echo sizes[hostname()]['lines']
"
" http://andrewscala.com/vimscript
"
" Actually, gvimrc should always set the proper size without ,r and vimrc should not, but both
" files should use a table of sizes, I think; that table can probably just live in vimrc since it's
" always processed first? Also, is the function necessary?
"
" nmap <silent> <Leader>r :set lines=l columns=c<CR>
"
" Also, :winpos appears to work in gvim on Windows and in vim under a Terminal on OS X.

function! ResizeVimWindow()
  set lines=44
  set columns=105
endfunction
nmap <silent> <Leader>r :call ResizeVimWindow()<CR>

" Change to the directory of the current file and print the new working directory. More ideas are
" at http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file.

function! ChangeToAndPrintCurrentFileDir()
  cd %:p:h
  pwd
endfunction
nnoremap <silent> <Leader>cd :call ChangeToAndPrintCurrentFileDir()<CR>

" Start an Ack command, optionally changing to the current directory.

nmap <Leader>a :Ack 
nmap <Leader>ca :call ChangeToAndPrintCurrentFileDir()<CR>:Ack 

" Quickly edit or source the vimrc file.

" TBD: Editing $MYVIMRC won't work on Windows because of the symlink garbage. Maybe just remove it?
" Or make it edit dotfiles\vimrc directly?

nmap <silent> <Leader>ev :edit $MYVIMRC<CR>
nmap <silent> <Leader>sv :source $MYVIMRC<CR>
