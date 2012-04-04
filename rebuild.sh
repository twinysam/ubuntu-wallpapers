#!/bin/sh

# OLD SCRIPT, NOT BEING USED FOR 12.04
return

# '../orig' populated with the contents of:
# wget https://bugs.launchpad.net/ubuntu/+source/ubuntu-wallpapers/+bug/741253/+attachment/1934355/+files/new_wallpaper_final_full_size03.jpg
# wget https://bugs.launchpad.net/ubuntu/+source/ubuntu-wallpapers/+bug/829213/+attachment/2337805/+files/ubuntu-wallpapers-11.10-oneiric-originals.zip

rm *.jpg
#cp -a ../2011-09-29-shorter-list/*.jpg .

BUDGET=200k

# default - leaved compressed as-is.
#jpegoptim -o -t new_wallpaper_final_full_size03.jpg
#mv new_wallpaper_final_full_size03.jpg warty-final-ubuntu.png

find ../shortlist/ -type f -size +$BUDGET | xargs cp -avt .
# Rescale the rest of the photographics to be not more than 1928px width
#mv 'Lá_no_alto_by_Allyson_Souza.jpg' La_no_alto_by_Allyson_Souza.jpg
mogrify -resize '1928x1928>' -quality 66 *.jpg

mogrify -crop '1920x1280+0+0' -gravity Center *.jpg

#convert -quality 50 -resize '2000x2000>' ../2011-09-29-shorter-list/$SAND $SAND

# take more care with the illustrations and don't resize them either
# hmmm, Gnome Appearances doesn't seem to show images that are 2560pixels wide...
#for illustration in Aubergine_Sea_by_Wyatt_Kirby Tri_Narwhal_by_momez ; do
#  convert -quality 95 -resize '2000x2000>' ../orig/$illustration.png $illustration.jpg
#  echo illustration: $illustration
#  jpegoptim -o -t $illustration.jpg
#done

# Copy anything that was underbudget as-is:
find ../shortlist/ -type f -size -$BUDGET | xargs cp -avt .

#jpegoptim -o -t *.jpg *.png

# And the Bad news ... 3440 kB to equal or beat
du -sc *.jpg *.png

# AUTHORS
#(head -n3 AUTHORS ; ls -1 *.jpg | tr '_-' '  ' | sed -e 's/\.jpg//') > AUTHORS.new && mv AUTHORS.new AUTHORS

#./update-background.py > contest/background-1.xml
