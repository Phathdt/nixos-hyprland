call plug#begin(expand('~/.config/nvim/plugged'))
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdcommenter'
Plug 'jiangmiao/auto-pairs'
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/incsearch.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'bronson/vim-trailing-whitespace'
Plug 'yggdroot/indentline'
Plug 'drewtempelmeyer/palenight.vim'
call plug#end()

filetype plugin on
filetype plugin indent on

syntax on

set encoding=UTF-8
set mouse=a
set incsearch
set hlsearch
set tabstop=2
set softtabstop=0
set shiftwidth=2
set noshowmode
set noswapfile
set expandtab
set smarttab
set number relativenumber
set nu rnu
set updatetime=300
set guifont=JetBrainsMono\ Nerd\ Font:h12
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set autoindent
set smartindent
set showtabline=2
set clipboard=unnamedplus
set autowrite
set autoread
set laststatus=2
set hls is
set ic
au CursorHold * checktime

set nobackup
set nowritebackup
set cmdheight=2
set shortmess+=c
set nowb
set noswapfile
set backupdir=~/tmp,/tmp
set backupcopy=yes
set backupskip=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*
set directory=/tmp

let mapleader = " "

nnoremap <Leader>/ :NERDCommenterToggle<CR>
nnoremap <Leader>v :vsplit<CR>
nnoremap <Leader>h :split<CR>

noremap <C-h> <C-w><C-h>
noremap <C-j> <C-w><C-j>
noremap <C-k> <C-w><C-k>
noremap <C-l> <C-w><C-l>

map <Leader>s <Plug>(easymotion-s2)
map <Leader>w <Plug>(easymotion-w)

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_close_button = 1
let g:airline_theme='palenight'

let g:indentLine_char = '│'
let g:indentLine_first_char = '│'
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_setColors = 0

cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap <silent> <S-t> :tabnew<CR>

set background=dark
colorscheme palenight

let g:lightline = { 'colorscheme': 'palenight' }
let g:airline_theme = "palenight"
let g:palenight_terminal_italics=1

if (has("nvim"))
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

if (has("termguicolors"))
  set termguicolors
endif
