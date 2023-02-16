""""" """"" """"" """"" """"" """"" """""
"" dein.vim
""""" """"" """"" """"" """"" """"" """""
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . s:dein_repo_dir
endif

" begin settings
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let s:rc_dir = expand('~/.config/nvim/toml')
  if !isdirectory(s:rc_dir)
    call mkdir(s:rc_dir, 'p')
  endif
  let s:toml = s:rc_dir . '/dein.toml'
  let s:lazy = s:rc_dir . '/lazy.toml'

  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:lazy, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

" plugin installation check 
if dein#check_install()
  call dein#install()
endif

" plugin remove check 
let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
  call map(s:removed_plugins, "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endif

""""" """"" """"" """"" """"" """"" """""
"" settings
""""" """"" """"" """"" """"" """"" """""
set fenc=utf-8 
set nobackup
set noswapfile
set autoread
set hidden

set showcmd " show commands you are typing
set number " show line number
set cursorline
set cursorcolumn
set virtualedit=onemore

set smartindent
set visualbell
set showmatch
set laststatus=2
set wildmode=list:longest

syntax enable
set list listchars=tab:\▸\-
set expandtab
set tabstop=2
set shiftwidth=2

set ignorecase
set incsearch
set wrapscan
set hlsearch
set clipboard+=unnamed

""""" """"" """"" """"" """"" """"" """""
"" key mapping
""""" """"" """"" """"" """"" """"" """""
nnoremap j gj
nnoremap k gk
nnoremap <silent> , :bprev<CR>
nnoremap <silent> . :bnext<CR>
nnoremap bd :bd<CR>

nmap <Esc><Esc> :nohlsearch<CR><Esc>

nnoremap <silent> tt <cmd>terminal<CR>
nnoremap <silent> tx <cmd>belowright new<CR><cmd>terminal<CR>
autocmd TermOpen * :startinsert
autocmd TermOpen * setlocal norelativenumber
autocmd TermOpen * setlocal nonumber
tnoremap <ESC> <C-\><C-n>

""""" """"" """"" """"" """"" """"" """""
"" utils
""""" """"" """"" """"" """"" """"" """""
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>