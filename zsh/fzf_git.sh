if [[ $# -ge 1 ]]; then
  # NOTE: ここは後で使うかも
  exit
fi

# ------------------------------------------------------------------------------
_fzf_git_branches() {
  # git projectでなければ終了する
  if ! git status >/dev/null; then
    return 1
  fi

  local command="echo hello>~/hello.txt"
  local header="Enter: checkout, >: Select action(FIXME: 未実装。今は一旦echoするだけ。)"

  local branch=$(
    git branch -a | fzf \
      --height=80% \
      --header $header \
      --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1)' "$@" \
      --preview-window='right,70%' \
      --bind='>:become(echo {})' \
      | sed -e 's/\*//' -e 's/ //g'
  )

  if [ -z "$branch" ]; then
    return 1
  fi

  if echo $branch | grep 'remotes/origin'; then
    git checkout -t $branch
  else
    git checkout $branch
  fi
}

# ------------------------------------------------------------------------------
# TODO
__branch_action() {
  # local branch=$1
  local actions="delete\ncheckout\nmerge"
  echo $actions | fzf
}

# ------------------------------------------------------------------------------
alias gitBranches='_fzf_git_branches'
