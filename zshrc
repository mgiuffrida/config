if [[ $ZSH_VERSION != 5.<2->* ]]; then
  zsh --version
fi

# History
HISTFILE=~/.zsh_history
HISTSIZE=2000
SAVEHIST=2000
setopt append_history

# Don't store any dupes in HISTFILE, and remove blanks
setopt hist_ignore_all_dups hist_reduce_blanks

# Append to history immediately, and chechk for new history (doesn't affect !!)
setopt inc_append_history share_history

# Behavior
setopt no_beep

setopt nomatch
setopt correct

# Completion
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' format 'Completing %d:'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle :compinstall filename '/usr/local/google/home/michaelpg/.zshrc'

autoload -Uz compinit
compinit

bindkey -e

# # Vi bindings:
# # Decrease <ESC> timeout.
# bindkey -v
# export KEYTIMEOUT=1

# Simpler: Remove / from WORDCHARS, add \
WORDCHARS=${WORDCHARS%/%}\\

# Allow extra file generation pattern matching characters. Remember to quote
# things like |grep '^ls'| to prevent filename expansion.
setopt extended_glob

# > won't clobber, and >> won't create. Override with >| or >!, >>| or >>!.
setopt no_clobber
# But rewrite history to always clobber.
setopt hist_allow_clobber

# Add functions to fpath
fpath=($HOME/.zsh_fns $fpath)
autoload fn

# Prompt. Hint: test with print -P '%whatever'.
setopt prompt_subst
autoload -U colors && colors
# Truncate PWD if > 3 directories and more than MAX_PWD_PERCENT% of the terminal
MAX_PWD_PERCENT=50
# http://stackoverflow.com/questions/26554713/how-to-truncate-working-directory-in-prompt-to-show-first-and-last-folder/26555347#26555347
PS1='%{${fg[white]}%}$(pwd | awk -F/ -v "n=$(tput cols)" -v "h=^$HOME" '\''{sub(h,"~");n=0.'$MAX_PWD_PERCENT'*n;b=$1"/"$2} length($0)<=n || NF==3 {print;next;} NF>3{b=b"/../"; e=$NF; n-=length(b $NF); for (i=NF-1;i>3 && n>length(e)+1;i--) e=$i"/"e;} {print b e;}'\'')'\
' %B%{${fg[yellow]}%}%#%b '\
'%{$reset_color%}'

if [[ -r ~/.zsh_aliases ]]; then
  . ~/.zsh_aliases
fi

# also makes tmux use vim bindings in copy mode
export EDITOR=vim
export GIT_EDITOR=vim

# Slow.
# eval $(thefuck --alias)
# Fast.
TF_ALIAS=fuck alias fuck='PYTHONIOENCODING=utf-8 eval $(thefuck $(fc -ln -1 | tail -n 1)); fc -R'

# Exports for building chrome
export DEPOT_TOOLS=~/tools/depot_tools
export GOMA_DIR=~/tools/goma
export NODE_DIR=/usr/local/bin/node/bin
export PATH=$DEPOT_TOOLS:$GOMA_DIR:$NODE_DIR:$PATH

# Exports for running chrome
export SW="--ui-disable-threaded-compositing --disable-gpu"
export LOGIN=" --login-manager --login-profile=user"
export GUEST=' --incognito --bwsi --login-profile=user --login-user=$guest'
export DATA=" --user-data-dir=/tmp/chrome-"
export TEST="xvfb-run -s \"-screen 0 1024x768x24\""

export PATH=~/bin:$PATH

autoload git-list-branches-by-date

#end_time ${(%):-%x}