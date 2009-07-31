setlocal autoindent
setlocal cindent

" indent the next line after these c keywords
setlocal cinwords=if,else,while,do,for,switch,case

" and here some nice options for c indenting
setlocal cinoptions=l1,g0,t0,(0

" use full featured format-options. see "help fo-table for help
if v:version >= 600
    setlocal formatoptions=tcrqn2
else
    " vim 5 doesn't know r/n
    setlocal formatoptions=tcq2
endif

" number of spaces the tab stands for
setlocal tabstop=4

" number of spaces used for (auto)indenting
setlocal shiftwidth=4

" if non-zero, number of spaces to insert for a <tab>
setlocal softtabstop=4

" a <tab> in an indent insets 'shiftwidth' spaces (not tabstop)
setlocal smarttab

" tab characters for indent
setlocal noexpandtab

if filereadable('vim/cpp.vim')
	source vim/cpp.vim
endif
