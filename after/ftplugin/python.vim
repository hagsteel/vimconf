set makeprg=./manage.py\ test
set nowrap
set textwidth=0
set nospell

" Don't jump to start with hash
setl nosmartindent

" Keybindings
nmap <C-b> :!clear;./manage.py test<CR>
noremap gd :call jedi#goto_assignments()<CR>

setlocal completeopt-=preview
