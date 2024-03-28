# ------------------------------------------------------------------------------
# history
# ------------------------------------------------------------------------------
HISTFILE=$HOME/.zsh_history     # 履歴を保存するファイル
HISTSIZE=100000                 # メモリ上に保存する履歴のサイズ
SAVEHIST=1000000                # 上述のファイルに保存する履歴のサイズ
setopt inc_append_history       # 実行時に履歴をファイルにに追加していく
setopt share_history            # 履歴を他のシェルとリアルタイム共有する
setopt hist_ignore_all_dups     # ヒストリーに重複を表示しない
setopt hist_save_no_dups        # 重複するコマンドが保存されるとき、古い方を削除する。
setopt extended_history         # コマンドのタイムスタンプをHISTFILEに記録する
setopt hist_expire_dups_first   # HISTFILEのサイズがHISTSIZEを超える場合は、最初に重複を削除する
# ------------------------------------------------------------------------------
# 補完の設定
# ------------------------------------------------------------------------------
# 補完候補をカーソルで選択
zstyle ':completion:*:default' menu select=1
# 大文字小文字を区別しない、部分一致
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|=* l:|=*'
# 補完システムの初期化
autoload -U compinit
compinit
# ------------------------------------------------------------------------------
# cd周り
# ------------------------------------------------------------------------------
# auto_ls
function chpwd(){
  if [[ $(pwd) != $HOME ]]; then;
    eval "\ls ${LSOPTIONS}"
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
# キーバインド
# ------------------------------------------------------------------------------
# insert mode中はEmacsキーバインドを使用
bindkey -M viins '^f' forward-char
bindkey -M viins '^b' backward-char
bindkey -M viins '^p' up-line-or-history
bindkey -M viins '^n' down-line-or-history
bindkey -M viins '^a' beginning-of-line
bindkey -M viins '^e' end-of-line
bindkey -M viins '^h' backward-delete-char
bindkey -M viins '^d' delete-char-or-list
