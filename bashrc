#!/bin/bash

[ -z "$PS1" ] && return    # If not running interactively, don't do anything

#==============================================================================
# SETTINGS
#==============================================================================

export EDITOR=vim                       # editor
PS1="\u@\[\e[0;32m\]\h\[\e[m:\]\w\$ "   # prompt
HISTCONTROL=ignoredups:ignorespace      # don't duplicate lines in history
HISTSIZE=1000                           # history length
HISTFILESIZE=2000
export HH_CONFIG=hicolor,rawhistory

shopt -s histappend                # append to history, don't overwrite it
shopt -s checkwinsize              # dynamically update the values of LINES and COLUMNS

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"  # make less more friendly for non-text input files, see lesspipe(1)

stty stop undef     # stop <C-s> being swallowed by xterm
stty start undef    # stop <C-q> being swallowed by xterm

#==============================================================================
# PATH MANIPULATION
#==============================================================================

append_path() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$PATH:$1"
  fi
}

prepend_path() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1:$PATH"
  fi
}

#==============================================================================
# ANDROID
#==============================================================================

if [ -d "$HOME/android" ]; then
  append_path "$HOME/android/tools"
  append_path "$HOME/android/platform-tools"
fi

#==============================================================================
# GO
#==============================================================================

if [ -d "$HOME/go" ]; then
  export GOPATH=$HOME/go
  append_path "$GOPATH/bin"
fi

#==============================================================================
# DIGITAL OCEAN ENVIRONMENT
#==============================================================================

if [ -d "$HOME/.digitalocean" ]; then
  if [ -e "$HOME/.digitalocean/do_access_token" ]; then
    export DO_ACCESS_TOKEN=`cat $HOME/.digitalocean/do_access_token`
  fi
  if [ -e "$HOME/.digitalocean/do_client_id" ]; then
    export DO_CLIENT_ID=`cat $HOME/.digitalocean/do_client_id`
  fi
  if [ -e "$HOME/.digitalocean/do_api_key" ]; then
    export DO_API_KEY=`cat $HOME/.digitalocean/do_api_key`
  fi
fi

#==============================================================================
# BUNDLER/RUBY HELPERS
#==============================================================================

function bi()
{
  if [ -e "Gemfile.local" ]; then
    BUNDLE_GEMFILE=Gemfile.local bundle install
  else
    bundle install
  fi
}

function be()
{
  if [ -e "Gemfile.local" ]; then
    BUNDLE_GEMFILE=Gemfile.local bundle exec $1 $2 $3 $4 $5 $6 $7 $8 $9 $10
  else
    bundle exec $1 $2 $3 $4 $5 $6 $7 $8 $9 $10
  fi
}

alias rc='be rails console'
alias rs='be rails server -b 0.0.0.0'
alias rg='be rails generate'
alias db='be rails db'
alias rr='be rake'
alias rt='be rake test'
alias rit='be ruby -Itest -Ilib -Iapp'

#==============================================================================
# ALIASES
#==============================================================================

if [ -x /usr/bin/dircolors ]; then  # enable color support of ls and grep
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

alias less='less -r'

alias ll='ls -Al'
alias la='ls -A'

alias h=history

alias vimvim="vim -c EditVim"
alias vimbash="vim -c EditBash"

alias tmux="TERM=xterm-256color tmux"

alias app='cd ~/app'
alias api='cd ~/api'
alias ops='cd ~/ops'
alias dev='cd ~/dev'
alias www='cd ~/www'
alias core='cd ~/core'

