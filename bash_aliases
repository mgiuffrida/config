# Aliases
alias reload="source ~/.bash_aliases"

alias lsl="ls -l"
alias lsa="ls -la"
alias g="git"
alias cdd="cd .."
alias cd2="..;.."
alias cd3="..2 ; .."
alias cd4="..3;.."
alias cd5="..4;.."
alias cd6="..5;.."


# emacs: e to open emacs with my settings, emacs to open normal emacs
alias e="/usr/local/bin/emacs"
alias se="sudo /usr/local/bin/emacs -u michaelpg"
alias emacs="/usr/local/bin/emacs --no-init-file --load=~/.emacs-normal"
# alias et="emacsclient -t"
# alias e1="emacsclient -c -s s1"
# alias e2="emacsclient -c -s s2"
# alias e3="emacsclient -c -s s3"
# alias e4="emacsclient -c -s s4"
# alias e5="emacsclient -c -s s5"

## Directories
alias c="pushd ~/dev/c/src"
alias t="pushd /media/ssd2/c_new/"

alias XVFB="xvfb-run -s '-screen 0 1024x768x24'"

# Ninja
alias n="ninja -C out/Debug -j 9999 -l 40"
alias nout="ninja -j 9999 -l 40 -C "

alias ack=ack-grep

alias trash="trash -v"
alias rm="echo 'Use trash instead.'"
alias cp="cp -i"
alias mv="mv -i"

alias closure_compile="GYP_GENERATORS=ninja tools/gyp/gyp --depth . third_party/closure_compiler/compiled_resources.gyp && ninja -C out/Default"

alias generate_externs="python tools/json_schema_compiler/compiler.py --root=. --generator=externs"

alias last5="git for-each-ref --sort=committerdate refs/heads/  --format='%(committerdate:short) %(refname:short)' | tail -5 | cut -c 12-"

alias closure_test="java -jar ~/tot/src/third_party/closure_compiler/compiler/compiler.jar --compilation_level=SIMPLE_OPTIMIZATIONS --jscomp_error=accessControls --jscomp_error=ambiguousFunctionDecl --jscomp_error=checkTypes --jscomp_error=checkVars --jscomp_error=constantProperty --jscomp_error=globalThis --jscomp_error=invalidCasts --jscomp_error=missingProperties --jscomp_error=missingReturn --jscomp_error=undefinedNames --jscomp_error=undefinedVars --jscomp_error=visibility --language_in=ECMASCRIPT6_STRICT --language_out=ECMASCRIPT5_STRICT test.js"

alias ninjar="ninja -C out_cros/Release -j 9999 -l 40 chrome browser_tests"
alias ninjarc="ninja -C out_cros/Release -j 9999 -l 40 chrome"
alias ninjad="ninja -C out_cros/Debug -j 9999 -l 40 chrome browser_tests"
alias ninjadc="ninja -C out_cros/Debug -j 9999 -l 40 chrome"
alias ninjarl="ninja -C out_linux/Release -j 9999 -l 40 chrome browser_tests"
alias ninjarlc="ninja -C out_linux/Release -j 9999 -l 40 chrome"
alias ninjadll="ninja -C out_linux/Debug -j 9999 -l 40 chrome browser_tests"
alias ninjadlc="ninja -C out_linux/Debug -j 9999 -l 40 chrome"

alias getbranch="git status | head -n 1 | grep -Po '([[:alpha:]]|[[:digit:]])*$'"

alias serve-quietly="http-server -d false -i false -c-1 -s --cors"
