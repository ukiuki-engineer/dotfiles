# ==============================================================================
# aliases
# ==============================================================================
alias ls="ls ${LSOPTIONS}"
alias la='ls -a'
alias ll='ls -l'
alias grep='grep --color=auto'
alias dockerExecShell='fzf_docker_exec_shell'
alias emoji='fzf_emoji'
alias cds='dirs -v; echo -n "select number: "; read newdir; cd +"$newdir"'
alias gitLogOneline='git log --oneline --graph --date=format:"%Y/%m/%d %H:%M:%S" --color=always --pretty="%C(auto)%h %C(blue)%ad %C(green)[%an]%C(reset) %s" '

