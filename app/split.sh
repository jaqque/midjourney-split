#!/bin/bash

set -euo pipefail

filter='Sinc' # default filter
filehash="mktemp --dry-run XXXXXXX" # https://stackoverflow.com/a/71587919
while getopts 'd:h:f:' OPT; do
  case "$OPT" in
    d) workdir="$OPTARG" ;;
    h) filehash="$OPTARG" ;;
    f) filter="$OPTARG" ;;
  esac
done
shift "$(($OPTIND -1))"

cd "$workdir"
mkdir "$filehash"

counter=0
for filename in *; do
  [ -f $filename ] || continue

  : $(( counter++ ))
  c=$(printf '%02d' $(( counter )))

  convert \
    -crop 2x2@ \
    +repage \
    +adjoin \
    "$filename" \
    "$filehash/IMG_${c}_$filehash-%d.png"
done

mogrify \
  -units PixelsPerInch \
  -density 300 \
  -resize 4096x4096 \
  -filter "$filter" \
  "$filehash/"*

mogrify \
  -units PixelsPerInch \
  -density 300 \
  -format jpg \
  "$filehash/"* 

zip -qr $filehash.zip $filehash

echo "$PWD/$filehash.zip"
