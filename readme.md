## 概要
zshの自分用設定ファイル。  
\```git clone```してインストーラ(install.sh)を叩くとzsh環境を構築することができる。  
zshの設定ファイルのみ入っているため、リポジトリ名はdotfilesというよりzshrcとかにしといた方が良いかも...

## ディレクトリ構成
```
dotfiles/
        ├── install.sh  # インストーラ
        ├── .zshrc      # zsh設定のメインファイル
        ├── .my.zsh     # 追加設定
        ├── readme.md
        └── .oh-my-zsh/ # oh-my-zsh本体
```

## theme
cobalt2をベースとして、以下のようにカスタマイズして使用している。
- PROMPTのgit情報にuser.nameを追加
- PROMPTのgit情報にuser.emailを追加
- アイコンをOSに応じて変更
- カレントディレクトリをフルパスに
- 最後に改行を入れる
ソースは[.my.zshのこの行以降](https://github.com/ukiuki-engineer/dotfiles/blob/master/.my.zsh#L22)を参照。

## Fonts
[powerlinefonts](https://github.com/powerline/fonts)

## FIXME
- oh-my-zsh導入方法の変更
oh-my-zsh本体を直接突っ込むのではなく、oh-my-zshをインストールする処理をinstall.shに追加する
