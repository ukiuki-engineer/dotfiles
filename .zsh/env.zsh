# ------------------------------------------------------------------------------
# 環境変数
# NOTE: 本来は.zshenvに書くべきだが、諸事情により.zshenvはしばらく使用しないことにする。
#       .zshenvは常に読み込まれるため、vimで頻繁に:call system()を実行するような処理があると、
#       動作が極端に重くなったりする。
# ------------------------------------------------------------------------------
# ダブらないように$PATHに追加する(先頭)
path_prepend() {
  if [[ ":$PATH:" != *":$1:"* ]]; then
    export PATH=$1:${PATH}
  fi
}

# ダブらないように$PATHに追加する(末尾)
path_append() {
  if [[ ":$PATH:" != *":$1:"* ]]; then
    export PATH=${PATH}:$1
  fi
}


if [[ -d "$HOME/bin" ]] ; then
  path_prepend $HOME/bin:$PATH
fi

if locale -a | grep -q "^ja_JP.UTF-8$"; then
  export LANG=ja_JP.UTF-8
fi

# manをvimで開く
# NOTE: -Rとset noma片方ずつだと以下の問題があるため両方設定した方が良い
# -Rのみ      : 保存はできないが編集自体はできてしまう
# set nomaのみ: 開いた時点で編集した状態と判定されており、:qで終了できない
export MANPAGER="sh -c 'col -b -x | nvim -R -c \"set ft=man noma nu\" -'"

# fzf
export FZF_DEFAULT_OPTS="--height=60% --border"

# lsコマンドのオプション
LSOPTIONS=""
if [[ $OSTYPE == "darwin"* ]]; then
  LSOPTIONS=" -FG"
elif [[ $OSTYPE == "linux-gnu"* ]] || [[ $OSTYPE == "freebsd"* ]]; then
  LSOPTIONS=" -F --color=auto"
fi
export LSOPTIONS

# Neovimの設定ファイルを切り替えたいときはこれをいじる
export NVIM_APPNAME="nvim"
