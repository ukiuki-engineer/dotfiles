" ================================================================================
" init.vim(VSCode NeoVim用)
" ================================================================================
" ------------------------------------------------------------------------------
" options
" ------------------------------------------------------------------------------
" オートインデント
set autoindent
" クリップボード連携
set clipboard+=unnamed
" カーソル行、列を表示
set cursorline cursorcolumn
" 検索時の挙動
set ignorecase smartcase incsearch hlsearch nowrapscan
" ------------------------------------------------------------------------------
" highlights
" ------------------------------------------------------------------------------
hi CursorColumn guibg=#414041
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
" keymaps
" ------------------------------------------------------------------------------
let g:mapleader = "m"
nnoremap <C-j> 7j
nnoremap <C-k> 7k
vnoremap <C-j> 7j
vnoremap <C-k> 7k
" Escを2回押すと検索結果ハイライトを非表示にする
nnoremap <silent> <Esc><Esc> :nohlsearch<CR><Esc>
nnoremap ]c :call VSCodeNotify('workbench.action.editor.nextChange')<CR>
nnoremap [c :call VSCodeNotify('workbench.action.editor.previousChange')<CR>
lua << END
  local function map_zenkaku(hankaku_zenkaku_pairs)
    for hankaku, zenkaku in pairs(hankaku_zenkaku_pairs) do
      vim.keymap.set('n', '<leader>f' .. hankaku, 'f' .. zenkaku, {})
      vim.keymap.set('n', '<leader>t' .. hankaku, 't' .. zenkaku, {})
      vim.keymap.set('n', '<leader>df' .. hankaku, 'df' .. zenkaku, {})
      vim.keymap.set('n', '<leader>dt' .. hankaku, 'dt' .. zenkaku, {})
      vim.keymap.set('n', '<leader>yf' .. hankaku, 'yf' .. zenkaku, {})
      vim.keymap.set('n', '<leader>yt' .. hankaku, 'yt' .. zenkaku, {})
    end
  end
  map_zenkaku({
    [","] = "、",
    ["."] = "。",
    ["("] = "（",
    [")"] = "）",
    ["["] = "「",
    ["]"] = "」",
    ["{"] = "『",
    ["]"] = "』",
    [":"] = "：",
    [";"] = "；",
    ["?"] = "？",
    ["a"] = "あ",
    ["i"] = "い",
    ["u"] = "う",
    ["e"] = "え",
    ["o"] = "お",
  })
END
