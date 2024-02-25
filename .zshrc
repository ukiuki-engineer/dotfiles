# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme configuration
ZSH_THEME="cobalt2"

# pluginsで管理するツール類のインストール
if [ ! -e ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# plugins
plugins=(
  git
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# ------------------------------------------------------------------------------
# 各種ツールのインストール/ロード
# ------------------------------------------------------------------------------
# zsh-syntax-highlighting
if [ ! -e ~/zsh-syntax-highlighting ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/zsh-syntax-highlighting
  source ~/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
  source ~/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

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
