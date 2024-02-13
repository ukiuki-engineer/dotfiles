# NOTE: 環境によって違う箇所は`~/.local.zsh`で上書きする
# ------------------------------------------------------------------------------
# environment variables
# ------------------------------------------------------------------------------
export FZF_DEFAULT_OPTS="--height=60% --border"
# manをvimで開く
# NOTE: -Rとset noma片方ずつだと以下の問題があるため両方設定した方が良い
# -Rのみ      : 保存はできないが編集自体はできてしまう
# set nomaのみ: 開いた時点で編集した状態と判定されており、:qで終了できない
export MANPAGER="col -b -x | /usr/local/bin/vim -R -c 'set ft=man noma nu' -"


# ------------------------------------------------------------------------------
# cd周りの設定
# ------------------------------------------------------------------------------
# auto_ls
function chpwd(){
    if [[ $(pwd) != $HOME ]]; then;
        ls
    fi
}
autoload chpwd

# ディレクトリ名だけでcdする
setopt AUTO_CD
# cd したら自動的にpushdする
setopt AUTO_PUSHD
# 重複したディレクトリをスタックに追加しない
setopt PUSHD_IGNORE_DUPS
# ------------------------------------------------------------------------------
# functions
# ------------------------------------------------------------------------------
# 選択したcontainerのシェルを実行する
# TODO: ヘッダーを表示させたい
fzf_docker_exec_shell() {
  # dockerコマンドが無ければ終了
  if ! which docker >/dev/null 2>&1; then
    which docker
    return 1
  fi

  # トライするシェルのリスト
  local shells="bash, ash, sh"
  # コンテナ名
  local container_name
  # 実行するシェル
  local exec_shell
  # 実行コマンド
  local exec_command

  # container id
  local cid=$(docker ps | sed 1d | fzf -q "$1" --height=10% | awk '{print $1}')

  # container idが選択できていなければ終了
  if [ -z "$cid" ]; then
    return 1
  fi

  # コンテナ名を取得
  container_name=$(docker ps --format '{{.Names}}' --filter "id=$cid")

  # 実行可能なshellを調べる
  for shell in $(echo $shells | tr ', ' '\n'); do
    if docker exec $cid $shell > /dev/null 2>&1; then
      exec_shell=$shell
      break
    fi
  done

  # 実行可能なshellが無ければ終了
  if [ -z $exec_shell ]; then
    echo "container name: $container_name"
    echo "executable shell does not exists in $shells"
    return 1
  fi

  # コマンドをプロンプトに出力
  exec_command="docker exec -it $container_name $exec_shell"
  print -z $exec_command
  # NOTE: 直接実行するには以下だけど、プロンプトに表示か直接実行かオプションで選択できるようにした方が良いか迷ってる
  # eval $exec_command
}

# 選択した絵文字を返す
fzf_emoji(){
  echo $(cat ~/.skk/SKK-JISYO.emoji.utf8 | grep -v ';;' | fzf)\
    | awk '{print $2}'\
    | tr -d /
}

fzf_find_file_with_preview() {
  rg --files --hidden --follow --glob "!**/.git/*"\
    | fzf --preview 'bat  --color=always --style=header,grid {}' --preview-window=right:60%
}

fzf_rg_vim() {
  rg --color=always --line-number --no-heading --smart-case "${*:-}" |
    fzf --ansi \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'right:60%,border-bottom,+{2}+3/3,~3' \
        --bind 'enter:become(nvim {1} +{2})'
}

# ------------------------------------------------------------------------------
# aliases
# ------------------------------------------------------------------------------
alias ls='ls -FG'
alias la='ls -a'
alias ll='ls -l'
alias grep='grep --color=auto'
# 簡易treeコマンド。
if ! which tree >/dev/null 2>&1; then
  alias tree="pwd;find . | sort | sed '1d;s/^\.//;s/\/\([^/]*\)$/|--\1/;s/\/[^/|]*/|  /g'"
fi
alias dockerExecShell='fzf_docker_exec_shell'
alias emoji='fzf_emoji'
alias cds='dirs -v; echo -n "select number: "; read newdir; cd +"$newdir"'

# ------------------------------------------------------------------------------
# プロンプトの設定
# ~/.oh-my-zsh/themes/cobalt2.zsh-themeの設定の上書き
# ------------------------------------------------------------------------------
prompt_context() {
  local user=`whoami`

  if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    if [[ $(\uname) == "Darwin" ]]; then
      prompt_segment black default "%(!.%{%F{yellow}%}.)"
    elif [[ $(\uname) == "Linux" ]]; then
      prompt_segment black default "%(!.%{%F{yellow}%}.)"
    else
      prompt_segment black default "%(!.%{%F{yellow}%}.)✝"
    fi
  fi
}

# git情報のプロンプト表示
prompt_git() {
  local ref dirty
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    ZSH_THEME_GIT_PROMPT_DIRTY='±'
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
    # refに情報を追加
    ref=$ref"    "$(git config user.name)"    "$(git config user.email)" "
    if [[ -n $dirty ]]; then
      prompt_segment yellow black
    else
      prompt_segment green black
    fi
    echo -n "${ref/refs\/heads\// }$dirty"
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment blue black '%~'
}

# PROMPT定義
PROMPT='%{%f%b%k%}$(build_prompt)'$'\n'

# ------------------------------------------------------------------------------
# WSL固有の設定
# ------------------------------------------------------------------------------
if [ -n "$WSLENV" ]; then
  # dockerのインストール
  if ! which docker >/dev/null 2>&1; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    # NOTE: sudo抜きでdockerコマンドを実行できるようにするには↓
    # sudo usermod -aG docker $USER
  fi
fi

