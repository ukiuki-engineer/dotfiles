#!/bin/bash
# FIXME oh-my-zshをインストールする処理を追加する
# 現状はoh-my-zsh本体をそのままリポジトリに突っ込んでいる
# NOTE: oh-my-zshインストール↓
# curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

#
# シンボリックリンクを作成する関数
# 引数:ファイル名
#
function makeLink() {
  # ファイルがある&&シンボリックリンク→unlink
  if [[ -e ~/$1 && -L ~/$1 ]]; then
    unlink ~/$1
  # ファイルがある&&シンボリックリンクではない→バックアップを取る
  elif [[ -e ~/$1 && ! -L ~/$1 ]]; then
    mv ~/$1 ~/$1.bak
  fi
  ln -s ${PWD}/$1 ~/$1
  echo "${PWD}/${1}→~/${1}のシンボリックリンクを作成しました。"
}

# .zshrc
makeLink .zshrc
# my.zsh
makeLink my.zsh
# .oh-my-zsh
makeLink .oh-my-zsh
