case $- in
    *i*) ;;
      *) return;;
esac
export HISTCONTROL=ignoreboth
shopt -s histappend
export HISTSIZE=1000
export HISTFILESIZE=10000
export HISTTIMEFORMAT="%d/%m/%y %T "
PROMPT_COMMAND='echo -en "\e]0;$(dirs)\a"'
PROMPT_COMMAND="history -a;history -n;$PROMPT_COMMAND"

export DISPLAY=192.168.1.2:1.0

shopt -s checkwinsize
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

PS1="\[\e[38;2;224;108;117m\]\h \[\e[38;2;97;175;239m\]\w \[\e[m\]\$ "

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

source ~/.onedark_prompt.sh
