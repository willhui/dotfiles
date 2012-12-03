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

if filereadable('vim/go.vim')
	source vim/go.vim
endif
