" 2重読み込み防止
if exists('g:vimrc#loaded_autoclose')
  finish
endif

let g:vimrc#loaded_autoclose = 1

" 括弧補完 {{{
" 括弧入力
inoremap <expr> ( utils#write_close_bracket("(")
inoremap <expr> { utils#write_close_bracket("{")
inoremap <expr> [ utils#write_close_bracket("[")
" 閉じ括弧入力
inoremap <expr> ) utils#not_double_close_bracket(")")
inoremap <expr> } utils#not_double_close_bracket("}")
inoremap <expr> ] utils#not_double_close_bracket("]")
" }}}

" クォーテーション補完 {{{
inoremap <expr> ' utils#autoclose_quot("\'")
inoremap <expr> " utils#autoclose_quot("\"")
inoremap <expr> ` utils#autoclose_quot("\`")
" }}}

" <C-c>で補完をキャンセル
inoremap <silent><expr> <C-c> utils#is_completion() ? utils#cancel_completion() : "\<Esc>"
