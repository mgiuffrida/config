if [[ $ZSH_VERSION != 5.<2->* ]]; then
  zsh --version
fi

if [[ $OS = wsl ]]; then
  # WSL doesn't remember our default shell.
  SHELL=/bin/zsh
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

autoload -U select-word-style
select-word-style bash

# Set LS_COLORS before setting zsh completion colors.
if [[ $OS = wsl ]]; then
  # Default LS_COLORS, but since the blue is too dark, dirs are blue-on-gray.
  export LS_COLORS='rs=0:di=34;47:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'
fi

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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


export PATH=~/.local/bin:$PATH

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
