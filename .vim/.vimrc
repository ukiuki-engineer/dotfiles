" ================================================================================
" .vimrc
" ================================================================================
" ------------------------------------------------------------------------------
" options
" ------------------------------------------------------------------------------
" Vi互換を使用しない
set nocompatible

"
" 文字コード
"
" NOTE: `:h encoding-values`
" Vim が内部処理に利用する文字コード。保存時に使用する文字コード
set encoding=utf-8
" Vim が 既存ファイルの 文字コード推定に使う文字コードのリスト。
set fileencodings=utf-8,sjis,iso-2022-jp,euc-jp
" 新規ファイルを作成する際の文字コード
set fileencoding=utf-8

"
" インデントとかTabとか
"
" Tab 文字を半角スペースにする
set expandtab
" インデントは基本スペース2
set shiftwidth=2 tabstop=2 softtabstop=2
" 自動インデント
set autoindent smartindent

"
" カーソル設定
"
if has('vim_starting')
  " 挿入モード時に点滅の縦棒タイプのカーソル
  let &t_SI .= "\e[5 q"
  " ノーマルモード時に点滅のブロックタイプのカーソル
  let &t_EI .= "\e[0 q"
  " 置換モード時に点滅の下線タイプのカーソル
  let &t_SR .= "\e[3 q"
endif

"
" 検索の挙動に関する設定
"
" 検索時に大文字小文字を無視
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase
" マッチした文字列をハイライト
set hlsearch
" リアルタイムで表示
set incsearch
" 検索時にファイルの最後まで行ったら最初に戻らない
set nowrapscan
" マッチした数を表示
set shortmess-=S

"
" コマンドライン補完の設定
"
" コマンドライン補完の拡張モードを使用する
set wildmenu
" 次のマッチを完全に補完する
set wildmode=full
" ポップアップメニューを表示
silent! set wildoptions=pum

"
" ファイルの取扱い
"
" バックアップ、スワップファイルを作らない
" set nobackup noswapfile
" ファイルが外部で編集されたら即座に反映
set autoread
set hidden

"
" 編集に関する見た目系の設定
"
" カーソル行、列を表示
set cursorline cursorcolumn
" 行番号表示
set number
" 行末記号とかそういうやつを定義
set listchars=tab:»-,trail:-,eol:↓,extends:»,precedes:«,nbsp:%
" ↑を表示
set list
" 長い行を折り返す
set wrap
" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM
" 括弧入力時に対応する括弧を表示
set showmatch
set t_Co=256

"
" ステータスラインとか
"
" ステータスラインを常に表示
set laststatus=2
" コマンドラインの高さ
set cmdheight=2
" ルーラーを表示
set ruler
" コマンドをステータス行に表示
set showcmd
set title
set showcmd

"
" その他
"
" マウス操作オン(ほとんど使わないけど)
set mouse=a
" クリップボード連携を有効にする
set clipboard+=unnamed
" クリップボード連携を有効にした時に BackSpace (Delete) が効かなくなるので設定する
" バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start
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
nnoremap <C-j> 7j
nnoremap <C-k> 7k
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
  source ~/.vim/macvim.vim
endif
" ------------------------------------------------------------------------------
packadd! matchit " %でタグジャンプを有効化
" ファイル形式別プラグインの有効化
filetype plugin indent on
" シンタックスハイライトの有効化
syntax enable
