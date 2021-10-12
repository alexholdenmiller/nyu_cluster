# ~/.bashrc: executed by bash(1) for non-login shells.

export DISPLAY='localhost:0.0'

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#setup my PROMPT
if [[ -n "$PS1" ]] ; then
    #setup some useful colors
    export RED="\[\033[0;31m\]"
    export GREEN="\[\033[0;32m\]"
    export YELLOW="\[\033[0;33m\]"
    export CYAN="\[\033[1;36m\]"
    export GRAY="\[\033[0;37m\]"
    export BLUE="\[\033[1;34m\]"
    export NO_COLOR="\[\033[0m\]"
    #generate fields that aren't going to change, so they can be set once
    export YEAR=`date +%Y`

    function success-color {
        if [[ $1 -eq 0 ]] ; then
            #GREEN
            echo -ne "\033[0;32m"
        else
            #RED
            echo -ne "\033[0;31m"
        fi
    }

    #start with an empty line
    PS1="\n"
    #Choose a color based on whether the last command succeeded or not
    PS1="$PS1"'$([[ ${?:-0} -eq 0 ]] && echo "\033[0;32m" || echo "\033[0;31m")'
    #add the time, date, user@host and full path
    PS1="$PS1[\t \d $YEAR] $YELLOW\u$NO_COLOR@$BLUE${HOSTNAME%.facebook.com} $CYAN\w"
    #add the basename, the git branch the history number and the $ symbol
    #PS1="$PS1\n\W $GREEN"'$(_dotfiles_scm_info)'" $RED\! $NO_COLOR\$ "
    PS1="$PS1\n\W $GREEN $NO_COLOR\$ "
    export PS1
fi

export EDITOR=`which vim`

alias py='python'
alias pyd='python -m pdb -c c'


git config --global alias.b branch
git config --global alias.ch checkout
git config --global alias.cm "commit -m"
git config --global alias.st status
