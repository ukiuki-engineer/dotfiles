" ================================================================================
" init.vim(VSCode NeoVim用)
" ================================================================================
" 日本語入力切り替え
augroup MyIME
  autocmd!
  " MacOS用
  if has('mac') && exepath('im-select') != ""
    " NOTE: im-selectをインストールしてPATHを通しておく
    autocmd InsertLeave,InsertEnter * :call system('im-select com.apple.keylayout.ABC')
  endif
  " Windows用
  if has('win32') && exepath('zenhan.exe') != ""
    " NOTE: zenhanをインストールしてPATHを通しておく
    autocmd InsertLeave,InsertEnter * :call system('zenhan.exe 0')
  endif
augroup END
" オートインデント
set autoindent
" クリップボード連携を有効化
set clipboard+=unnamed
" 検索時の挙動
set ignorecase
set smartcase
set incsearch
set hlsearch
set nowrapscan
" Escを2回押すと検索結果ハイライトを非表示にする
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>
