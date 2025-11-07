# ==============================================================================
# functions
# ==============================================================================
# ダブらないように$PATHに追加する(先頭)
path_prepend() {
  if [[ ":$PATH:" != *":$1:"* ]]; then
    export PATH=$1:${PATH}
  fi
}

# ダブらないように$PATHに追加する(末尾)
path_append() {
  if [[ ":$PATH:" != *":$1:"* ]]; then
    export PATH=${PATH}:$1
  fi
}

# 選択したcontainerのシェルを実行する
# TODO: ヘッダーを表示させたい
fzf_docker_exec_shell() {
  # dockerコマンドが無ければ終了
  if ! which docker >/dev/null 2>&1; then
    which docker
    return 1
  fi

  # トライするシェルのリスト
  local shells="bash, ash, sh"
  # コンテナ名
  local container_name
  # 実行するシェル
  local exec_shell
  # 実行コマンド
  local exec_command

  # container id
  local cid=$(docker ps | sed 1d | fzf -q "$1" --height=10% | awk '{print $1}')

  # container idが選択できていなければ終了
  if [ -z "$cid" ]; then
    return 1
  fi

  # コンテナ名を取得
  container_name=$(docker ps --format '{{.Names}}' --filter "id=$cid")

  # 実行可能なshellを調べる
  for shell in $(echo $shells | tr ', ' '\n'); do
    if docker exec $cid $shell > /dev/null 2>&1; then
      exec_shell=$shell
      break
    fi
  done

  # 実行可能なshellが無ければ終了
  if [ -z $exec_shell ]; then
    echo "container name: $container_name"
    echo "executable shell does not exists in $shells"
    return 1
  fi

  # コマンドをプロンプトに出力
  exec_command="docker exec -it $container_name $exec_shell"
  print -z $exec_command
  # NOTE: 直接実行するには以下だけど、プロンプトに表示か直接実行かオプションで選択できるようにした方が良いか迷ってる
  # eval $exec_command
}

fzf_find_file_with_preview() {
  rg --files --hidden --follow --glob "!**/.git/*"\
    | fzf --preview 'bat  --color=always --style=header,grid {}' --preview-window=right:60%
}

fzf_rg() {
  rg --color=always --line-number --no-heading --smart-case "${*:-}" |
    fzf --ansi \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'right:60%,border-bottom,+{2}+3/3,~3' \
        --bind 'enter:become(echo {1})'
}

fzf_man_pages() {
  # previewに使用するコマンド
  if which bat >/dev/null 2>&1; then
    # batを使えるならbatで表示する
    preview='man -P cat $(echo {1} | sed -e "s/(/ /" -e "s/)//" | awk "{print \$2, \$1}") | col -bx | bat --language=man --style=plain --paging=never --color=always'
  else
    preview='man -P cat $(echo {1} | sed -e "s/(/ /" -e "s/)//" | awk "{print \$2, \$1}")'
  fi

  # manページを選択
  manPage=$(
    man -k . \
      | grep -E '\(1\)|\(2\)|\(3\)|\(4\)|\(5\)|\(6\)|\(7\)|\(8\)|\(9\)' \
      | fzf \
        --ansi \
        --height=90% \
        --border \
        --preview $preview
  )
  manPage=$(echo $manPage | awk '{print $1}' | sed -e 's/(/ /' -e 's/)//' | awk '{print $2, $1}')

  # コマンドをプロンプトに出力
  print -z "man $manPage"
}

# 指定されたファイルの中で、改行コードが混在してるファイルを洗い出す
check_mixed_eol() {
  files=("$@")
  for file in "${files[@]}"; do
    if file "$file" | grep -q 'text'; then
      # テキストファイルのみ対象
      awk '{ if (sub(/\r$/,"")) crlf++; else lf++; } END {if (crlf != 0 && lf != 0) print FILENAME,"CRLF:",crlf,"LF:",lf}' "${file}"
    fi
  done
}

# Git管理してるファイルの中で、改行コードが混在してるファイルを洗い出す
git_mixed_eol() {
  git ls-files \
    | while read -r line; do
      check_mixed_eol $line
    done
}

