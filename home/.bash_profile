export BASH_SILENCE_DEPRECATION_WARNING=1
export EDITOR=nvim
ulimit -n 10000

ssh-add

GREEN="\[\e[0;32m\]"
BLUE="\[\e[0;34m\]"
RED="\[\e[0;31m\]"
BRED="\e[1;31m\]"
YELLOW="\[\e[0;33m\]"
WHITE="\e[0;37m\]"
BWHITE="\e[1;37m\]"
COLOREND="\[\e[00m\]"

alias catch='python3 -m smtpd -n -c DebuggingServer localhost:1025'
alias serve='open http://localhost:8000; python3 SimpleHTTPServer;'
alias tree='tree --dirsfirst -C'
alias ls='ls -G'
alias ll='ls -lh'
alias l='ll'
alias lla='ll -A'
alias la='lla'
alias vi='vim'
alias gtop='cd $(git rev-parse --show-toplevel || echo ".")'
alias ag='ag --ignore=_site --ignore=log --ignore=vendor --ignore=tmp --smart-case --literal'
alias pubkey='cat ~/.ssh/id_rsa.pub'
alias mux='tmuxinator'
alias be="bundle exec"

..() {
  for i in $(seq ${1:-1}); do cd ..; done;
}

whoport() {
  lsof -n -i4TCP:$1
}

tgz() {
  tar -zcvf "$1.tar.gz" "$1"
}

untgz() {
  tar -zxvf $1
}

code() {
  if [ "$2" != "" ]; then
    prj_path=~/Code/`ls -1 ~/Code | grep -i -m 1 "$1"`
    vim "$prj_path/`ls -1 $prj_path | grep -i -m 1 "$2"`" -c "Git pull"
  else
    cd ~/Code
    if [ "$1" != "" ]; then
      cd `ls -1 | grep -i -m 1 "$1"`
    fi
  fi
}

HOMEBREW_ROOT=/opt/homebrew

# homebrew path adjustments
eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_NO_ANALYTICS=1

export NVM_DIR="$HOME/.nvm"
[ -s "$HOMEBREW_ROOT/opt/nvm/nvm.sh" ] && . "$HOMEBREW_ROOT/opt/nvm/nvm.sh"  # This loads nvm
[ -s "$HOMEBREW_ROOT/opt/nvm/etc/bash_completion.d/nvm" ] && . "$HOMEBREW_ROOT/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# more PATH adjustments
export PATH=$PATH:$HOME/bin # user bin directory
export PATH=$PATH:$HOME/.rbenv/bin # rbenv bin

USER_BASE_PATH=$(python3 -m site --user-base)
export PATH=$PATH:$USER_BASE_PATH/bin

export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

export GOROOT_BOOTSTRAP=$GOROOT
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

eval "$(rbenv init -)"

#BASH Completion - Homebrew
if [[ -z "$BASH_COMPLETION" ]]; then
	export BASH_COMPLETION=$HOMEBREW_ROOT/etc/bash_completion
fi

if [[ -z "$BASH_COMPLETION_DIR" ]]; then
	export BASH_COMPLETION_DIR=$HOMEBREW_ROOT/etc/bash_completion.d
fi

if [[ -z "$BASH_COMPLETION_COMPAT_DIR" ]]; then
	export BASH_COMPLETION_COMPAT_DIR=$HOMEBREW_ROOT/etc/bash_completion.d
fi

if [ -f $BASH_COMPLETION ]; then
. $BASH_COMPLETION
fi

#determines search program for fzf
if type ag &> /dev/null; then
    export FZF_DEFAULT_COMMAND='ag -p ~/.gitignore -g ""'
fi

#refer rg over ag
if type rg &> /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden'
fi

export ANDROID_HOME=$HOMEBREW_ROOT/opt/android-sdk

# Responsive Prompt
parse_node_version() {
  version=`nvm current | cut -f 2`
  echo "${BLUE}($version)${COLOREND} "
}

working_directory() {
  dir=`pwd`
  in_home=0
  if [[ `pwd` =~ ^"$HOME"(/|$) ]]; then
    dir="~${dir#$HOME}"
    in_home=1
  fi

  workingdir=""
  if [[ `tput cols` -lt 110 ]]; then
    first="/`echo $dir | cut -d / -f 2`"
    letter=${first:0:2}
    if [[ $in_home == 1 ]]; then
      letter="~$letter"
    fi
    proj=`echo $dir | cut -d / -f 3`
    beginning="$letter/$proj"
    end=`echo "$dir" | rev | cut -d / -f1 | rev`

    if [[ $proj == "" ]]; then
      workingdir="$dir"
    elif [[ $proj == "~" ]]; then
      workingdir="$dir"
    elif [[ $dir =~ "$first/$proj"$ ]]; then
      workingdir="$beginning"
    elif [[ $dir =~ "$first/$proj/$end"$ ]]; then
      workingdir="$beginning/$end"
    else
      workingdir="$beginning/…/$end"
    fi
  else
    workingdir="$dir"
  fi

  echo -e "${YELLOW}$workingdir${COLOREND} "
}

parse_git_prompt() {
  out=""

  if [[ -f "$BASH_COMPLETION_DIR/git-completion.bash" ]]; then
    branch=`__git_ps1 "%s"`
  else
    branch=$(git symbolic-ref --short HEAD | tr -d '\n') || return
  fi

  if [[ `tput cols` -lt 110 ]]; then
    branch=`echo $branch | sed s/feature/f/1`
    branch=`echo $branch | sed s/hotfix/h/1`
    branch=`echo $branch | sed s/release/\r/1`
    branch=`echo $branch | sed s/master/mstr/1`
    branch=`echo $branch | sed s/main/mn/1`
    branch=`echo $branch | sed s/develop/dev/1`
  fi

  status=$(git status -sb 2> /dev/null)

  if [[ $branch != "" ]]; then
    if [[ $(echo "$status" | wc -l) -gt 1 ]]; then
      out="$out${RED}$branch${COLOREND} "
    else
      out="$out${GREEN}$branch${COLOREND} "
    fi
  fi

  remote_state=$(echo "$status" | grep -oh "\[.*\]")

  if [[ "$remote_state" != "" ]]; then
    out="$out${BLUE}[${COLOREND}"
    ahead=$(echo "$status" | grep -oh "ahead \d*" | grep -oh "\d*$")
    behind=$(echo "$status" | grep -oh "behind \d*" | grep -oh "\d*$")

    if [[ $(echo "$ahead") -gt 0 ]] && [[ $(echo "$behind") -gt 0 ]]; then
      out="$out${RED}$ahead${COLOREND},${GREEN}$behind${COLOREND}"
    elif [[ $(echo "$ahead") -gt 0 ]]; then
      out="$out${GREEN}$ahead${COLOREND}"
    elif [[ $(echo "$behind") -gt 0 ]]; then
      out="$out${GREEN}$behind${COLOREND}"
    fi

    out="$out${BLUE}]${COLOREND} "
  fi

  if [[ $out != "" ]]; then
    echo "$out"
  fi
}

prompt() {
  if [[ $? -eq 0 ]]; then
    exit_status="${BLUE}▸${COLOREND} "
  else
    exit_status="${RED}▸${COLOREND} "
  fi

  PS1="$(working_directory)$(parse_git_prompt)$exit_status"
}

PROMPT_COMMAND=prompt
source $HOME/.bash_secrets

CONFIG="~/.config"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

[[ -s "/Users/jon/.gvm/scripts/gvm" ]] && source "/Users/jon/.gvm/scripts/gvm"

eval "$(tfcdev rc)"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

[[ -s "/Users/jjohnson/.gvm/scripts/gvm" ]] && source "/Users/jjohnson/.gvm/scripts/gvm"
