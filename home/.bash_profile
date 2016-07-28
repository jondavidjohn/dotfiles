export EDITOR=vim
ulimit -n 10000

GREEN="\[\e[0;32m\]"
BLUE="\[\e[0;34m\]"
RED="\[\e[0;31m\]"
BRED="\e[1;31m\]"
YELLOW="\[\e[0;33m\]"
WHITE="\e[0;37m\]"
BWHITE="\e[1;37m\]"
COLOREND="\[\e[00m\]"

alias catch='python -m smtpd -n -c DebuggingServer localhost:1025'
alias serve='open http://localhost:8000; python -m SimpleHTTPServer;'
alias tree='tree --dirsfirst -C'
alias ls='ls -G'
alias ll='ls -lh'
alias l='ll'
alias lla='ll -A'
alias la='lla'
alias vi='vim'
alias gtop='cd $(git rev-parse --show-toplevel || echo ".")'
alias ag="ag --ignore=_site --ignore=log --ignore=vendor --ignore=tmp --smart-case --literal"

..() {
  for i in $(seq ${1:-1}); do cd ..; done;
}

tgz() {
  tar -zcvf "$1.tar.gz" "$1"
}

untgz() {
  tar -zxvf $1
}

src() {
  if [ "$2" != "" ]; then
    prj_path=~/Source/`ls -1 ~/Source | grep -i -m 1 "$1"`
    vim "$prj_path/`ls -1 $prj_path | grep -i -m 1 "$2"`" -c "Git pull"
  else
    cd ~/Source
    if [ "$1" != "" ]; then
      cd `ls -1 | grep -i -m 1 "$1"`
    fi
  fi
}

# NVM
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

# more PATH adjustments
export PATH=$PATH:$HOME/bin # user bin directory
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH=$PATH:/usr/local/share/python # Python installed scripts

eval "$(rbenv init -)"

# homebrew path adjustments
export PATH="$PATH:/usr/local/share/npm/bin" Add NPM to PATH
export PATH="$PATH:/usr/local/sbin"

#BASH Completion - Homebrew
if [[ -z "$BASH_COMPLETION" ]]; then
	export BASH_COMPLETION=/usr/local/etc/bash_completion
fi

if [[ -z "$BASH_COMPLETION_DIR" ]]; then
	export BASH_COMPLETION_DIR=/usr/local/etc/bash_completion.d
fi

if [[ -z "$BASH_COMPLETION_COMPAT_DIR" ]]; then
	export BASH_COMPLETION_COMPAT_DIR=/usr/local/etc/bash_completion.d
fi

if [ -f $BASH_COMPLETION ]; then
. $BASH_COMPLETION
fi

[[ -e "$HOME/.bash_work" ]] && source "$HOME/.bash_work"

# Responsive Prompt
parse_node_version() {
  version=`nvm current | cut -f 2`
  echo "${BLUE}($version)${COLOREND} "
}

parse_git_branch() {
  if [[ -f "$BASH_COMPLETION_DIR/git-completion.bash" ]]; then
    branch=`__git_ps1 "%s"`
  else
    ref=$(git-symbolic-ref HEAD 2> /dev/null) || return
    branch="${ref#refs/heads/}"
  fi

  if [[ `tput cols` -lt 110 ]]; then
    branch=`echo $branch | sed s/feature/f/1`
    branch=`echo $branch | sed s/hotfix/h/1`
    branch=`echo $branch | sed s/release/\r/1`

    branch=`echo $branch | sed s/master/mstr/1`
    branch=`echo $branch | sed s/develop/dev/1`
  fi

  if [[ $branch != "" ]]; then
    if [[ $(git status 2> /dev/null | tail -n1) == "nothing to commit, working directory clean" ]]; then
      echo "${GREEN}$branch${COLOREND} "
    else
      echo "${RED}$branch${COLOREND} "
    fi
  fi
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

parse_remote_state() {
  remote_state=$(git status -sb 2> /dev/null | grep -oh "\[.*\]")
  if [[ "$remote_state" != "" ]]; then
    out="${BLUE}[${COLOREND}"

    if [[ "$remote_state" == *ahead* ]] && [[ "$remote_state" == *behind* ]]; then
      behind_num=$(echo "$remote_state" | grep -oh "behind \d*" | grep -oh "\d*$")
      ahead_num=$(echo "$remote_state" | grep -oh "ahead \d*" | grep -oh "\d*$")
      out="$out${RED}$behind_num${COLOREND},${GREEN}$ahead_num${COLOREND}"
    elif [[ "$remote_state" == *ahead* ]]; then
      ahead_num=$(echo "$remote_state" | grep -oh "ahead \d*" | grep -oh "\d*$")
      out="$out${GREEN}$ahead_num${COLOREND}"
    elif [[ "$remote_state" == *behind* ]]; then
      behind_num=$(echo "$remote_state" | grep -oh "behind \d*" | grep -oh "\d*$")
      out="$out${RED}$behind_num${COLOREND}"
    fi

    out="$out${BLUE}]${COLOREND}"
    echo "$out "
  fi
}

prompt() {
  if [[ $? -eq 0 ]]; then
    exit_status="${BLUE}▸${COLOREND} "
  else
    exit_status="${RED}▸${COLOREND} "
  fi

  PS1="$(working_directory)$(parse_git_branch)$(parse_remote_state)${COLOREND} $exit_status"
}

PROMPT_COMMAND=prompt
