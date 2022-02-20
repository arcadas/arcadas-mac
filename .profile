################################################################################
#
#   BASH
#
#   "Bash is a Unix shell and command language written by Brian Fox for the GNU
#   Project as a free software replacement for the Bourne shell.[7][8] First
#   released in 1989,[9] it has been distributed widely as the default login
#   shell for most Linux distributions and Apple's macOS (formerly OS X). A
#   version is also available for Windows 10.[10]"
#
#   https://en.wikipedia.org/wiki/Bash_(Unix_shell)
#
################################################################################

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

export BASH_SILENCE_DEPRECATION_WARNING=1

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

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

################################################################################
# UNIX
################################################################################

export EDITOR="/usr/bin/vim"

# Custom Colorized Prompt with Git Info

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

force_color_prompt=yes

parse_git_branch() {
 git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ on \1/'
}

if [ "$color_prompt" = yes ]; then
 PS1='\[\033[01;32m\]\h\[\033[00m\] in \[\033[01;36m\]\w\[\033[01;33m\]$(parse_git_branch)\[\033[00m\] \$\n> '
else
 PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(parse_git_branch)\$ '
fi

################################################################################
# Custom Bash Alias Files
################################################################################

if [ -f ~/.bash_aliases_os ]; then
    . ~/.bash_aliases_os
fi
if [ -f ~/.bash_aliases_git ]; then
    . ~/.bash_aliases_git
fi
if [ -f ~/.bash_aliases_docker ]; then
    . ~/.bash_aliases_docker
fi
if [ -f ~/.bash_aliases_aws ]; then
    . ~/.bash_aliases_aws
fi

################################################################################
# OTHER
################################################################################

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Homebrew
# eval "$(/opt/homebrew/bin/brew shellenv)"

# [[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

# NVM
# export NVM_DIR="$HOME/.nvm"
#   [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
#   [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
