" ================================================================================
" .vimrc
" ================================================================================
" ------------------------------------------------------------------------------
" options
" ------------------------------------------------------------------------------
" 文字コード{{{
" NOTE: `:h encoding-values`
" Vim が内部処理に利用する文字コード。保存時に使用する文字コード
set encoding=utf-8
" Vim が 既存ファイルの 文字コード推定に使う文字コードのリスト。
set fileencodings=utf-8,sjis,iso-2022-jp,euc-jp
"  新規ファイルを作成する際の文字コード
set fileencoding=utf-8
" }}}
set nobackup
set noswapfile
set autoread
set hidden
set showcmd
set mouse=a
" カレントディレクトリをパスに追加
set path+=$PWD/**
" sessionに保存する内容を指定
set sessionoptions=buffers,resize,curdir,tabpages
set t_Co=256
set cursorline cursorcolumn
set number
set ruler
set list
set listchars=tab:»-,trail:-,eol:↓,extends:»,precedes:«,nbsp:%
set wrap
set laststatus=2
set cmdheight=2
set showcmd
set title
" コマンドライン補完の設定
if exists("+wildmenu")
  " コマンドライン補完の拡張モードを使用する
  set wildmenu
endif
if exists("+wildmode")
  " 次のマッチを完全に補完する
  set wildmode=full
endif
" ポップアップメニューを表示
if exists("+wildoptions")
  silent! set wildoptions=pum
endif
" Tab 文字を半角スペースにする
set expandtab
" 行頭以外の Tab 文字の表示幅 (スペースの数)
set tabstop=2
" 行頭での Tab 文字の表示幅
set shiftwidth=2
" カーソル設定
if has('vim_starting')
  " 挿入モード時に点滅の縦棒タイプのカーソル
  let &t_SI .= "\e[5 q"
  " ノーマルモード時に点滅のブロックタイプのカーソル
  let &t_EI .= "\e[0 q"
  " 置換モード時に点滅の下線タイプのカーソル
  let &t_SR .= "\e[3 q"
endif
" 自動的にインデントする
set autoindent
set smartindent
" クリップボード連携を有効にする
set clipboard+=unnamed
" クリップボード連携を有効にした時に BackSpace (Delete) が効かなくなるので設定する
" バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start
" 括弧入力時に対応する括弧を表示
set showmatch
" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM
" 検索の挙動に関する設定{{{
" 検索時に大文字小文字を無視
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase
" リアルタイムで表示
set incsearch
" マッチした文字列をハイライト
set hlsearch
" 検索時にファイルの最後まで行ったら最初に戻らない
set nowrapscan
" マッチした数を表示
set shortmess-=S
" }}}
" ------------------------------------------------------------------------------
" autocmd
" ------------------------------------------------------------------------------
augroup MyVimrc
  autocmd!
  autocmd FileType php setlocal tabstop=4 shiftwidth=4 softtabstop=4
  autocmd ColorScheme * :call utils#custom_highlight()
  autocmd InsertEnter * ++once execute 'source' .. expand($HOME) .. '/.vim/rc/autoclose.vim'
  " MacOS用
  if has('mac') && exepath('im-select') != ""
    " NOTE: im-selectをインストールしてPATHを通しておく
    autocmd InsertLeave,InsertEnter,CmdlineLeave * :call system('im-select com.apple.keylayout.ABC')
  endif
  " WSL用
  if has('linux') && exists('$WSLENV') && exepath('zenhan.exe') != ""
    " NOTE: zenhanをインストールしてPATHを通しておく
    autocmd InsertLeave,InsertEnter,CmdlineLeave * :call system('zenhan.exe 0')
  endif
augroup END
" ------------------------------------------------------------------------------
" keymaps
" ------------------------------------------------------------------------------
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>
nnoremap <TAB> :bn<Enter>
nnoremap <S-TAB> :bN<Enter>
nnoremap <C-j> 10j
nnoremap <C-k> 10k
" ------------------------------------------------------------------------------
" commands
" ------------------------------------------------------------------------------
command! SetCursorLineColumn       :set cursorline cursorcolumn
command! SetNoCursorLineColumn     :set nocursorline nocursorcolumn
" ------------------------------------------------------------------------------
" colorscheme
" ------------------------------------------------------------------------------
if filereadable(expand("$HOME/.vim/colors/molokai.vim"))
  colorscheme molokai
endif
" ------------------------------------------------------------------------------
" MacVim固有の設定
" ------------------------------------------------------------------------------
if has("gui_macvim") && has("gui_running")
  " タブを常に表示
  set showtabline=2
  " IMを無効化
  set imdisable
  " 透明度を指定
  set transparency=15
  set antialias
  " 行間
  set linespace=2
  set guifont=HackGenConsoleNF-Regular:h13

  " 既にvimを起動している状態で、vimrcを再読み込みした場合にウィンドウをリサイズするのを防ぐ
  if has('vim_starting')
    set columns=100
    set lines=35
  endif
  " 日本語入力の設定
  set noimdisable
  inoremap <ESC> <ESC>:set iminsert=0<CR>
  " noremap i :set iminsert=0<CR>i
  noremap / :set imsearch=0<CR>/
  " IMEオンの時カーソル色を変更
  if has('xim') || has('multi_byte_ime')
    silent! highlight CursorIM guifg=Black guibg=Magenta
  endif
endif
" ------------------------------------------------------------------------------
packadd! matchit " %でタグジャンプを有効化
syntax enable
