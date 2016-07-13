" To build YCM support libs:
" sudo aptitude install unity-gtk3-module cmake python-dev
" mkdir ~/ycm_build && cd ~/ycm_build
" cmake -G "Unix Makefiles" . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp
" make ycm_support_libs

" -----------------------------------------------------------
" General
" -----------------------------------------------------------

" Vi compatibility mode has stupid behavior; disable it. The documentation
" recommends applying this setting before anything else in your vimrc.
set nocompatible

filetype off                      " Required by Vundle.
set runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Check vimawesome.com for the latest, greatest vim plugins.

Plugin 'gmarik/Vundle.vim'         " Plugin manager
Plugin 'scrooloose/nerdtree'       " Directory explorer UI
Plugin 'tpope/vim-fugitive'        " Git wrapper
Plugin 'scrooloose/syntastic'      " Syntax checking
Plugin 'kien/ctrlp.vim'            " Fuzzy search through files & buffers
Plugin 'bling/vim-airline'         " Custom status line
Plugin 'altercation/vim-colors-solarized'  " Solarized color scheme
Plugin 'morhetz/gruvbox'           " A terminal color scheme
Plugin 'Valloric/YouCompleteMe'    " Code completion
Plugin 'easymotion/vim-easymotion' " Highly efficient motion commands
Plugin 'bitc/vim-bad-whitespace'   " Trailing whitespace checker
Plugin 'steffanc/cscopemaps.vim'   " Cross-referencing (C/C++, Java)

call vundle#end()
filetype plugin indent on         " Required by Vundle.

" Remap the leader key, our prefix for custom key mappings.
let mapleader=','

" Ensure normal backspace behavior in insert mode.
set backspace=indent,eol,start

" Don't beep or flash when displaying an error message.
set noerrorbells visualbell t_vb=
if has('autocmd')
	autocmd GUIEnter * set visualbell t_vb=
endif

" Show line numbers.
set number

" Show matching parentheses/quotes/braces.
set showmatch

" Fill in matching brace when typing in C-style languages.
imap {<cr> {<cr>}<esc>O

if has("unix")
	" My favorite shell.
	set shell=/bin/zsh
endif

" Reload externally-modified files without prompting.
set autoread

" Try to restore last known cursor position when re-opening a file.
if has("autocmd")
	autocmd BufReadPost * if line("'\"") | exe "normal '\"" | endif
endif

" -----------------------------------------------------------
" Buffers
" -----------------------------------------------------------

" Allow inactive buffers to contain unsaved changes. This lets you switch
" away from a dirty buffer without vim complaining.
set hidden

" Allow swapping between two most recent buffers even in insert mode.
imap <c-^> <esc>:e #<cr>

" -----------------------------------------------------------
" File types
" -----------------------------------------------------------

" Recognize SCons files as Python.
autocmd BufRead,BufNewFile SCons* set filetype=python

" JFlex.
autocmd BufRead,BufNewFile *.flex,*.jflex set filetype=jflex
autocmd Syntax jflex so ~/.vim/syntax/jflex.vim

" CUP.
autocmd BufRead,BufNewFile *.yacc,*.cup set filetype=cup
autocmd Syntax cup so ~/.vim/syntax/cup.vim

" GLSL.
autocmd BufRead,BufNewFile *.frag,*.vert,*.fp,*.vp,*.glsl set filetype=glsl
autocmd Syntax glsl so ~/.vim/syntax/glsl.vim

" Perforce Jam.
autocmd BufRead,BufNewFile Jamfile set filetype=jam
autocmd BufRead,BufNewFile Jamrules set filetype=jam

" -----------------------------------------------------------
" Indenting
" -----------------------------------------------------------

" Don't exit visual mode after shifting indentation.
vnoremap < <gv
vnoremap > >gv

" -----------------------------------------------------------
" Searching
" -----------------------------------------------------------

" Enable incremental search.
set incsearch

" Case-insensitive search.
set ignorecase

" Search becomes case-sensitive if uppercase is used.
set smartcase

" Continue searching from the top when EOF reached.
set wrapscan

" Highlight all matches. (use :noh when you're done).
set hlsearch

" Make sure :s///gc toggling is disabled.
set noedcompatible

" -----------------------------------------------------------
" Highlighting, colors, fonts
" -----------------------------------------------------------

" Enable syntax highlighting.
syntax on

if has("gui_running")
	" Width of the display.
	set columns=88

	" Number of lines in the display.
	set lines=41

	" Remove toolbar and menu bar.
	set guioptions-=T
	set guioptions-=m

	if has("win32")
		" Pick a nicer font than the Windows gVim default.
		set guifont=courier_new:h10:cANSI
	endif

	"hi Pmenu guibg=brown
	colorscheme solarized
else
	set background=dark
	let g:gruvbox_italic=1
	let $NVIM_TUI_ENABLE_TRUE_COLOR=1
	colorscheme gruvbox
endif

" See http://vim.wikia.com/wiki/Fix_syntax_highlighting for details
" on the syntax highlighting accuracy/efficiency tradeoff.

" How many lines to sync backwards.
syntax sync minlines=1000 maxlines=5000

" Hotkey to force a syntax highlighting pass from the start of the file.
noremap <F12> <Esc>:syntax sync fromstart<cr>
inoremap <F12> <C-o>:syntax sync fromstart<cr>

" -----------------------------------------------------------
" Status line
" -----------------------------------------------------------

" Use tab for auto-expansion in menus.
set wildchar=<tab>

" Show a list of all matches when tabbing a command.
set wildmenu

" How tab-completion works: When more than one match, list all matches
" and complete up to the longest common string. If tab is typed again,
" complete the first match.
set wildmode=list:longest,list:full

" Ignore some files for filename completion.
"set wildignore=*.o,*.r,*.so,*.sl,*.tar,*.tgz,*.obj,*.pyc,*.bak,*.swp,*.exe

" These file types have lower priority when showing the list of matches.
set suffixes=*.o,*.r,*.so,*.sl,*.tar,*.tgz,*.obj,*.pyc,*.bak,*.swp,*.exe

" Remember last 2000 typed commands.
set hi=2000

" Show cursor position in status line.
set ruler

" Use the shortest status message text possible.
set shortmess=aoOtT

" Always show the status line on the bottom window.
set laststatus=2

" Show partial command in status line.
set showcmd

" Attempt to reduce the number of annoying "press enter" prompts
" that appear when the message text overflows the status line.
set cmdheight=2

" -----------------------------------------------------------
" Insert mode completion
" -----------------------------------------------------------

" Order and what to complete. see ":help complete" for info.
set complete=.,w,b,u,t,i

" Adjust case of a keyword completion match.
set infercase

" When completing tags in insert mode show both the name
" and any arguments (when a C function is inserted).
set showfulltag

function! InsertTabWrapper(direction)
	let col = col('.') - 1
	if !col || getline('.')[col - 1] !~ '\k'
		return "\<tab>"
	elseif "backward" == a:direction
		return "\<c-p>"
	else
		return "\<c-n>"
	endif
endfunction

function! CleverTab(direction)
	if pumvisible()
		if "backward" == a:direction
			return "\<c-p>"
		else
			return "\<c-n>"
		end
	endif
	if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
		return "\<Tab>"
	elseif exists('&omnifunc') && &omnifunc != ''
		return "\<c-x>\<c-o>"
	else
		if "backward" == a:direction
			return "\<c-p>"
		else
			return "\<c-n>"
		end
	endif
endfunction

" Use tab and shift+tab to cycle through completion results.
inoremap <tab> <c-r>=InsertTabWrapper ("forward")<cr>
inoremap <s-tab> <c-r>=InsertTabWrapper ("backward")<cr>

" Tell eclim to use vim omni completion, which YouCompleteMe will
" automatically detect and use.
let g:EclimCompletionMethod='omnifunc'

" -----------------------------------------------------------
" Cross-reference tags
" -----------------------------------------------------------

" Use the quickfix window to show cscope results.
set cscopequickfix=s-,c-,d-,i-,t-,e-

" Where to look for tags.
set tags=./tags

" -----------------------------------------------------------
" Window handling
" -----------------------------------------------------------

" Focus follows mouse.
set mousef

" Split new windows to the right or bottom of the current one.
set splitright
set splitbelow

" -----------------------------------------------------------
" Swap files and backups
" -----------------------------------------------------------

" Milliseconds elapsed since last change to cause a swap file update.
set updatetime=1000

" Number of characters typed to cause a swap file update.
set updatecount=50

" Put swap files in this directory. I prefer them consolidated.
set directory=~/.vim/swap/

" Make no backups.
set nobackup

" -----------------------------------------------------------
" Custom key mappings
" -----------------------------------------------------------

" File format conversions.
command UnixFormat :set ff=unix
command DosFormat :set ff=dos
command MacFormat :set ff=mac

" Code to toggle QuickFix window.
command -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
	if exists("g:qfix_win") && a:forced == 0
		cclose
		unlet g:qfix_win
	else
		copen 10
		let g:qfix_win = bufnr("$")
	endif
endfunction

" Key binding for QuickFix window toggle.
map <Leader>r :QFix<cr>

" Cycle through errors in quickfix window.
map <c-right> :cnext<cr>
map <c-left> :cprev<cr>

map <Leader>d :NERDTree<Enter>
"map <Leader>f :CtrlP<Enter>
map <Leader>b :CtrlPBuffer<Enter>

" Eclim.
let g:EclimLocateFileScope='workspace'
let g:EclimLocateFileDefaultAction='edit'
map <Leader>f :LocateFile<Enter>
map <Leader>i :JavaImport<Enter>
map <Leader>s :JavaSearchContext<Enter>
map <F5> :ProjectRefresh<Enter>

" Pick up any extra user customization, if available.
if filereadable('~/.vimrc.user')
	source ~/.vimrc.user
endif
