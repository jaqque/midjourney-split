#!/bin/sh

set -e

filename="$1"
filehash="$2"

cd "$(dirname $1)"
mkdir "$filehash"

convert \
  -crop 2x2@ \
  +repage \
  +adjoin \
  "$filename" \
  "$filehash/IMG_$filehash-%d.png"

mogrify \
  -units PixelsPerInch \
  -density 300 \
  -resize 4096x4096 \
  "$filehash/"*

zip -qr $filehash.zip $filehash

echo "$PWD/$filehash.zip"
