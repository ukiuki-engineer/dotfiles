# ------------------------------------------------------------------------------
# zinit
# 一回だけ行えば良い処理などはここではなくなるべくinstall.shに書く
# ------------------------------------------------------------------------------
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
zinit light-mode for \
  zdharma-continuum/zinit-annex-as-monitor \
  zdharma-continuum/zinit-annex-bin-gem-node \
  zdharma-continuum/zinit-annex-patch-dl \
  zdharma-continuum/zinit-annex-rust

# viモードを使用
# NOTE: プラグイン読み込み後に入れると、keybindが上書きされてしまうので、
#       ここで入れておく
bindkey -v

#
# プラグイン
# NOTE: プラグインを削除する場合、記述を削除orコメントアウトして、以下でキャッシュクリアする
# zinit delete --clean
#
zinit ice pick"async.zsh" src"pure.zsh" # with zsh-async library that's bundled with it.
zinit light sindresorhus/pure
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions # Additional completion definitions
zinit light unixorn/fzf-zsh-plugin
zinit light zdharma/history-search-multi-word # NOTE: fzfとどっち使うか迷うけど一旦こっち使ってみる。
# zinit light marlonrichert/zsh-autocomplete # TODO: 良いんだけどキーバインドが気に入らない。設定要検討。
# ------------------------------------------------------------------------------
# 設定をロード
# ------------------------------------------------------------------------------
# fzfによるgit操作
if [[ -f $HOME/mytools/fzf_git/fzf_git.sh ]]; then
  source $HOME/mytools/fzf_git/fzf_git.sh
fi
source $HOME/.zsh/env.zsh     # 環境変数
                              # NOTE: 諸事情により.zshenvは使用しない。使う必要が出たらまたその時考える。
source $HOME/.zsh/utils.zsh   # 関数
source $HOME/.zsh/config.zsh  # zshの設定
source $HOME/.zsh/aliases.zsh # alias

# 環境固有の設定
if [[ -f $HOME/.zshrc_local ]]; then
  source $HOME/.zshrc_local
fi
