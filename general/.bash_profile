export EDITOR=vim

alias runsmtp='python -m smtpd -n -c DebuggingServer localhost:1025'
alias runhttp='python -m SimpleHTTPServer'
alias ..='cd ..'
alias tree='tree --dirsfirst -C'
alias tr='tree -L 1'
alias tr2='tree -L 2'
alias tr3='tree -L 3'
alias ls='ls -G'
alias ll='ls -lh'
alias l='ll'
alias lla='ll -A'
alias la='lla'
alias vi='vim'

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# more PATH adjustments
export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
export PATH=$PATH:/usr/local/share/python # Python installed scripts

# load in moar configs
[[ -e "$HOME/.bash_os" ]] && source "$HOME/.bash_os"
[[ -e "$HOME/.bash_work" ]] && source "$HOME/.bash_work"

# Responsive Prompt
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
		echo "$branch "
	fi
}

working_directory() {
	dir=`pwd`
	in_home=0
	if [[ `pwd` =~ ^"$HOME"(/|$) ]]; then
		dir="~${dir#$HOME}"
		in_home=1
	fi

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
			echo $dir
		elif [[ $proj == "~" ]]; then
			echo $dir
		elif [[ $dir =~ "$first/$proj"$ ]]; then
			echo $beginning
		elif [[ $dir =~ "$first/$proj/$end"$ ]]; then
			echo "$beginning/$end"
		else
			echo "$beginning/…/$end"
		fi
	else
		echo $dir
	fi
}

prompt() {
	if [[ $? -eq 0 ]]; then
		exit_status='\[\e[0;34m\]› \[\e[00m\]'
	else
		exit_status='\[\e[0;31m\]› \[\e[00m\]'
	fi

	prompt='\[\e[0;33m\]$(working_directory)\[\e[00m\]'
	if [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]]; then
		prompt="$prompt\[\e[0;31m\] $(parse_git_branch)\[\e[00m\]"
	else
		prompt="$prompt\[\e[0;32m\] $(parse_git_branch)\[\e[00m\]"
	fi
	PS1=$prompt$exit_status
}

PROMPT_COMMAND=prompt


test -f ~/.bashrc && source ~/.bashrc # Crowd Favorite
