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

check_with_script() {
  printf "%s\n" "" > "$stdout"
  printf "%s\n" "" > "$stderr"
  printf "%s\n" "0" > "$exitcode"
  script -qefc "$* > $stdout" /dev/null > /dev/null 2> "$stderr" || printf "%s\n" "$?" > "$exitcode"
}

@test 'ad wrapper: supports bash' {
  cd "$tmpdir"
  CMD=$cmd PATH="$PATH:$(dirname "$cmd")" check_with_script 'bash -c '"'"'eval "$("$CMD" -w bash)"; "$(basename "$CMD")"; pwd'"'"'' <<< $'--\x07'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $(realpath "$tmpdir/../..") ]]
}

# vim: ft=bash
