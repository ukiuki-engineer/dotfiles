#!/bin/bash
################################################################################
# my zshrc installation
################################################################################
#
# シンボリックリンクを作成する関数
# 引数:ファイル名
#
function make_link() {
  target_path=$1
  target_name=$(basename $target_path)
  # ファイルがある&&シンボリックリンク→unlink
  if [[ -e ~/${target_name} && -L ~/${target_name} ]]; then
    unlink ~/${target_name}
  # ファイルがある&&シンボリックリンクではない→バックアップを取る
  elif [[ -e ~/${target_name} && ! -L ~/${target_name} ]]; then
    mv ~/${target_name} ~/${target_name}.bak
    echo " \"~/${target_name}\" のバックアップ \"~/${target_name}.bak\" を作成しました。"
  fi
  ln -s ${target_path} ~/${target_name}
  echo "シンボリックリンク \"${target_path} -> ~/${target_name}\" を作成しました。"
}

# oh-my-zshのインストール
if [[ ! -e ~/.oh-my-zsh ]]; then
  curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
fi

# cobalt2のインストール
if [[ ! -e ~/.oh-my-zsh/themes/cobalt2.zsh-theme ]]; then
  if [[ ! -e ~/Cobalt2-iterm ]]; then
    git clone https://github.com/wesbos/Cobalt2-iterm.git
    mv Cobalt2-iterm ~/
  fi
  cp ~/Cobalt2-iterm/cobalt2.zsh-theme ~/.oh-my-zsh/themes/
fi

here_dir=$(
  cd $(dirname $0)
  pwd
)
zshrc_path=$(realpath "${here_dir}/../.zshrc")

# .zshrcのシンボリックリンクをホームディレクトリに
make_link ${zshrc_path}
# .zsh/のシンボリックリンクをホームディレクトリに
make_link ${here_dir}
