call plug#begin()
Plug 'brooth/far.vim'
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'rust-lang/rust.vim'
Plug 'kyoz/purify', { 'rtp': 'vim' }
Plug 'w0rp/ale'
Plug 'ap/vim-css-color'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'hail2u/vim-css3-syntax'
call plug#end()

set mouse=a
set number
set termguicolors
set nocompatible


let g:airline_theme='Cobalt 2'

syntax on  
colorscheme purify

nnoremap <silent> <C-n> :NERDTreeToggle<CR>
