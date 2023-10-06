# ------------------------------------------------------------------------------
# fzfによるgit操作
# →前提: fzfがインストールされていること
# →インストール方法: このscriptを、.bashrcや.zshrc中でsourceするだけ
# →使用方法： 以下のコマンドが使用可能(今はまだ一つ。今後増えていく予定)
#   ・gitBranches: ブランチ操作
#   ・gitStatus  : **多分今後実装する**
#   ・gitStashs  : **多分今後実装する**
#
# TODO: まだ作り始めなので機能的には不十分。今後ちょこちょこ足していく
# ------------------------------------------------------------------------------

# branches
_fzf_git_branches() {
  # git projectでなければ終了する
  if ! git status >/dev/null; then
    return 1
  fi

  local header="Enter: checkout, >: Select action"
  local tmp=$(mktemp)

  # 選択
  local branch=$(
    git branch -a | fzf \
      --height=80% \
      --header $header \
      --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1)' "$@" \
      --preview-window='right,70%' \
      --bind=">:execute(echo 'select-action' > $tmp)+accept" \
      | sed -e 's/\*//' -e 's/ //g'
  )

  # 選択されてなければ中断
  if [ -z "$branch" ]; then
    rm $tmp
    return 1
  fi

  # select action
  if cat $tmp | grep 'select-action' >/dev/null 2>&1; then
    rm $tmp
    __branch_actions $branch
    return
  fi

  rm $tmp

  # checkout
  __checkout $branch
}

# ------------------------------------------------------------------------------
# branchに対するaction
__branch_actions() {
  if [[ $# -eq 0 ]]; then
    return 1
  fi

  # 引数取得
  local branch=$1
  # 選択肢
  local actions="checkout\ndelete\nmerge\necho"
  local header="Enter: select action, <: back"
  local tmp=$(mktemp)

  # 選択
  local action=$(
    echo $actions | fzf \
      --header $header \
      --height=20% \
      --prompt="Select actions for the branch, \"$branch\">" \
      --bind="<:execute(echo 'back' > $tmp)+accept"
  )

  # 選択されてなければ中断
  if [ -z "$action" ]; then
    rm $tmp
    return 1
  fi

  # back
  if cat $tmp | grep 'back' >/dev/null 2>&1; then
    rm $tmp
    _fzf_git_branches
    return
  fi

  rm $tmp

  # ここからactionの処理
  if [[ $action == "checkout" ]]; then
    # checkout
    __checkout $branch
  elif [[ $action == "delete" ]]; then
    # delete
    git branch -d $branch
    _fzf_git_branches
  elif [[ $action == "merge" ]]; then
    # merge
    git merge $branch
  elif [[ $action == "echo" ]]; then
    # echo
    echo $branch
  fi
}

# checkoutする
__checkout() {
  local branch=$1
  if echo $branch | grep 'remotes/origin'; then
    # remote
    git checkout -t $branch
  else
    # local
    git checkout $branch
  fi
}

# ------------------------------------------------------------------------------
alias gitBranches='_fzf_git_branches'
