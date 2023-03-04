#!/bin/bash
#
# cobalt2インストール
#
function install_cobalt2() {
  # cobalt2がある場合は処理終了
  if [[ -e ~/.oh-my-zsh/themes/cobalt2.zsh-theme ]] || [[ -e ~/Cobalt2-iterm ]]; then
    return
  fi
  git clone https://github.com/wesbos/Cobalt2-iterm.git
  mv Cobalt2-iterm ~/
  cp ~/Cobalt2-iterm/cobalt2.zsh-theme ~/.oh-my-zsh/themes/
}

#
# シンボリックリンクを作成する関数
# 引数:ファイル名
#
function make_link() {
  # ファイルがある&&シンボリックリンク→unlink
  if [[ -e ~/$1 && -L ~/$1 ]]; then
    unlink ~/$1
  # ファイルがある&&シンボリックリンクではない→バックアップを取る
  elif [[ -e ~/$1 && ! -L ~/$1 ]]; then
    mv ~/$1 ~/$1.bak
    echo " \"~/${1}\" のバックアップ \"~/${1}.bak\" を作成しました。"
  fi
  ln -s ${PWD}/$1 ~/$1
  echo "シンボリックリンク \"${PWD}/${1}→~/${1}\" を作成しました。"
}

if [[ ! -e ~/.oh-my-zsh ]]; then
  # oh-my-zshインストール
  curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
fi

# cobalt2のインストール
install_cobalt2
# .zshrc
make_link .zshrc
# my.zsh
make_link my.zsh

