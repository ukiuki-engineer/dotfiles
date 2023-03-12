# zshの自分用設定ファイル


## ディレクトリ構成
```
zsh/
   ├── install.sh  # インストーラ
   ├── .zshrc      # zsh設定のメインファイル
   ├── .my.zsh     # 追加設定
   └── readme.md
```

- `.zshrc`:  
基本的にはこのファイルではthemeの設定以外行わない。  
このファイルから、以下のように`my.zsh`と`local.zsh`を読み込んでいる。
```sh
source ~/my.zsh
if [ -e ~/local.zsh ]; then
  source ~/local.zsh
fi
```
- `my.zsh`:  
色々カスタマイズしたい場合はこのファイルで行う。  

- `local.zsh`:  
環境に依存する設定は適宜このファイルで行う。  
特に`$PATH`などは環境に依存しやすいためこのファイルで定義する。  
このファイルは環境ごとに作成し、このリポジトリには追加しない。

## インストール方法
git cloneしてinstall.shを叩くだけ。

## theme
cobalt2をベースとして、以下のようにカスタマイズして使用している。
- PROMPTのgit情報にuser.nameを追加
- PROMPTのgit情報にuser.emailを追加
- アイコンをOSに応じて変更
- カレントディレクトリをフルパスに
- 最後に改行を入れる

## Fonts
[powerlinefonts](https://github.com/powerline/fonts)
