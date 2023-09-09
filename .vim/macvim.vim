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
