# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# If not running in a terminal (e.g. via .xsession), don't do anything
[ -t 0 ] || return

# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

# Append before each prompt, not just on exit
PROMPT_COMMAND='history -a'

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# Enable extended glob patterns: +(pattern), !(pattern), etc.
shopt -s extglob

# Patterns that fail to expand are removed instead of passed verbatim.
# Unset, because it prevents bash_completion from working with ls, cd, etc.
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=666933
# shopt -s nullglob

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi


if [ "$COLORTERM" = "gnome-terminal" ]
then
  export TERM=xterm-256color  # Use 256 colors
fi
if [ "$TMUX" ]
then
  export TERM=screen-256color  # Use 256 colors
fi


# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
    xterm-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
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

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

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
  . /etc/bash_completion.d/g4d
elif [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi
fi


export EDITOR="vim"
export GIT_EDITOR="vim"

export CHROME_DEVEL_SANDBOX=/usr/local/sbin/chrome-devel-sandbox

umask 022
export BOARD=link

# History lines for bash to ignore, including duplicates (&)
export HISTIGNORE="&:ls:exit"


export SRC_DIR=~/dev/c/src

export DEPOT_TOOLS=~/tools/depot_tools
export GOMA_DIR=~/goma
export CLANG_DIR=#/~/dev/c/src/third_party/llvm-build/Release+Asserts/bin
export GSUTIL_DIR=#~/dev/gsutil
export NODE_DIR=/usr/local/bin/node/bin
export PATH=$DEPOT_TOOLS:$GOMA_DIR:$CLANG_DIR:$GSUTIL_DIR:$NODE_DIR:$PATH
export PATH=$PATH:~/bin

source ~/config/git-completion.bash

# Exports for running chrome
export SW="--ui-disable-threaded-compositing --disable-gpu"
export LOGIN=" --login-manager --login-profile=user"
export GUEST=' --incognito --bwsi --login-profile=user --login-user=$guest'
export DATA=" --user-data-dir=/tmp/chrome-"
export TEST="xvfb-run -s \"-screen 0 1024x768x24\""

export HISTTIMEFORMAT="[%s] [%Y-%m-%d %H:%M:%S] "

export PATH=~/bin/google_appengine:$PATH
export THIS_ENV="google"
export LESS=-RFX
export GOPATH=$HOME/gocode
export PATH=$GOPATH:$GOPATH/bin:$PATH

stty -ixon # disable C-S freezing


git-list-branches-by-date() {
  local current_branch=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)
  local normal_text=$(echo -ne '\E[0m')
  local yellow_text=$(echo -ne '\E[0;33m')
  local yellow_bg=$(echo -ne '\E[7;33m')
  git for-each-ref --sort=-committerdate \
      --format=$'  %(refname:short)  \
          \t%(committerdate:short)\t%(authorname)\t%(objectname:short)' \
          refs/heads \
      | column -t -s $'\t' -n \
      | sed -E "s:^  (${current_branch}) :* ${yellow_bg}\1${normal_text} :" \
      | sed -E "s:^  ([^ ]+):  ${yellow_text}\1${normal_text}:"
}

eval $(thefuck --alias fuck)

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export NVM_DIR="/usr/local/google/home/michaelpg/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
# Load nvm, but don't automatically load the default NPM unless not yet loaded.
which npm > /dev/null
if [ $? -ne 0 ]; then
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
else
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use
  # Manually set the "used" NPM to save time.
  export NPM_PACKAGES="$HOME/.nvm/versions/node/v5.5.0"
fi
[[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion

export PATH="$NPM_PACKAGES/bin:$PATH"
