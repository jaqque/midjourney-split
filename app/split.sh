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

img="$(echo "$filehash/"*0.*)"
for filter in $(mogrify -list filter); do
cp $img ${img%.png}-$filter.png
mogrify \
  -units PixelsPerInch \
  -density 300 \
  -resize 4096x4096 \
  -filter "$filter" \
  ${img%.png}-$filter.png
done


zip -qr $filehash.zip $filehash

echo "$PWD/$filehash.zip"
