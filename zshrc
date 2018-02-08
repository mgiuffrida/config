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

# Append to history immediately. Don't share history; import manually with fc -RI.
setopt inc_append_history

# Behavior
setopt no_beep

setopt correct

setopt interactivecomments

# Allow path expansion and tab completion for file names after =
setopt magic_equal_subst

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

# fzf uses Ctrl-T by default, which is my tmux prefix key. Change it with:
# bindkey '^T' fzf-file-widget

# Remove /=-. from WORDCHARS so they're considered word breaks
# Add \ and ' so they're considered word characters
WORDCHARS=${WORDCHARS//[\/\'=.-]}\'\\

# Allow extra file generation pattern matching characters. Remember to quote
# things like |grep '^ls'| to prevent filename expansion.
setopt extended_glob

# Leave file expansions with no matches unchanged.
setopt no_nomatch

# > won't clobber, and >> won't create. Override with >| or >!, >>| or >>!.
setopt no_clobber

# But rewrite history to always clobber.
setopt hist_allow_clobber

# Add functions and completions to fpath
# note: git completions came from
# https://github.com/git/git/blob/master/contrib/completion/git-completion.*
fpath=($HOME/.zsh_fns $HOME/.zsh_comp $fpath)
autoload fn

# Do not include "do-what-i-mean" suggestions in git checkout, e.g. completing
# "foo" for "origin/foo".
#export GIT_COMPLETION_CHECKOUT_NO_GUESS=1


# Prompt. Hint: test with print -P '%whatever'.
setopt prompt_subst
autoload -U colors && colors
source ~/.zsh_sources/git-prompt.sh

# Truncate PWD if > 3 directories and more than MAX_PWD_PERCENT% of the terminal
MAX_PWD_PERCENT=50

# http://stackoverflow.com/questions/26554713/how-to-truncate-working-directory-in-prompt-to-show-first-and-last-folder/26555347#26555347
PS1='%{${fg[white]}%}$(pwd | awk -F/ -v "n=$(tput cols)" -v "h=^$HOME" '\''{sub(h,"~");n=0.'$MAX_PWD_PERCENT'*n;b=$1"/"$2} length($0)<=n || NF==3 {print;next;} NF>3{b=b"/../"; e=$NF; n-=length(b $NF); for (i=NF-1;i>3 && n>length(e)+1;i--) e=$i"/"e;} {print b e;}'\'')'\
' %B%{${fg[yellow]}%}%#%b '\
'%{$reset_color%}'

export PS1=$'%F{green}%B%32>$>'$'$(__git_ps1 "%s")'$'%>>%b%f '"$PS1"


if [[ -r ~/.zsh_aliases ]]; then
  . ~/.zsh_aliases
fi

# also makes tmux use vim bindings in copy mode
export EDITOR=vim
export GIT_EDITOR=vim

export GOPATH=$HOME/gocode
export PATH=$PATH:$GOPATH/bin

# Slow.
# eval $(thefuck --alias)
# Fast.
TF_ALIAS=fuck alias fuck='PYTHONIOENCODING=utf-8 eval $(thefuck $(fc -ln -1 | tail -n 1)); fc -R'

# Exports for building chrome
export DEPOT_TOOLS=~/tools/depot_tools
export GOMA_DIR=~/tools/goma
export NODE_DIR=/usr/local/bin/node/bin
export APP_ENGINE=~/tools/google_appengine

# Exports for running chrome
export CHROME_DEVEL_SANDBOX=/usr/local/sbin/chrome-devel-sandbox
export SW="--ui-disable-threaded-compositing --disable-gpu"
export LOGIN=" --login-manager --login-profile=user"
export GUEST=' --incognito --bwsi --login-profile=user --login-user=$guest'
export DATA=" --user-data-dir=/tmp/chrome-"
export TEST="./testing/xvfb.py"
export TESTOUT=" --test-launcher-print-test-stdio=always"
export TESTF=" --gtest_filter"
export TESTJ=" --test-launcher-jobs"

function gtest() {
  binary=$1
  filter=
  if [[ $# -gt 1 ]]; then
    filter="--gtest_filter=$2"
  fi

  $TEST "$binary" "$filter"
}

export PATH=~/bin:$PATH
export PATH=~/.local/bin:$PATH

# Alloc more colors where possible.
if [ "$COLORTERM" = "gnome-terminal" ]; then
  if [ "$TMUX" ]; then
    # In TMUX, $TERM must start with "screen".
    export TERM=screen-256color
  else
    export TERM=xterm-256color
  fi
fi

autoload git-list-branches-by-date

export NVM_DIR="/usr/local/google/home/michaelpg/.nvm"
if [ -d $NVM_DIR ]; then
  #[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
  # Load nvm, but don't automatically load the default NPM unless not yet loaded.
  if ! `which nvm > /dev/null`; then
    # Lazy load nvm.
    local nvm_loaded=0
    load_nvm() {
      if [[ $nvm_loaded -eq 0 ]]; then
        nvm_loaded=1
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
      fi
    }
    nvm() { load_nvm; $0 $@ }
    node() { load_nvm; unfunction $0; $0 $@ }
    npm() { load_nvm; unfunction $0; $0 $@ }
  else
    echo "no-use"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use
    # Manually set the "used" NPM to save time.
    export NPM_PACKAGES="$HOME/.nvm/versions/node/v5.5.0"
  fi
  #[[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion

  export PATH="$NPM_PACKAGES/bin:$PATH"
fi

if [[ -f /etc/bash_completion.d/g4d ]]; then
  # Supports zsh too.
  source /etc/bash_completion.d/g4d
fi

function ssh-personal() {
  export SSH_AUTH_SOCK=~/.ssh/ssh-agent.sock
  ssh-add -l >& /dev/null
  if [[ $? -eq 2 ]]; then
    ssh-agent -a "$SSH_AUTH_SOCK"
  fi
}

# Add Chromium deps, especially depot_tools, at the end.
export PATH=$DEPOT_TOOLS:$GOMA_DIR:$NODE_DIR:$APP_ENGINE:$PATH

#end_time ${(%):-%x}

# pip zsh completion start
function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 $words[1] ) )
}
compctl -K _pip_completion pip

# pip zsh completion end

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#export FZF_COMPLETION_TRIGGER='~~'
export FZF_DEFAULT_COMMAND='git rev-parse --is--work-tree 2>&1 >/dev/null && git ls-files || find * -type f'
#export FZF_DEFAULT_COMMAND='
#  (git ls-tree -r --name-only HEAD ||
#   find . -path "*/\.*" -prune -o -type f -print -o -type l -print |
#      sed s/^..//) 2> /dev/null'
