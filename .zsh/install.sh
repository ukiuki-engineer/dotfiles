#!/bin/bash
################################################################################
# my zshrc installation
################################################################################
#
# ユーザーホームにシンボリックリンクを作成する関数
# 引数:ファイル名
#
function make_link() {
  target_path=$1
  if [[ ! -f ${target_path} ]]; then
    return
  fi
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

# zinitのインストール
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
  command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" \
    && print -P "%F{33} %F{34}Installation successful.%f%b" \
    || print -P "%F{160} The clone has failed.%f%b"
fi

here_dir=$(
  cd $(dirname $0)
  pwd
)
zshrc_path=$(realpath "${here_dir}/../.zshrc")
zshenv_path=$(realpath "${here_dir}/../.zshenv")
zshrc_local_path=$(realpath "${here_dir}/../.zshrc_local")
zshenv_local_path=$(realpath "${here_dir}/../.zshenv_local")

# 各シンボリックリンクを作成
make_link ${zshrc_path}
make_link ${zshenv_path}
make_link ${zshrc_local_path}
make_link ${zshenv_local_path}
make_link ${here_dir}
