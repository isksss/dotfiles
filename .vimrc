if &compatible
  set nocompatible
endif
filetype plugin on

set number

set ignorecase
set incsearch
set wrapscan
set hlsearch
set clipboard+=unnamed

syntax enable
set expandtab
set tabstop=2
set shiftwidth=2

set smartindent
set showmatch
set autoindent
set laststatus=2
set cmdheight=2
set showcmd

set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp932
set fenc=utf-8 
set nobackup
set noswapfile
set nowritebackup
set autoread
set hidden
set ambiwidth=double
set wildmenu
set noerrorbells
set novisualbell
set shellslash

" ターミナル terminal
set splitbelow
set termwinsize=12x0

:let mapleader = " "
inoremap <silent> jj <Esc>:set iminsert=0<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
noremap <Leader>a myggVG$  
nnoremap <Leader>o Go
nmap <Esc><Esc> :nohlsearch<CR><Esc>
nnoremap <Down> gj
nnoremap <Up>   gk
nnoremap h <Left>
nnoremap j gj
nnoremap k gk
nnoremap l <Right>
tnoremap <ESC><ESC> <c-\><c-n>
nnoremap <Leader>t :bo terminal<CR>
