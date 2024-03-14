# ------------------------------------------------------------------------------
# env
# NOTE: 本来は.zshenvに書くべきだが、諸事情により.zshenvはしばらく使用しないことにする。
#       .zshenvは常に読み込まれるため、vimで頻繁に:call system()を実行するような処理があると、
#       動作が極端に重くなったりする。
# ------------------------------------------------------------------------------
export LANG=ja_JP.UTF-8

# manをvimで開く
# NOTE: -Rとset noma片方ずつだと以下の問題があるため両方設定した方が良い
# -Rのみ      : 保存はできないが編集自体はできてしまう
# set nomaのみ: 開いた時点で編集した状態と判定されており、:qで終了できない
export MANPAGER="col -b -x | nvim -R -c 'set ft=man noma nu' -"

# fzf
export FZF_DEFAULT_OPTS="--height=60% --border"

# lsコマンドのオプション
LSOPTIONS=""
if [[ "$OSTYPE" == "darwin"* ]]; then
  LSOPTIONS=" -FG"
elif [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "freebsd"* ]]; then
  LSOPTIONS=" -F --color=auto"
fi
export LSOPTIONS
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

# 補完の設定
#
# 補完候補をカーソルで選択
zstyle ':completion:*:default' menu select=1
# 大文字小文字を区別しない、部分一致
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|=* l:|=*'
# 補完システムの初期化
autoload -U compinit
compinit

# cd周り
# auto_ls
function chpwd(){
  if [[ $(pwd) != $HOME ]]; then;
    eval "\ls ${LSOPTIONS}"
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

