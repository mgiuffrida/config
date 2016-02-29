# Force path elements to be unique
typeset -U path

# Don't run background jobs at a lower priority
setopt no_bg_nice

function start_time () {
  if [[ -n $start_time ]]; then
    echo "Nested scripts!"
  fi
  start_time=$(date +%s.%N)
}

function end_time () {
  end_time=$(date +%s.%N)
  elapsed_time=$(((end_time-start_time)*1000))
  unset start_time
  if [[ ! -o interactive ]]; then
    return
  fi
  echo "${1/$HOME/~}: ${elapsed_time/.*/} ms"
}
