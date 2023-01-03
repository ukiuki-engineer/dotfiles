#
# aliases
#
alias ls='ls -FG' # FIXME: 環境によって違うためifで分ける
alias la='ls -a'
alias ll='ls -l'
alias grep='grep --color=auto'
# 簡易treeコマンド。
which tree > /dev/null 2&>1
if [ $? != 0 ]; then
  alias tree="pwd;find . | sort | sed '1d;s/^\.//;s/\/\([^/]*\)$/|--\1/;s/\/[^/|]*/|  /g'"
fi

# プラグイン読み込み
source /opt/homebrew/Cellar/zsh-git-prompt/0.5/zshrc.sh

#
# ~/.oh-my-zsh/themes/cobalt2.zsh-themeの設定の上書き
# memo:アイコンフォントを確認↓
# for i in {61545..62178}; do echo -e "$i:$(printf '\\u%x' $i) "; done
#
prompt_context() {
  local user=`whoami`

  if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    if [[ $(\uname) == "Darwin" ]]; then
      # $(printf '\\u%x' 61817)
      prompt_segment black default "%(!.%{%F{yellow}%}.)"
    elif [[ $(\uname) == "Linux" ]]; then
      # $(printf '\\u%x' 61820)
      prompt_segment black default "%(!.%{%F{yellow}%}.)"
    else
      prompt_segment black default "%(!.%{%F{yellow}%}.)✝"
    fi
  fi
}
# git表示
prompt_git() {
  local ref dirty
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    ZSH_THEME_GIT_PROMPT_DIRTY='±'
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
    # gitのuser.nameとuser.emailを表示
    # $(printf '\\u%x' 62144)
    # $(printf '\\u%x' 61664)
    ref=$ref" "" "$(git config user.name)" "" "$(git config user.email)" "
    if [[ -n $dirty ]]; then
      prompt_segment yellow black
    else
      prompt_segment green black
    fi
    echo -n "${ref/refs\/heads\// }$dirty"
  fi
}
# ARROW
if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="yellow"; fi
ARROW='%{$fg[$NCOLOR]%}➤ %{$reset_color%}'
prompt_dir() {
  prompt_segment blue black '%~'
}
# PROMPT
# 改行して矢印を入れる
PROMPT='%{%f%b%k%}$(build_prompt)
'$ARROW
