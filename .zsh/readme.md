# WSLインストール時にやること

## Ubuntuのレポジトリサーバを日本国内のに変更

```sh
sudo sed -i.bak -e "s/http:\/\/archive\.ubuntu\.com/http:\/\/jp\.archive\.ubuntu\.com/g" /etc/apt/sources.list
```

## dockerインストール

```sh
# NOTE: https://docs.docker.com/engine/install/ubuntu/
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
# NOTE: sudo抜きでdockerコマンドを実行できるようにするには↓
sudo usermod -aG docker $USER
```
# TODO

- [ ] 起動速度が遅いからなんか対策する
  - 遅延ロードとか入れる？でも面倒そう
  - 便利コマンド系は設定ファイルから切り出す？
