setlocal omnifunc=pythoncomplete#Complete
imap <silent> <buffer> . .<C-X><C-O><C-P>

" type :make to syntax-check a python module
setlocal makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
setlocal efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
