export LANG=ja_JP.UTF-8
# manをvimで開く
# NOTE: -Rとset noma片方ずつだと以下の問題があるため両方設定した方が良い
# -Rのみ      : 保存はできないが編集自体はできてしまう
# set nomaのみ: 開いた時点で編集した状態と判定されており、:qで終了できない
# TODO: 本当はneovimにしたいけど、何故かタグジャンプが上手くいかない
export MANPAGER="col -b -x | /usr/local/bin/vim -R -c 'set ft=man noma nu' -"
export FZF_DEFAULT_OPTS="--height=60% --border"

# 環境固有の設定を読み込む
if [[ -f $HOME/.zshenv_local ]]; then
    source $HOME/.zshenv_local
fi
