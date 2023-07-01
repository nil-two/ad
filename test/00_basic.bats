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

check() {
  printf "%s\n" "" > "$stdout"
  printf "%s\n" "" > "$stderr"
  printf "%s\n" "0" > "$exitcode"
  "$@" > "$stdout" 2> "$stderr" || printf "%s\n" "$?" > "$exitcode"
}

@test 'ad: start application if no arguments passed' {
  check script -qefc "$cmd" /dev/null <<< "q" > /dev/null
  [[ $(cat "$exitcode") == 0 ]]
}

@test 'ad: start application if double-dash passed' {
  check script -qefc "$cmd --" /dev/null <<< "q" > /dev/null
  [[ $(cat "$exitcode") == 0 ]]
}

@test 'ad: print error if unknown option passed' {
  check "$cmd" --vim
  [[ $(cat "$exitcode") == 1 ]]
  [[ $(cat "$stderr") != "" ]]
}

@test 'ad: print wrapper script if -w sh passed' {
  check "$cmd" -w sh
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") =~ ^'ad() {' ]]
}

@test 'ad: print wrapper script if -wsh passed' {
  check "$cmd" -wsh
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") =~ ^'ad() {' ]]
}

@test 'ad: print wrapper script if --wrapper sh passed' {
  check "$cmd" --wrapper sh
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") =~ ^'ad() {' ]]
}

@test 'ad: print wrapper script if --wrapper=sh passed' {
  check "$cmd" --wrapper=sh
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") =~ ^'ad() {' ]]
}

@test 'ad: print error and exit if --wrapper unsupported-shell passed' {
  check "$cmd" --wrapper vim
  [[ $(cat "$exitcode") == 1 ]]
  [[ $(cat "$stderr") =~ ^'ad: unsupported shell' ]]
}

@test 'ad: print usage if --help passed' {
  check "$cmd" --help
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") =~ ^'usage:' ]]
}

# vim: ft=bash
