" vimrc for 9.0~
" mac and linux, not for win.
"@@@@@ @@@@@ @@@@@ @@@@@ @@@@@ @@@@@
" options
"@@@@@ @@@@@ @@@@@ @@@@@ @@@@@ @@@@

let g:mapleader = " " " LEADER:<SPACE>

syntax enable " シンタックスの有効化
set fenc=utf-8 " 文字コードをutf-8に設定
set encoding=UTF-8
set number "行番号
set backspace=indent,eol,start " 行先頭、末尾でbackspace使える
set showcmd " 入力中のコマンド表示
set noswapfile " スワップファイル
set nobackup " バックアップファイル
set laststatus=2 " ステータスラインを2行に
set expandtab " tabをスペースで
set tabstop=4 " 行頭以外でのtab幅
set shiftwidth=4 " 行頭でのtab幅
set autoindent " 改行時に自動インデント
set noerrorbells " ノーサウンド
set hidden " バッファ編集中でも他ファイルを開ける
set autoread " 編集中に変更があったら自動で読み込む
set showmatch " 対応する括弧を強調表示
set title " タイトルを表示
set ambiwidth=double " マルチバイト文字
" 検索系
set ignorecase " 検索で大小文字区別しない
set smartcase " 検索に大文字が含まれている場合は区別
set incsearch " 検索時に順次ヒットさせる
set wrapscan " 検索で最後に行ったら最初に戻る
set hlsearch " 検索結果にハイライト

"@@@@@ @@@@@ @@@@@ @@@@@ @@@@@ @@@@@
" keymap
"@@@@@ @@@@@ @@@@@ @@@@@ @@@@@ @@@@@

"@@@@@ insert @@@@@
" insert: jjでインサートモードから戻る 
inoremap <silent>jj <ESC>
inoremap <silent>っj <ESC>
" 移動
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

"@@@@@ normal @@@@@
" 表示行単位で移動
nnoremap j gj
nnoremap k gk
" 検索ハイライトを削除
nmap <Leader><Leader> :nohlsearch<CR><Esc>
" 保存
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
" バッファ移動
nnoremap <Leader>l :bnext<CR>
nnoremap <Leader>h :bprev<CR>

"@@@@@ term @@@@@
nnoremap <Leader>t :bo term ++close ++rows=15<CR>

"@@@@@ @@@@@ @@@@@ @@@@@ @@@@@ @@@@@
" plugin
" vim-plug
"@@@@@ @@@@@ @@@@@ @@@@@ @@@@@ @@@@@

" vim-plugを自動インストール
if has('vim_starting')
  set rtp+=~/.vim/plugged/vim-plug
  if !isdirectory(expand('~/.vim/plugged/vim-plug'))
    echo 'install vim-plug...'
    call system('mkdir -p ~/.vim/plugged/vim-plug')
    call system('git clone https://github.com/junegunn/vim-plug.git ~/.vim/plugged/vim-plug/autoload')
  end
endif

call plug#begin('~/.vim/plugged')
    " denops
    Plug 'vim-denops/denops.vim'
    " statusline
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'ryanoasis/vim-devicons'
    " filer
    Plug 'scrooloose/nerdtree'
    " ddc
    Plug 'Shougo/ddc.vim'
    Plug 'Shougo/ddc-ui-native'
    Plug 'Shougo/ddc-source-around'
    Plug 'Shougo/ddc-matcher_head'
    Plug 'Shougo/ddc-sorter_rank'

    " lsp
    " :LspInstallServer
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'
    Plug 'shun/ddc-vim-lsp' " auto complete
call plug#end()

"@@@@@ @@@@@ @@@@@ @@@@@
" plugin settings
"@@@@@ @@@@@ @@@@@ @@@@@

" statusline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" deno
let g:denops#deno = $HOME . "/.deno/bin/deno"

" nerdtree
nnoremap <silent><Leader>e :NERDTreeToggle<CR>
let NERDTreeShowHidden = 1 " 隠しファイルを表示

" ddc
call ddc#custom#patch_global('ui', 'native')
call ddc#custom#patch_global('sources', ['around','vim-lsp'])
call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
      \   'matchers': ['matcher_head'],
      \   'sorters': ['sorter_rank']},
      \ })
call ddc#enable() " ddcの有効化

