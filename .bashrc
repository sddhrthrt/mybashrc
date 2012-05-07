#see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
#for examples

#If not running interactively, don't do anything
[ -z "$PS1" ] && return

#don't put duplicate lines in the history. See bash(1) for more options
#... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

#append to the history file, don't overwrite it
shopt -s histappend

#for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=200000

#check the window size after each command and, if necessary,
#update the values of LINES and COLUMNS.
shopt -s checkwinsize

#make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

#set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

#set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

#uncomment for a colored prompt, if the terminal has the capability; turned
#off by default to not distract the user: the focus in a terminal window
#should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

#If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

#enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
#alias dir='dir --color=auto'
#alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

#some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

#Alias definitions.
#You may want to put all your additions into a separate file like
#~/.bash_aliases, instead of adding them here directly.
#See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

#enable programmable completion features (you don't need to enable
#this, if it's already enabled in /etc/bash.bashrc and /etc/profile
#sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
#################################################################
#################################################################
#Make the terminal prompt my own :P
PS1='\[\033[01;32m\]\W> \[\033[00m\]'
shopt -o -s vi
#################################################################
#Some shortucts 
alias gcv='gcc -ggdb `pkg-config --cflags opencv`  `pkg-config --libs opencv`'
alias rmmake='rm CMakeCache.txt CMakeFiles/ cmake_install.cmake Makefile -rf'
alias closeafter='sudo shutdown -hP'
alias stopafter='sudo pm-suspend'
source .welcomenote
#################################################################
#to open the last edited progrram in either gvim or vi
function vic {
HEADFILE=`ls -t1 | grep [.]c| head -n 1` 
vi  $HEADFILE
}
function gvic {
HEADFILE=`ls -t1 | grep [.]c |head -n 1` 
gvim  $HEADFILE
}
function gccc {
HEADFILE=`ls -t1 | grep [.]c |head -n 1` 
gcc -Wall -g $HEADFILE -o `basename $HEADFILE .c`
}
function runc {
HEADFILE=`ls -t1 | grep [.]c |head -n 1` 
./`basename $HEADFILE .c`
}
function gdbc {
HEADFILE=`ls -t1 | grep [.]c |head -n 1` 
gdb `basename $HEADFILE .c`
}
alias vibrator='while who &>/dev/null ; do printf "\a" ; done'
if [ `ps aux |grep -v 'grep '| grep SCREEN | wc -l ` -gt 0 ]
then
 if [ `ps aux |grep -v 'grep '| grep 'screen -c' | wc -l ` -gt 0 ]
 then
  who >& /dev/null
 else
  byobu
 fi
else
 byobu
fi
alias editbashrc='vi ~/.bashrc'
alias ggl='g++ -lglut -lGL -lGLU -lGLEW '
alias updatebashrc='source ~/.bashrc'

#script to turn off monitor or turn on monitor
function offmonitor {
	xset +dpms
	status=`xset -q | grep "Monitor is"`
	status=`echo $status | sed 's/.*[^\w] //'`
	if [ $status = "On" ]
	then
		echo turning off...
		xset dpms force off
	else
		echo already off...
	fi
}
###DEPRECATED
#function backup_madi {
#	today=`date +%d%b`
#	sudo tar cvpzf /disk/backup/backup_$today.tgz --exclude=/proc --exclude=/lost+found --exclude=/disk --exclude=/mnt --exclude=/sys --exclude=/home/siddhartha/.axel/* --exclude=/home/siddhartha/{Documents,Downloads,Music,Videos,Pictures} --exclude=/home/siddhartha/.Virtualbox/* /
#    	echo Backup done on $today. >> /disk/backup/log.log
#}
function storemycodes {
	today=`date +%d%b`
	sudo tar cvpzf /disk/backup/codes_$today.tgz /home/siddhartha/Documents/programs/
	echo Code backup done on $today. >> /disk/backup/log.log
}
function note {
	current=`pwd`
	cd /home/sddhrthrt/Documents/notes/
		notestack=$1
		shift
		if [ "$1" == '+' ]
		then
			append=1
			shift
		else
			append=0
		fi
	takenote=$*
		if [ ! -e "$notestack" ]
		then 
		append=0
		fi
		if [ $append -eq 0 ]
		then
		echo       '----------------------'  >>"$notestack"
		echo `date '+%T, %a %d/%m/%y'` >> "$notestack"
		echo       '----------------------'  >>"$notestack"
		fi
		echo $takenote >>"$notestack"
		echo note added to $notestack
	cd "$current"
}
function shownote {
	notestack="/home/sddhrthrt/Documents/notes/$1"
	cat "$notestack"
}
function rmnote {
	notestack="/home/sddhrthrt/Documents/notes/$1"
	rm  "$notestack"
}
function lsnote {
	notestack="/home/sddhrthrt/Documents/notes/"
	ls "$notestack"
}
function chdir {
	fname=$1
	mkdir -p $fname
	cd $fname
	}


#for procmail
MAIL=/home/siddhartha/mail/inbox && export MAIL
bash ~/.2fingerscroll
if [ `ps aux | grep fetchmail | wc -l` -lt 2 ] 
then fetchmail -d 300
fi
		
#for TASKMAN
TM_PATH=/home/sddhrthrt/.taskman
alias gnome-terminal='gnome-terminal --maximize'
