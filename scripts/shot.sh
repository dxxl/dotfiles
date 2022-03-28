#!/bin/sh

T=$(printf "SHOT\nSNIP" | dmenu -p CAPTURE:)

case $T in
	SHOT)
		scrot -d 0.20 ~/screenshots/shots/%y-%m-%d-%T.png
		notify-send "SHOT TAKEN" --icon ~/Downloads/pictures/tbhk/t6.jpg
		;;
	SNIP)
		scrot --select -d 0.30 ~/screenshots/snips/SNIP-%m-%d-%Y-%T.png
		notify-send "SNIPPED (wtf.)" --icon ~/Downloads/pictures/tbhk/t7.jpg
		;;
esac
