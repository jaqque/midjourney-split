#!/bin/sh

set -e

[ -d /out ] || {
  echo 'Did you forget to mount the /out volume?'
  exit 1
}

filename="$(basename $1)"

wget \
  --quiet \
  --output-document="$filename" \
  "$1"
file="$(cksum -a crc < "$filename" | tr ' ' _)"
mkdir "$file"

convert \
  -crop 2x2@ \
  +repage \
  +adjoin \
  "$filename" \
  "$file/IMG_$file-%d.png"
mogrify \
  -units PixelsPerInch \
  -density 300 \
  -resize 4096x4096 \
  "$file/"*

zip -qr /out/$file.zip $file

echo "$file.zip"
