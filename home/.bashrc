# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export EMAIL=stuart.freeman@et.gatech.edu

# vi keybindings
set -o vi

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoreboth

export NNTPSERVER=news.gmane.org

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set xterm-256color for vte based terminals
if pgrep -aP $(ps -h -o ppid -p $$ 2>/dev/null) 2>/dev/null |grep -q gnome-pty-helper; then
  export TERM=xterm-256color
fi

# enable color support of ls
if [ "$TERM" != "dumb" ]; then
  eval "`dircolors -b`"
  alias ls='ls --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# Prevent dropping a locked X to a term with my privs
alias startx="exec startx"

# Set up vim if we have it
if which nvim &>/dev/null
then
  export EDITOR=nvim
  alias vi="nvim"
  alias vim="nvim"
elif which vim 2>&1 > /dev/null
then
  export EDITOR=vim
  alias vi="vim -X"
else
  export EDITOR=vi
fi
export VISUAL=$EDITOR

# Timezone
export TZ='America/New_York'

# History
export HISTFILESIZE=3000
export HISTSIZE=3000

# Java stuff
export JAVA_HOME=$(dirname $(dirname $(readlink -f /etc/alternatives/javac)))
export JAVA_OPTS='-Xms256m -Xmx1024m -XX:PermSize=64m -XX:MaxPermSize=512m'
export M2_HOME='/usr/share/maven'
export MAVEN_OPTS='-Xms512m -Xmx2048m -XX:PermSize=128m -XX:MaxPermSize=512m'
export CATALINA_HOME='/opt/tomcat'
export CATALINA_LOGDIR=$CATALINA_HOME/logs
alias rtc="/opt/tomcat/bin/shutdown.sh && sleep 2 && /opt/tomcat/bin/startup.sh && tail -f /opt/tomcat/logs/catalina.out"
alias java="java $JAVA_OPTS"
alias jdb="java -agentlib:jdwp=transport=dt_socket,address=8000,server=y,suspend=n"

export PATH=~/bin:~/.yarn/bin:$PATH:/usr/bin:$MAVEN_HOME/bin:$CATALINA_HOME/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/jni/
export SDC_KEY_ID=7d:2f:e4:0e:55:bd:6b:67:ce:1c:16:11:7a:5b:57:af
export DEBFULLNAME="D. Stuart Freeman"
export DEBEMAIL="stuart.freeman@c21u.gatech.edu"

# Set up make to utilize all processors
if [[ `uname` == 'Linux' ]]
then
  PROCESSORS=`grep processor /proc/cpuinfo|wc -l`
  if [[ PROCESSORS != 1 ]]
  then
    let PROCESSORS=$PROCESSORS+1
    export MAKEFLAGS="-j $PROCESSORS"
  fi
fi

# make-kpkg stuff
export CONCURRENCY_LEVEL=$PROCESSORS
alias make-kpkg="MAKEFLAGS=\"\" make-kpkg --rootcmd fakeroot"

alias dquilt="quilt --quiltrc=${HOME}/.quiltrc-dpkg"

source "$HOME/.homesick/repos/homeshick/homeshick.sh"
source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"

export GPG_TTY=`tty`

alias adl=$(aws ecr get-login --no-include-email --region us-east-1)

export NODE_ENV=development
[[ -s "$HOME/src/nvm/nvm.sh" ]] && source ~/src/nvm/nvm.sh

[[ -s "$HOME/.bash_prompt" ]] && source "$HOME/.bash_prompt" # load bash prompt

# Setup pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1
then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
