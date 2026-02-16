#!/bin/bash
################################################################################
# my zshrc installation
# 一回だけ行えば良い処理などはzshrcではなくなるべくここに書く
# NOTE: 多分zshで実行しないといけない
################################################################################
# ------------------------------------------------------------------------------
# 関数
# ------------------------------------------------------------------------------
#
# ユーザーホームにシンボリックリンクを作成する関数
# 引数:ファイル名
#
function _make_link() {
  target_path=$1
  target_name=$(basename $target_path)
  # ファイルがある&&シンボリックリンク→unlink
  if [[ -e $HOME/${target_name} && -L $HOME/${target_name} ]]; then
    unlink $HOME/${target_name}
  # ファイルがある&&シンボリックリンクではない→バックアップを取る
  elif [[ -e $HOME/${target_name} && ! -L $HOME/${target_name} ]]; then
    mv $HOME/${target_name} $HOME/${target_name}.bak
    echo " \"$HOME/${target_name}\" のバックアップ \"$HOME/${target_name}.bak\" を作成しました。"
  fi
  ln -s ${target_path} $HOME/${target_name}
  echo "シンボリックリンク \"${target_path} -> $HOME/${target_name}\" を作成しました。"
}
# ------------------------------------------------------------------------------
# main関数
# ------------------------------------------------------------------------------
function main() {
  #
  # ダウンロードとかインストール
  #
  # zinit
  if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" \
      && print -P "%F{33} %F{34}Installation successful.%f%b" \
      || print -P "%F{160} The clone has failed.%f%b"
  fi

  # mytools
  if [ ! -e $HOME/mytools ]; then
    git clone https://github.com/ukiuki-engineer/mytools $HOME/mytools
  fi
  #
  # シンボリックリンク作成
  #
  here_dir=$(
    cd $(dirname $0)
    pwd
  )
  zshrc_path=$(realpath "${here_dir}/../.zshrc")
  zshrc_local_path=$(realpath "${here_dir}/../.zshrc_local")

  # 各シンボリックリンクを作成
  _make_link ${zshrc_path}
  _make_link ${zshrc_local_path}
  _make_link ${here_dir}
  #
  # WSL固有の処理
  #
  # if [ -n "$WSLENV" ]; then
  #   # TODO: 以下がされてるか判定してその結果次第で処理するように
  #   # Ubuntuのレポジトリサーバを日本国内のに変更
  #   sudo sed -i.bak -e "s/http:\/\/archive\.ubuntu\.com/http:\/\/jp\.archive\.ubuntu\.com/g" /etc/apt/sources.list
  # fi
}
# ------------------------------------------------------------------------------
main
