function! utils#custom_highlight() abort
  " NOTE: 上書きしたい色設定はここに
  " hi Visual term=reverse ctermbg=237 guibg=#403d3d
  " hi Search term=reverse ctermfg=230 ctermbg=3 guifg=Black
endfunction

function! utils#write_close_bracket(bracket) abort
  " カーソルの前の文字
  let l:prev_char = getline('.')[col('.') - 2]
  " カーソルの次の文字
  let l:next_char = getline('.')[col('.') - 1]
  " 指定されたパターンにマッチする場合は補完しない
  if l:next_char =~ join(s:disable_nextpattern_autoclosing_brackets, '\|') && !empty(s:disable_nextpattern_autoclosing_brackets)
    " 括弧補完しない
    return a:bracket
  else
    call s:save_completion_strings(a:bracket, s:reverse_bracket(a:bracket))
    " NOTE: <C-g>Uは、undoの単位の分割をしないという意味
    "       カーソル移動するとundoの単位が分割されるため、<C-g>Uでそれを防ぐ
    "       ※<C-g>uは、undoの単位の分割。その時点で<Esc>したのと同じことになる。
    " 括弧補完
    return a:bracket . s:reverse_bracket(a:bracket) . "\<C-g>U\<Left>"
  endif
endfunction

function! utils#not_double_close_bracket(close_bracket) abort
  " カーソルの前の文字
  let l:prev_char = getline('.')[col('.') - 2]
  " カーソルの次の文字
  let l:next_char = getline('.')[col('.') - 1]
  " ()と入力した場合())とせずに()で止める
  if l:next_char == a:close_bracket && l:prev_char == s:reverse_bracket(a:close_bracket)
    return "\<RIGHT>"
  else
    return a:close_bracket
  endif
endfunction

function! utils#autoclose_quot(quot) abort
  " カーソルの前の文字
  let l:prev_char = getline('.')[col('.') - 2]
  " カーソルの次の文字
  let l:next_char = getline('.')[col('.') - 1]

  " カーソルの左右にクォーテンションがある場合は何も入力せずにカーソルを移動
  if l:prev_char == a:quot && l:next_char == a:quot
    return "\<RIGHT>"
  " カーソルの前の文字が入力されたクォーテーションの場合は補完しない
  elseif l:prev_char == a:quot
    return a:quot
  " 指定されたパターンにマッチする場合は補完しない
  elseif l:next_char =~ join(s:disable_nextpattern_autoclosing_quots, '\|') && !empty(s:disable_nextpattern_autoclosing_quots)
    return a:quot
  " それ以外は補完する
  else
    call s:save_completion_strings(a:quot, a:quot)
    return a:quot . a:quot . "\<Left>"
  endif
endfunction

function! utils#is_completion()
  if !exists('g:autoclose#completion_strings')
    return v:false
  endif
  let l:trigger_len = strlen(g:autoclose#completion_strings['trigger'])
  let l:completed_len = strlen(g:autoclose#completion_strings['completed'])
  let l:line = getline('.')
  let l:col = col('.')
  return l:line[l:col - 1 : l:col + l:completed_len - 2] == g:autoclose#completion_strings['completed']
endfunction

function! utils#cancel_completion() abort
  let l:trigger = g:autoclose#completion_strings['trigger']
  let l:completed = g:autoclose#completion_strings['completed']
  let l:delete_num = strlen(l:trigger) + strlen(l:completed)
  " カーソルの前の文字
  let l:prev_char = getline('.')[col('.') - 2]
  " 補完された文字列の次の文字
  let l:next_char_of_completed = getline('.')[col('.') - 1 + strlen(l:completed)]

  " 補完の後何も文字が入力されていないかつ、文末の場合
  if l:prev_char == l:trigger && l:next_char_of_completed == ""
    return "\<Esc>" . l:delete_num . "xa" . l:trigger . "\<Esc>"
  " 補完の後何も文字が入力されていないかつ、文末ではない場合
  elseif l:prev_char == l:trigger && l:next_char_of_completed != ""
    return "\<Esc>" . l:delete_num . "xi" . l:trigger . "\<Esc>"
  " 補完の後何か文字が入力されかつ、文末の場合
  elseif l:prev_char != l:trigger && l:next_char_of_completed == ""
    return "\<Esc>" . "F" . l:trigger . "\"zdt" . l:completed[0] . "x\"zp"
  " 補完の後何か文字が入力されかつ、文末ではない場合
  elseif l:prev_char != l:trigger && l:next_char_of_completed != ""
    return "\<Esc>" . "F" . l:trigger . "\"zdt" . l:completed[0] . "x\"zP"
  endif
endfunction
" ------------------------------------------------------------------------------
" private
" ------------------------------------------------------------------------------
let s:disable_nextpattern_autoclosing_brackets = [
  \ '\a',
  \' \d',
  \' [^\x01-\x7E]'
\ ]
let s:disable_nextpattern_autoclosing_quots = [
  \ '\a',
  \ '\d',
  \ '[^\x01-\x7E]'
\ ]

function! s:reverse_bracket(bracket) abort
  " 括弧
  let l:start_bracket = {
    \")": "(",
    \"}": "{",
    \"]": "[",
    \">": "<"
  \}
  " 閉じ括弧
  let l:close_bracket = {
    \"(": ")",
    \"{": "}",
    \"[": "]",
    \"<": ">"
  \}

  " 括弧が渡されたら閉じ括弧を返す
  if has_key(l:close_bracket, a:bracket)
    return l:close_bracket[a:bracket]
  " 閉じ括弧が渡されたら括弧を返す
  elseif has_key(l:start_bracket, a:bracket)
    return l:start_bracket[a:bracket]
  else
    return ""
  endif
endfunction

function! s:save_completion_strings(trigger_str, completed_str) abort
  let g:autoclose#completion_strings = {
    \"trigger": a:trigger_str,
    \"completed": a:completed_str
  \}
  " 保存文字列のクリア処理
  augroup autocloseClearSavedCompletionStrings
    au!
    execute 'au InsertLeave * ++once unlet g:autoclose#completion_strings'
  augroup END
endfunction
