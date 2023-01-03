#!/bin/bash
# FIXME oh-my-zshをインストールする処理を追加する
# 現状はoh-my-zsh本体をそのままリポジトリに突っ込んでいる
# curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
# FIXME .zshrcのbackupを取るようにする
ln -s ${PWD}/.zshrc ~/.zshrc
ln -s ${PWD}/.my.zsh ~/.my.zsh
ln -s ${PWD}/.oh-my-zsh ~/.oh-my-zsh
