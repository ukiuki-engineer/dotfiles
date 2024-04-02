# ------------------------------------------------------------------------------
# 環境変数
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
if [[ $OSTYPE == "darwin"* ]]; then
  LSOPTIONS=" -FG"
elif [[ $OSTYPE == "linux-gnu"* ]] || [[ $OSTYPE == "freebsd"* ]]; then
  LSOPTIONS=" -F --color=auto"
fi
export LSOPTIONS

# Neovimの設定ファイルを切り替えたいときはこれをいじる
export NVIM_APPNAME="nvim"
