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

@test 'ad application: exit if q entered' {
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
  mkdir -p -- "$tmpdir/visible-directory" "$tmpdir/.invisible-directory"
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
  mkdir -p -- "$tmpdir/visible-directory"
  check_with_script "$cmd" <<< $':nmap x <CR>\nx\x07'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $(realpath "$tmpdir/visible-directory") ]]
}

@test 'ad application: do nothing if - entered when in root directory' {
  cd "/usr/bin"
  check_with_script "$cmd" <<< $':nmap x <CR>\n:cmap y <CR>\n---/^bin/$yx\x07'
  cat "$stdout"
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == '/bin' ]]
}

@test 'ad application: show hidden files from the start if AD_SHOW_HIDDEN_FILES set to true' {
  cd "$tmpdir"
  mkdir -p -- "$tmpdir/visible-directory" "$tmpdir/.invisible-directory"
  AD_SHOW_HIDDEN_FILES=true check_with_script "$cmd" <<< $':nmap x <CR>\nx\x07'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $(realpath "$tmpdir/.invisible-directory") ]]
}

@test 'ad application: hide hidden files from the start if AD_SHOW_HIDDEN_FILES set to false' {
  cd "$tmpdir"
  mkdir -p -- "$tmpdir/visible-directory" "$tmpdir/.invisible-directory"
  AD_SHOW_HIDDEN_FILES=false check_with_script "$cmd" <<< $':nmap x <CR>\nx\x07'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $(realpath "$tmpdir/visible-directory") ]]
}

# vim: ft=bash
