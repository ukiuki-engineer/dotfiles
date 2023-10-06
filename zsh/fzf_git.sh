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
    git branch -a \
      --sort=-committerdate \
      --sort=-HEAD \
      --color=always \
      --format=$'%(HEAD) %(color:yellow)%(refname:short)\t%(color:green)%(committerdate:short)\t%(color:blue)%(subject)%(color:reset)' \
      | column -ts$'\t' \
      | fzf \
        --ansi \
        --border \
        --border-label ' Branches' \
        --height=80% \
        --header $header \
        --preview 'git log --oneline --graph --date=format:"%Y/%m/%d %H:%M:%S" --color=always --pretty="%C(auto)%h %C(blue)%ad %C(green)[%an]%C(reset) %s"' \
        --preview-window='right,70%' \
        --bind=">:execute(echo 'select-action' > $tmp)+accept" \
      | sed -e 's/\*//' \
      | awk '{print $1}'
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

  local branch=$1
  local header="Enter: select action, <: back"
  local tmp=$(mktemp)

  # 選択肢
  actions="
    checkout,
    delete,
    merge,
    echo,
  "
  actions=$(echo $actions | sed -e 's/,/\n/g' -e 's/ //g' | grep -vE '^$')

  # 選択
  local action=$(
    echo $actions \
      | fzf \
        --border \
        --border-label 'Branch Actions' \
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
