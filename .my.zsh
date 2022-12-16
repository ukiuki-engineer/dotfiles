#
# aliases
#
alias ls='ls -FG' # FIXME: 環境によって違うためifで分ける
alias la='ls -a'
alias ll='ls -l'
alias grep='grep --color=auto'
# 簡易treeコマンド。
which tree > /dev/null 2&>1
if [ $? != 0 ]; then
  alias tree="pwd;find . | sort | sed '1d;s/^\.//;s/\/\([^/]*\)$/|--\1/;s/\/[^/|]*/|  /g'"
fi
