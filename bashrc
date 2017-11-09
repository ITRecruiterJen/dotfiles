#!/bin/bash

[ -z "$PS1" ] && return    # If not running interactively, don't do anything

#==============================================================================
# SETTINGS
#==============================================================================

export EDITOR=vim                       # editor
PS1="\u@\[\e[0;32m\]\h\[\e[m\]\w\$ "    # prompt
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
# LOAD SECRETS INTO ENVIRONMENT (if any)
#==============================================================================

if [ -f $HOME/.env ]; then
  . $HOME/.env
fi

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

alias bi='bundle install'
alias be='bundle exec'
alias rg='be rails generate'
alias routes='be rake routes'
alias rt='be rake test'
alias rit='be ruby -Itest -Ilib -Iapp'

alias fs='foreman start'
alias fr='foreman run'

function rs()
{
  be rails server -b 0.0.0.0
}

function rc()
{
  be rails console
}

#==============================================================================
# GIT & MERCURIAL HELPERS
#==============================================================================

alias gs='git status'
alias gr='git pull --rebase'
alias gb='git branch -a'
alias gl='git log --graph --all --decorate'
alias gd='git diff HEAD'
alias gp='git pull --ff-only'
alias gf='git fetch'
alias gc='git reset --hard'


#==============================================================================
# MAKE HELPERS
#==============================================================================

# alias mt='make test'
# alias mr='make run'
# alias md='make deps'
# alias mi='make install'
# alias mw='make watch'

#==============================================================================
# NODE HELPERS
#==============================================================================

alias ni='npm install'
alias nt='npm run test'
alias ns='npm run start'
alias nb='npm run build'
alias nr='npm run'

alias yi='yarn install'
alias yt='yarn test'
alias yr='yarn run'

#==============================================================================
# ELIXIR/MIX HELPERS
#==============================================================================

alias imix='iex -S mix'
alias mixi='mix deps.get'
alias mixc='mix compile'
alias mixt='mix test'

dmix() {
  iex --name `hostname`@127.0.0.1 --cookie debug --erl "-kernel inet_dist_listen_min 9001 inet_dist_listen_max 9001" -S mix $1
}

dtunnel() {
  ssh -N -L 9001:localhost:9001 -L 4369:localhost:4369 ${1:-jake@192.168.56.100}
}

dobserve() {
  erl -name `hostname`@127.0.0.1 -setcookie debug -run observer
}

#==============================================================================
# PYTHON HELPERS
#==============================================================================

# alias pss='python -m SimpleHTTPServer'

#==============================================================================
# KUBERNETES HELPERS
#==============================================================================

# alias kc='kubectl'
# alias kcs='kubectl --namespace=kube-system'

#==============================================================================
# OTHER ALIASES
#==============================================================================

if [ -x /usr/bin/dircolors ]; then  # enable color support of ls and grep
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

alias c='clear'
alias less='less -r'

alias ll='ls -Al'
alias la='ls -A'

alias h=history

alias vimvim="vim -c EditVim"
alias vimbash="vim -c EditBash"

alias tmux="TERM=xterm-256color tmux"

alias api='cd ~/api'
alias www='cd ~/www'
alias demo='cd ~/demo'
alias up='cd ~/up'

alias ci='ssh ci'
alias lp='ssh lp'

app() {
  if [ -d "$HOME/app" ]; then
    cd "$HOME/app"
  elif [ -d "$HOME/application" ]; then
    cd "$HOME/application"
  fi
}

dev() {
  if [ -d "$HOME/dev" ]; then
    cd "$HOME/dev"
  elif [ -d "$HOME/development" ]; then
    cd "$HOME/development"
  fi
}

ops() {
  if [ -d "$HOME/ops" ]; then
    cd "$HOME/ops"
  elif [ -d "$HOME/operations" ]; then
    cd "$HOME/operations"
  fi
}

services() {
  if [ -d "$GOPATH/src/github.com/chemistrygroup/services" ]; then
    cd "$GOPATH/src/github.com/chemistrygroup/services"
  fi
}

#==============================================================================
# BUILDING DEBIAN PACKAGES (http://packaging.ubuntu.com/html/getting-set-up.html#configure-your-shell)
#==============================================================================
export DEBFULLNAME="Jesse James"
export DEBEMAIL="jjames@workwithopal.com"

#==============================================================================

if type brew > /dev/null 2>&1; then
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi
fi
