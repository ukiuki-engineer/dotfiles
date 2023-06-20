" ================================================================================
" init.vim(VSCode NeoVim用)
" TODO: %で色々ジャンプできるように何かプラグイン入れる必要があるかも
" ================================================================================
" ------------------------------------------------------------------------------
" options
" ------------------------------------------------------------------------------
" オートインデント
set autoindent
" クリップボード連携
set clipboard+=unnamed
" 検索時の挙動
set ignorecase
set smartcase
set incsearch
set hlsearch
set nowrapscan
" ------------------------------------------------------------------------------
" autocmd
" ------------------------------------------------------------------------------
augroup MyVSCodeInitVim
  autocmd!
  " 日本語入力切り替え
  if has('mac') && exepath('im-select') != ""
    " MacOS用
    " NOTE: im-selectをインストールしてPATHを通しておく
    autocmd InsertLeave,InsertEnter * :call jobstart('im-select com.apple.keylayout.ABC')
  endif
  if has('win32') && exepath('zenhan.exe') != ""
    " Windows用
    " NOTE: zenhanをインストールしてPATHを通しておく
    autocmd InsertLeave,InsertEnter * :call jobstart('zenhan.exe 0')
  endif
  " FIXME: markdownだけ何故かインデン4になってしまうので一旦強制的に2に。後で原因を調べる。
  autocmd FileType markdown setlocal tabstop=2 shiftwidth=2 softtabstop=2
augroup END
" ------------------------------------------------------------------------------
" maps
" ------------------------------------------------------------------------------
nnoremap <C-j> 7j
nnoremap <C-k> 7k
vnoremap <C-j> 7j
vnoremap <C-k> 7k
" Escを2回押すと検索結果ハイライトを非表示にする
nnoremap <silent> <Esc><Esc> :nohlsearch<CR><Esc>
" <C-[>でエスケープする(何でデフォルトで使えないんだ...)
vnoremap <C-[> <Esc>
