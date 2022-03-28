#!/bin/sh

ln -sf "$(find ~/.wallpapers -type f | sort -n | xargs -r0 | dmenu -l 15 -p set)" ~/.wallpapers/ded.jpg && feh --bg-fill --no-fehbg ~/.wallpapers/ded.jpg 

notify-send "you changed wallpaper again?" --icon ~/Downloads/pictures/tbhk/t10.jpg

