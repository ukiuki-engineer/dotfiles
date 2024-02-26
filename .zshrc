# ------------------------------------------------------------------------------
# oh-my-zsh
# ------------------------------------------------------------------------------
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme configuration
ZSH_THEME="cobalt2"

source $ZSH/oh-my-zsh.sh
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

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
# oh-my-zshのプラグイン
# zinit snippet OMZP::git
# ------------------------------------------------------------------------------
# 手動インストール/ロード
# ------------------------------------------------------------------------------
# fzfインストール
if [ ! -e ~/.fzf ]; then
   git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
   ~/.fzf/install --key-bindings --completion  --update-rc   
fi

# fzfの設定をロード
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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
