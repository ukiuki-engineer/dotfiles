# NOTE: 環境によって違う箇所は`~/.local.zsh`で上書きする
###############################################################################
# functions
###############################################################################
fzf_history() {
  # NOTE: fzfに渡した後に逆順になるので、最初に`history -r`で逆順にしておく
  BUFFER=$(
    history -r\
      | awk '!seen[$2]++ {print $2}'\
      | fzf --query "$LBUFFER"
  )
  CURSOR=$#BUFFER
  zle reset-prompt
  zle accept-line
}

fzf_cd() {
  eval $(find . -type d | fzf)
}

fzf_with_preview() {
  rg --files --hidden --follow --glob "!**/.git/*"\
    | fzf --preview 'bat  --color=always --style=header,grid {}' --preview-window=right:60%
}

fzf_git_branch() {
  # TODO: enterでcheckoutするだけじゃなく、keymapを割り合てて色々出来るようにする
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

fzf_docker_exec_bash() {
  local cid
  cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')
  [ -n "$cid" ] && docker exec -it "$cid" /bin/bash
}

fzf_kill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}
###############################################################################
# aliases
###############################################################################
alias ls='ls -FG'
alias la='ls -a'
alias ll='ls -l'
alias grep='grep --color=auto'
# 簡易treeコマンド。
if which tree >/dev/null 2>&1; then
  alias tree="pwd;find . | sort | sed '1d;s/^\.//;s/\/\([^/]*\)$/|--\1/;s/\/[^/|]*/|  /g'"
fi
# fzf系
alias fcd='fzf_cd'
alias fvim='nvim $(fzf_with_preview)'
alias gitBranches='fzf_git_branch'
alias dockerExecBash='fzf_docker_exec_bash'
alias fkill='fzf_kill'
###############################################################################
# bindkeies
###############################################################################
zle -N fzf_history
bindkey '^r' fzf_history
###############################################################################
# environment variables
###############################################################################
# manをvimで開く
# NOTE: -Rとset noma片方ずつだと以下の問題があるため両方設定した方が良い
# -Rのみ      : 保存はできないが編集自体はできてしまう
# set nomaのみ: 開いた時点で編集した状態と判定されており、:qで終了できない
export MANPAGER="col -b -x | /usr/local/bin/vim -R -c 'set ft=man noma nu' -"

###############################################################################
# プロンプトの設定
###############################################################################
# プラグイン読み込み
if [[ -e /opt/homebrew/Cellar/zsh-git-prompt/0.5/zshrc.sh ]]; then
  source /opt/homebrew/Cellar/zsh-git-prompt/0.5/zshrc.sh
elif [[ -e /usr/local/Cellar/zsh-git-prompt/0.5/zshrc.sh ]]; then
  source /usr/local/Cellar/zsh-git-prompt/0.5/zshrc.sh
fi

# ~/.oh-my-zsh/themes/cobalt2.zsh-themeの設定の上書き
# NOTE: アイコンフォントを確認↓
# for i in {61545..62178}; do echo -e "$i:$(printf '\\u%x' $i) "; done
# FIXME gitの表示の背景色をピンクに変更してみる
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
    # $(printf '\\u%x' 62142)
    ref=$ref"   "$(git config user.name)"   "$(git config user.email)" "
    if [[ -n $dirty ]]; then
      prompt_segment yellow black
    else
      prompt_segment green black
    fi
    echo -n "${ref/refs\/heads\// }$dirty"
  fi
}

# PROMPT定義
PROMPT='%{%f%b%k%}$(build_prompt)'$'\n'
