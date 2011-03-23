#!/bin/sh

# '../orig' populated with the contents of:
# wget https://bugs.launchpad.net/ubuntu/+source/ubuntu-wallpapers/+bug/741253/+attachment/1934355/+files/new_wallpaper_final_full_size03.jpg
# wget https://bugs.launchpad.net/ubuntu/+source/ubuntu-wallpapers/+bug/740588/+attachment/1933949/+files/Natty%20wallpapers.zip

rm *.jpg *.png
cp -a ../orig/*.jpg .

# default - leaved compressed as-is.
jpegoptim -o -t new_wallpaper_final_full_size03.jpg
mv new_wallpaper_final_full_size03.jpg warty-final-ubuntu.png

# Rescale the rest of the photographics to be not more than 2000px width
mv 'Lá_no_alto_by_Allyson_Souza.jpg' La_no_alto_by_Allyson_Souza.jpg
mogrify -resize '2000x2000>' -quality 66 *.jpg

# take more care with the illustrations and don't resize them either
# hmmm, Gnome Appearances doesn't seem to show images that are 2560pixels wide...
for illustration in Aubergine_Sea_by_Wyatt_Kirby Tri_Narwhal_by_momez ; do
  convert -quality 95 -resize '2000x2000>' ../orig/$illustration.png $illustration.jpg
  echo illustration: $illustration
  jpegoptim -o -t $illustration.jpg
done

# And the Bad news ... 3440 kB to equal or beat
du -sc *.jpg *.png
echo  ...did we beat 3440?

# AUTHORS
(head -n3 AUTHORS ; ls -1 *.jpg | tr '_-' '  ' | sed -e 's/\.jpg//') > AUTHORS.new && mv AUTHORS.new AUTHORS

