# ==============================================================================
# 基本的な設定
# ==============================================================================
# history
HISTFILE=$HOME/.zsh_history     # 履歴を保存するファイル
HISTSIZE=100000                 # メモリ上に保存する履歴のサイズ
SAVEHIST=1000000                # 上述のファイルに保存する履歴のサイズ

# share .zshhistory
setopt inc_append_history       # 実行時に履歴をファイルにに追加していく
setopt share_history            # 履歴を他のシェルとリアルタイム共有する

setopt hist_ignore_all_dups     # ヒストリーに重複を表示しない
setopt hist_save_no_dups        # 重複するコマンドが保存されるとき、古い方を削除する。
setopt extended_history         # コマンドのタイムスタンプをHISTFILEに記録する
setopt hist_expire_dups_first   # HISTFILEのサイズがHISTSIZEを超える場合は、最初に重複を削除する

# 補完で大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# 補完候補をカーソルで選択できるように
autoload -U compinit
compinit
zstyle ':completion:*:default' menu select=1

# cd周り
# auto_ls
function chpwd(){
    if [[ $(pwd) != $HOME ]]; then;
        ls
    fi
}
autoload chpwd

# ディレクトリ名だけでcdする
setopt AUTO_CD
# cd したら自動的にpushdする
setopt AUTO_PUSHD
# 重複したディレクトリをスタックに追加しない
setopt PUSHD_IGNORE_DUPS
# ------------------------------------------------------------------------------
# WSL固有の設定
# ------------------------------------------------------------------------------
if [ -n "$WSLENV" ]; then
  # dockerのインストール
  if ! which docker >/dev/null 2>&1; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    # NOTE: sudo抜きでdockerコマンドを実行できるようにするには↓
    # sudo usermod -aG docker $USER
  fi
fi

