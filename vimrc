" Will's vimrc
"
" Loosely based on Folke's vimrc (folke@ashberg.de) available here:
" http://www.ashberg.de/vim/vimrc.html
"
"
" Notes to myself about vim configuration:
"
" To see all the config files vim is loading and the order
" in which it is loading them, start vim with the -V switch.
" Handy for debugging a misbehaving vim configuration.
"
" Ctrl+s = Save file
" Ctrl+o = Retrace your movements in the file (Ctrl+i is supposed
"          to be the new hotkey for this, but it doesn't work for me)
" Ctrl+l = Toggle list of open buffers (BufExplorer)
" Ctrl+j = Toggle list of cscope hits or compile errors (QuickFix window)
" Ctrl+h = Show filesystem navigator
" :A     = Switch between header and source files (in C/C++)
"
" If the cwd contains a vim/ subdir with [language].vim files in it,
" these files will be sourced by ~/.vim/after/indent/[language].vim.
" The intent is to allow you to easily specify indentation settings
" on a per-project basis.
"
" Looking for good implementations of:
"  - Integrated debugger (using gdb or something as a backend)
"  - Intellisense (omnicomplete isn't so great in my opinion).
"  - Refactoring tools.
"
" TODO: Look into using vim's :find feature to let us quickly
" and conveniently open any file in a project. Read ":help path"
" for details.
"
" Use ":bd" to close a buffer, ":bd!" to close and discard changes.
" "^6" to swap between two most recent buffers.
"
" Save your current session with ':mksession work.vim'
" Open vim and restore the session with ':source work.vim'
" Load a session from the command line with 'vim -S work.vim'
"
" Type ':helptags ~/.vim/doc' to add plugin documentation to the
" searchable help index for vim.

" -----------------------------------------------------------
" General setup
" -----------------------------------------------------------

" easier vertical movement on extremely long word wrapped lines
noremap <Up> gk
noremap <Down> gj

" enable backspace to delete anything (includes \n) in insert mode
set backspace=indent,eol,start
set nocompatible

" no beep or flash
autocmd VimEnter * set vb t_vb=

" show line numbers
set number

" highlight bad whitespace
highlight BadWhitespace ctermbg=red guibg=red

" flag trailing whitespace as bad
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" -----------------------------------------------------------
" Buffers
" -----------------------------------------------------------

" open the buffer list
map <c-l> <esc>:BufExplorer<cr>
imap <c-l> <esc>:BufExplorer<cr>

" gz in command mode closes the current buffer
map gz :bdelete<cr>

" allow inactive buffers to contain unsaved changes (lets you switch away
" from a dirty buffer without giving an error)
set hid

" -----------------------------------------------------------
" Python settings
" -----------------------------------------------------------

" recognize SCons files as Python
autocmd BufReadPre SCons* set filetype=python

" display tabs at the beginning of a line in python mode as bad
autocmd BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/

" enable all possible Python highlighting options
let python_highlight_all=1

" -----------------------------------------------------------
" JFlex settings
" -----------------------------------------------------------

" set up syntax highlighting for jflex
augroup filetype
	au BufRead,BufNewFile *.flex,*.jflex set filetype=jflex
augroup END
au Syntax jflex so ~/.vim/syntax/jflex.vim

" -----------------------------------------------------------
" CUP settings
" -----------------------------------------------------------

" set up syntax highlighting for cup
augroup filetype
	au BufRead,BufNewFile *.yacc,*.cup set filetype=cup
augroup END
au Syntax cup so ~/.vim/syntax/cup.vim

" -----------------------------------------------------------
" GLSL settings
" -----------------------------------------------------------

" set up syntax highlighting for glsl
augroup filetype
	au BufRead,BufNewFile *.frag,*.vert,*.fp,*.vp,*.glsl set filetype=glsl
augroup END
au Syntax glsl so ~/.vim/syntax/glsl.vim

" -----------------------------------------------------------
" Perforce Jam settings
" -----------------------------------------------------------

" recognize Jamfiles
autocmd BufReadPre Jamfile set filetype=jam
autocmd BufReadPre Jamrules set filetype=jam

" -----------------------------------------------------------
" Text-Formatting, Indenting, Tabbing
" -----------------------------------------------------------

" visual shifting (does not exit visual mode after shifting)
vnoremap < <gv
vnoremap > >gv 

" -----------------------------------------------------------
" Searching, Substituting
" -----------------------------------------------------------

" case-insensitive search
set ignorecase 

" search becomes case-sensitive if uppercase is used
set smartcase

" change the way backslashes are used in search patterns
set magic

" begin search at top when EOF reached
set wrapscan

" show matching parentheses/quotes/braces
set showmatch

" highlight all matches... (use :noh when you're done)
set hlsearch

" find-as-you-type
set incsearch

" make sure :s///gc toggling is disabled
set noedcompatible

" -----------------------------------------------------------
" Highlighting, Colors, Fonts
" -----------------------------------------------------------

" when we have a colored terminal or gui...
if &t_Co > 2 || has("gui_running")
	" ...then use highlighting
	syntax on
endif

if has("gui_running")
	" width of the display
	set columns=88
	" number of lines in the display
	set lines=41
	" remove toolbar and menu bar, respectively
	set guioptions-=T
	set guioptions-=m

	if has("win32")
		set guifont=courier_new:h10:cANSI
	else
		" for Linux (this font isn't available on Mac OS X)
		"set guifont=Bitstream\ Vera\ Sans\ Mono\ 10
	endif

	hi Pmenu guibg=brown
	colorscheme autumnleaf
	"colorscheme inkpot
	"colorscheme blackboard
else
	colorscheme blugrine
endif

" See http://vim.wikia.com/wiki/Fix_syntax_highlighting for details
" on the syntax highlighting accuracy/efficiency tradeoff.

" how many lines to sync backwards
syn sync minlines=10000 maxlines=10000

" how many lines to search backward after a jump to check syntax
let c_minlines = 200

" -----------------------------------------------------------
" Status line, Menu
" -----------------------------------------------------------

" use tab for auto-expansion in menus
set wildchar=<TAB>

" show a list of all matches when tabbing a command
set wildmenu

" how command line completion works
set wildmode=list:longest,list:full

" ignore some files for filename completion
set wildignore=*.o,*.r,*.so,*.sl,*.tar,*.tgz,*.obj,*.pyc,*.bak,*.swp,*.exe

" some filetypes got lower priority
set su=.h,.bak,~,.o,.info,.swp,.obj

" remember last 2000 typed commands
set hi=2000

" show cursor position in status line
set ruler

" shows the current status (insert, visual, ...) in status line
set showmode

" use the shortest status message text possible
set shortmess=aoOtT

" show always status line of last window
set laststatus=2

" show partial command in status line
set showcmd

" attempt to reduce the number of annoying "press enter" prompts
" that appear when the message text overflows the status line
set cmdheight=2


" -----------------------------------------------------------
" Insert-Mode Completion
" -----------------------------------------------------------

" order and what to complete. see ":help complete" for info
set complete=.,w,b,u,t,i

" adjust case of a keyword completion match
set infercase

" when completing tags in Insert mode show both the name
" and any arguments (when a C function is inserted)
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

" use tab and shift+tab to cycle through completion results
inoremap <tab> <c-r>=InsertTabWrapper ("forward")<cr>
inoremap <s-tab> <c-r>=InsertTabWrapper ("backward")<cr>

" -----------------------------------------------------------
" Tag search and tag highlighting
" -----------------------------------------------------------

" use the quickfix window for some cscope results
set cscopequickfix=s-,c-,d-,i-,t-,e-

" where to look for tags
set tags=./tags,/usr/include/tags

" -----------------------------------------------------------
" Window handling
" -----------------------------------------------------------

" focus follows mouse
set mousef

" minimal number of lines used for the current window
set wh=1

" minimal number of lines used for any window
set wmh=1

" don't readjust the size of all existing windows when
" adding/removing windows
set noequalalways

" a new window is put below the current one
set splitbelow

" -----------------------------------------------------------
" file, swap, backup, path
" -----------------------------------------------------------

" milliseconds elapsed since last change to cause a swap file update
set updatetime=1000

" number of characters typed to cause a swap file update
set updatecount=50

" make no backups
set nobackup

" put swap files in this directory (I prefer them consolidated)
set directory=~/.vim/swap/

" put standard C header files on the :find path for vim
if has("unix")
	if v:version >= 600
		set path=.,/usr/include/**,/usr/X11R6/include/,/usr/local/include
	else
		set path=.,/usr/include,/usr/X11R6/include/,/usr/local/include
	endif
endif


" -----------------------------------------------------------
" WIN-GUI Specials
" -----------------------------------------------------------

if has("win32")
	if has("gui_running")
		" nothing to do here for now
	endif
endif

" -----------------------------------------------------------
" UNIX Specials
" -----------------------------------------------------------

if has("unix")
	" my favorite shell
	set shell=/bin/zsh
endif

" -----------------------------------------------------------
" Special Features
" -----------------------------------------------------------

" enable configuration based on automatic filetype detection
filetype on
if v:version >= 600
	filetype plugin on
	filetype indent on
endif

if has("autocmd")
	" try to restore last known cursor position
	autocmd BufReadPost * if line("'\"") | exe "normal '\"" | endif

	" autoread gzip-files
	augroup gzip
		" Remove all gzip autocommands
		au!

		" Enable editing of gzipped files
		" set binary mode before reading the file
		autocmd BufReadPre,FileReadPre      *.gz,*.bz2 set bin
		autocmd BufReadPost,FileReadPost    *.gz call GZIP_read("gunzip")
		autocmd BufReadPost,FileReadPost    *.bz2 call GZIP_read("bunzip2")
		autocmd BufWritePost,FileWritePost  *.gz call GZIP_write("gzip")
		autocmd BufWritePost,FileWritePost  *.bz2 call GZIP_write("bzip2")
		autocmd FileAppendPre               *.gz call GZIP_appre("gunzip")
		autocmd FileAppendPre               *.bz2 call GZIP_appre("bunzip2")
		autocmd FileAppendPost              *.gz call GZIP_write("gzip")
		autocmd FileAppendPost              *.bz2 call GZIP_write("bzip2")

		" After reading compressed file: Uncompress text in buffer with "cmd"
		fun! GZIP_read(cmd)
			let ch_save = &ch
			set ch=2
			execute "'[,']!" . a:cmd
			set nobin
			let &ch = ch_save
			execute ":doautocmd BufReadPost " . expand("%:r")
		endfun

		" After writing compressed file: Compress written file with "cmd"
		fun! GZIP_write(cmd)
			!mv <afile> <afile>:r
			execute "!" . a:cmd . " <afile>:r"
		endfun

		" Before appending to compressed file: Uncompress file with "cmd"
		fun! GZIP_appre(cmd)
			execute "!" . a:cmd . " <afile>"
			!mv <afile>:r <afile>
		endfun
	augroup END " gzip
endif

" -----------------------------------------------------------
" Mappings
" -----------------------------------------------------------

" ctrl+backspace deletes the previous word
" (but this won't work in the gnome terminal, see
" http://bugzilla.gnome.org/show_bug.cgi?id=420039)
":imap <c-bs> <esc>vBc

" quick save
nmap <c-s> :w<cr>
vmap <c-s> <esc>:w<cr>
imap <c-s> <esc>:w<cr>a

" copy/paste using system clipboard (TODO: resolve conflict with c-p/c-n key
" bindings for cycling through tab completion results)
vmap <c-y> "+y
nmap <c-p> :set paste<cr>"+P:set nopaste<cr>
vmap <c-p> d:set paste<cr>"+P:set nopaste<cr>
imap <c-p> <esc>:set paste<cr>"+p:set nopaste<cr>a

" Appends / insert current date
nmap _d "=strftime("%m/%d/%Y")<CR>p
nmap _D "=strftime("%m/%d/%Y")<CR>P

" Changes directory to the one of the current file
nmap _h :cd%:h<CR>

" Suppresses all spaces at end/beginning of lines
nmap _s :%s/\s\+$//<CR>
nmap _S :%s/^\s\+//<CR>

" file format conversions
command UnixFormat :set ff=unix
command DosFormat :set ff=dos
command MacFormat :set ff=mac

" toggle highlight search (folke) (F12 already in use though...)
noremap <F12> :if 1 == &hls \| noh \| else \| set hls \| endif \| <CR>

" make opens error-list automatically
command Make :make|:cw
inoremap <F9> <esc>:write<cr>:Make<cr>
nnoremap <F9> write<cr>:Make<cr>

" code to toggle quickfix window
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

" key binding for quickfix window toggle
map <c-j> :QFix<cr>
imap <c-j> :QFix<cr>

" cycle through errors in quickfix window
map <c-right> :cnext<cr>
map <c-left> :cprev<cr>

" key binding for fuzzy finder
map <c-k> :FufFile<cr>
imap <c-k> :FufFile<cr>
vmap <c-k> :FufFile<cr>

" key binding for vtreeexplore plugin
map <c-h> :VSTreeExplore<cr>
imap <c-h> :VSTreeExplore<cr>

" vtreeexplorer plugin.
let g:treeExplVertical = 1
let g:treeExplWinSize = 25
let g:treeExplDirSort = 1
" hide vtreeexplorer from buffer list. however, this prevents the explorer
" from being restored with sessions.
"let g:treeExplNoList = 1

" a.vim plugin. :A switches between source and header file
let g:alternateSearchPath = 'sfr:../src,sfr:../kernel,sfr:../../kernel,sfr:../include,sfr:../include/kernel,sfr:include/,sfr:src/'
let g:alternateNoDefaultAlternate = 1

" Fill in matching brace when typing in C-style languages.
imap {<cr> {<cr>}<esc>O

" allow swapping between two most recent buffers even in insert mode
imap <c-^> <esc>:e #<cr>
