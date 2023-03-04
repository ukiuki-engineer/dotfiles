# zshの自分用設定ファイル


## ディレクトリ構成
```
zsh/
   ├── install.sh  # インストーラ
   ├── .zshrc      # zsh設定のメインファイル
   ├── .my.zsh     # 追加設定
   └── readme.md
```

## インストール方法
git cloneしてinstall.shを叩くだけ

## theme
cobalt2をベースとして、以下のようにカスタマイズして使用している。
- PROMPTのgit情報にuser.nameを追加
- PROMPTのgit情報にuser.emailを追加
- アイコンをOSに応じて変更
- カレントディレクトリをフルパスに
- 最後に改行を入れる

## Fonts
[powerlinefonts](https://github.com/powerline/fonts)
