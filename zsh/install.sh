#!/bin/bash
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

#
# .zshrc追記処理
#
function writeToZshrc() {
  echo "# 個人設定" >> ~/.zshrc
  echo "# 大体の設定はmy.zshに書く。.zshrcにはあまり書かないようにする" >> ~/.zshrc
  echo "source ~/my.zsh" >> ~/.zshrc
  echo "# source ~/dotfiles/my.zsh" >> ~/.zshrc
  echo "# 環境ごとの設定" >> ~/.zshrc
  echo "# 環境に依存する設定は~/.local.zshに書く" >> ~/.zshrc
  echo "if [ -e ~/local.zsh ]; then" >> ~/.zshrc
  echo "  source ~/local.zsh" >> ~/.zshrc
  echo "fi" >> ~/.zshrc
}

if [[ ! -e ~/.oh-my-zsh ]]; then
  # oh-my-zshインストール
  curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
  # .zshrc追記
  writeToZshrc
  # my.zsh
  makeLink my.zsh
else
  echo "FIXME: 既にoh-my-zshがインストールされている場合の処理未実装"
fi
