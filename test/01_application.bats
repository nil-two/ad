#!/usr/bin/env bats

cmd=$BATS_TEST_DIRNAME/../ad
tmpdir=$BATS_TEST_DIRNAME/../tmp
stdout=$BATS_TEST_DIRNAME/../tmp/stdout
stderr=$BATS_TEST_DIRNAME/../tmp/stderr
exitcode=$BATS_TEST_DIRNAME/../tmp/exitcode

setup() {
  mkdir -p -- "$tmpdir"
  mkdir -p -- "$tmpdir/visible-directory"
  mkdir -p -- "$tmpdir/.invisible-directory"
}

teardown() {
  rm -rf -- "$tmpdir"
}

check_with_script() {
  printf "%s\n" "" > "$stdout"
  printf "%s\n" "" > "$stderr"
  printf "%s\n" "0" > "$exitcode"
  script -qefc "$1 > $stdout" /dev/null > /dev/null 2> "$stderr" || printf "%s\n" "$?" > "$exitcode"
}

@test 'ad application: exit if q entered' {
  ls
  check_with_script "$cmd" <<< "q"
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == '' ]]
}

@test 'ad application: print working directory and exit if Ctrl+g entered' {
  cd "$tmpdir"
  check_with_script "$cmd" <<< $'\x07'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $(realpath "$tmpdir") ]]
}

@test 'ad application: toggle show hidden files if + entered' {
  cd "$tmpdir"
  check_with_script "$cmd" <<< $':nmap x <CR>\n+x\x07'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $(realpath "$tmpdir/.invisible-directory") ]]
}

@test 'ad application: chdir to the parent directory if - entered' {
  cd "$tmpdir"
  check_with_script "$cmd" <<< $'-\x07'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $(realpath "$tmpdir/..") ]]
}

@test 'ad application: chdir to the direcotry on cursor if Enter entered' {
  cd "$tmpdir"
  check_with_script "$cmd" <<< $':nmap x <CR>\nx\x07'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $(realpath "$tmpdir/visible-directory") ]]
}

# vim: ft=bash
