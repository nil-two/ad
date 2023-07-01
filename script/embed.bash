#!/bin/bash
set -eu

cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."

target_file='./ad'
source_file='src/ad.vim'
embed_marker_start='" appscript:start'
embed_marker_end='" appscript:end'
sed -i \
  -e '/^'"$embed_marker_start"'$/r '"$source_file"'' \
  -e '/^'"$embed_marker_start"'$/i'"$embed_marker_start"'' \
  -e '/^'"$embed_marker_end"'$/i'"$embed_marker_end"'' \
  -e '/^'"$embed_marker_start"'$/,/^'"$embed_marker_end"'$/d' \
  "$target_file"
