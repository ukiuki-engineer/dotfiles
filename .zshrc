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
# ------------------------------------------------------------------------------
# 手動インストール
# ------------------------------------------------------------------------------
# mytoolsをダウンロード
if [ ! -e $HOME/mytools ]; then
  git clone https://github.com/ukiuki-engineer/mytools
fi

# fzfによるgit操作設定をロード
[ -f $HOME/mytools/fzf_git/fzf_git.sh ] && source ~/mytools/fzf_git/fzf_git.sh
# ------------------------------------------------------------------------------
# 設定をロード
# ------------------------------------------------------------------------------
source $HOME/.zsh/functions.zsh
source $HOME/.zsh/config.zsh
source $HOME/.zsh/aliases.zsh

# 環境固有の設定
if [[ -f $HOME/.zshrc_local ]]; then
    source $HOME/.zshrc_local
fi
