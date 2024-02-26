# ==============================================================================
# 主な独自設定はここに書く
# NOTE: 環境によって違う箇所は`~/.zsh/local.zsh`で上書きする
# ==============================================================================
# ------------------------------------------------------------------------------
# 基本的な設定
# ------------------------------------------------------------------------------
# history
HISTFILE=$HOME/.zsh_history     # 履歴を保存するファイル
HISTSIZE=100000                 # メモリ上に保存する履歴のサイズ
SAVEHIST=1000000                # 上述のファイルに保存する履歴のサイズ

# share .zshhistory
setopt inc_append_history       # 実行時に履歴をファイルにに追加していく
setopt share_history            # 履歴を他のシェルとリアルタイム共有する

setopt hist_ignore_all_dups     # ヒストリーに重複を表示しない
setopt hist_save_no_dups        # 重複するコマンドが保存されるとき、古い方を削除する。
setopt extended_history         # コマンドのタイムスタンプをHISTFILEに記録する
setopt hist_expire_dups_first   # HISTFILEのサイズがHISTSIZEを超える場合は、最初に重複を削除する

# 補完で大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# 補完候補をカーソルで選択できるように
autoload -U compinit
compinit
zstyle ':completion:*:default' menu select=1

# cd周り
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
alias dockerExecShell='fzf_docker_exec_shell'
alias emoji='fzf_emoji'
alias cds='dirs -v; echo -n "select number: "; read newdir; cd +"$newdir"'
alias gitLogOneline='git log --oneline --graph --date=format:"%Y/%m/%d %H:%M:%S" --color=always --pretty="%C(auto)%h %C(blue)%ad %C(green)[%an]%C(reset) %s" '
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

