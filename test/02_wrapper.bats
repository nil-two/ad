#!/usr/bin/env bats

cmd=$BATS_TEST_DIRNAME/../ad
tmpdir=$BATS_TEST_DIRNAME/../tmp
stdout=$BATS_TEST_DIRNAME/../tmp/stdout
stderr=$BATS_TEST_DIRNAME/../tmp/stderr
exitcode=$BATS_TEST_DIRNAME/../tmp/exitcode

setup() {
  mkdir -p -- "$tmpdir"
}

teardown() {
  rm -rf -- "$tmpdir"
}

check_wrapper_with_script() {
  printf "%s\n" "" > "$stdout"
  printf "%s\n" "" > "$stderr"
  printf "%s\n" "0" > "$exitcode"
  CMD=$cmd PATH="$PATH:$(dirname "$cmd")" script -qefc "$* > $stdout" /dev/null > /dev/null 2> "$stderr" || printf "%s\n" "$?" > "$exitcode"
}

@test 'ad wrapper: supports sh' {
  cd "$tmpdir"
  check_wrapper_with_script 'sh -c '"'"'eval "$("$CMD" -w sh)"; "$(basename "$CMD")"; pwd'"'"'' <<< $'--\x07'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $(realpath "$tmpdir/../..") ]]
}

@test 'ad wrapper: supports ksh' {
  cd "$tmpdir"
  check_wrapper_with_script 'ksh -c '"'"'eval "$("$CMD" -w ksh)"; "$(basename "$CMD")"; pwd'"'"'' <<< $'--\x07'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $(realpath "$tmpdir/../..") ]]
}

@test 'ad wrapper: supports bash' {
  cd "$tmpdir"
  check_wrapper_with_script 'bash -c '"'"'eval "$("$CMD" -w bash)"; "$(basename "$CMD")"; pwd'"'"'' <<< $'--\x07'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $(realpath "$tmpdir/../..") ]]
}

@test 'ad wrapper: supports zsh' {
  cd "$tmpdir"
  check_wrapper_with_script 'zsh -c '"'"'eval "$("$CMD" -w zsh)"; "$(basename "$CMD")"; pwd'"'"'' <<< $'--\x07'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $(realpath "$tmpdir/../..") ]]
}

@test 'ad wrapper: supports yash' {
  cd "$tmpdir"
  check_wrapper_with_script 'yash -c '"'"'eval "$("$CMD" -w yash)"; "$(basename "$CMD")"; pwd'"'"'' <<< $'--\x07'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $(realpath "$tmpdir/../..") ]]
}

@test 'ad wrapper: supports fish' {
  cd "$tmpdir"
  check_wrapper_with_script 'fish -c '"'"'source ("$CMD" -w fish | psub); eval (basename "$CMD"); pwd'"'"'' <<< $'--\x07'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $(realpath "$tmpdir/../..") ]]
}

@test 'ad wrapper: supports tcsh' {
  cd "$tmpdir"
  check_wrapper_with_script 'tcsh' <<< $'set prompt="%/:"\nad -w tcsh | source /dev/stdin\nad\n--\x07\nexit\n'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout" | tail -1 | sed 's/:.*//') == $(realpath "$tmpdir/../..") ]]
}

# vim: ft=bash
