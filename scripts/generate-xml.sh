#!/bin/bash

# Copyright © 2014 Canonical Inc
# Author Iain Lane <iain.lane@canonical.com>
# Generate <release>-wallpapers.xml file for the wallpapers
# Run in a directory containing just the jpgs for that release

shopt -s nullglob

echo """<?xml version=\"1.0\"?>
<!DOCTYPE wallpapers SYSTEM \"gnome-wp-list.dtd\">
<wallpapers>
 <wallpaper deleted=\"false\">
   <name>Ubuntu $(lsb_release -sr) Community Wallpapers</name>
   <filename>/usr/share/backgrounds/contest/$(lsb_release -cs).xml</filename>
   <options>zoom</options>
 </wallpaper>"""

for i in *.{jpg,png}; do
    FN=${i//_/ }
    TITLE=${FN% by*}
    echo """ <wallpaper>
     <_name>${TITLE}</_name>
     <filename>/usr/share/backgrounds/${i}</filename>
     <options>zoom</options>
     <pcolor>#000000</pcolor>
     <scolor>#000000</scolor>
     <shade_type>solid</shade_type>
 </wallpaper>"""
done
echo "</wallpapers>"
