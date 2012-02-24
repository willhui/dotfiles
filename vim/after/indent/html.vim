setlocal autoindent

" number of spaces the tab stands for
setlocal tabstop=2

" number of spaces used for (auto)indenting
setlocal shiftwidth=2

" if non-zero, number of spaces to insert for a <tab>
setlocal softtabstop=2

" a <tab> in an indent insets 'shiftwidth' spaces (not tabstop)
setlocal smarttab

" tab characters for indent
setlocal noexpandtab

if filereadable('vim/html.vim')
	source vim/html.vim
endif
