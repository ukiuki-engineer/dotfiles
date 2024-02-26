# ------------------------------------------------------------------------------
# zinit
# ------------------------------------------------------------------------------
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

zinit ice pick"async.zsh" src"pure.zsh" # with zsh-async library that's bundled with it.
zinit light sindresorhus/pure
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light unixorn/fzf-zsh-plugin
# oh-my-zshのプラグイン
# zinit snippet OMZP::git
# ------------------------------------------------------------------------------
# 手動インストール/ロード
# ------------------------------------------------------------------------------
# mytoolsをダウンロード
if [ ! -e ~/mytools ]; then
  git clone https://github.com/ukiuki-engineer/mytools
fi

# fzfによるgit操作設定をロード
[ -f ~/mytools/fzf_git/fzf_git.sh ] && source ~/mytools/fzf_git/fzf_git.sh

# ------------------------------------------------------------------------------
# 設定をロード
# ------------------------------------------------------------------------------

# 個人設定
source ~/.zsh/my.zsh

# 環境ごとの設定(dotfilesでは管理せずに、環境ごとに作る)
if [ -e ~/.zsh/local.zsh ]; then
  source ~/.zsh/local.zsh
fi
