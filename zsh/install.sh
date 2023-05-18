#!/bin/bash
################################################################################
# my zshrc installation
################################################################################
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

# oh-my-zshのインストール
if [[ ! -e ~/.oh-my-zsh ]]; then
  curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
fi

# cobalt2のインストール
if [[ -e ~/.oh-my-zsh/themes/cobalt2.zsh-theme ]]; then
  # cobalt2がある場合は処理終了
  return
fi
if [[ ! -e ~/Cobalt2-iterm ]]; then
  git clone https://github.com/wesbos/Cobalt2-iterm.git
  mv Cobalt2-iterm ~/
fi
cp ~/Cobalt2-iterm/cobalt2.zsh-theme ~/.oh-my-zsh/themes/

# .zshrcのシンボリックリンクをホームディレクトリに
make_link .zshrc
# my.zshのシンボリックリンクをホームディレクトリに
make_link .my.zsh

