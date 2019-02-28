set number
syntax enable
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
set mouse=a
set background=dark
set noshowmode
set termguicolors

colorscheme onedark

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:bufferline_echo = 0

map <C-Right> :bn<CR>
map <C-Left> :bp<CR>

if &term =~ '^screen'
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif
