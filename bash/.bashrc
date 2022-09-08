# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

alias ls='ls --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias vim=nvim
alias view='nvim -R'
alias cat=bat
