#!/bin/sh

_umount(){
	exclregex="\(/boot\|/home\|/\|/boot/efi\)$"
	drives=$(lsblk -lp | grep "t /" | grep -v "$exclregex" | awk '{print $1, "(" $4 ")", "on", $7}')
	chosen=$(echo "$drives" | dmenu -p "Unmount which?" | awk '{print $1}')

	if [ "$drives" = "" ] || [ "$chosen" = "" ]; then
		exit 1
	else
		if ! sudo umount $chosen; then
			notify-send "$chosen unmount failed, check if any programs are using the drive."
		else
			notify-send "$chosen unmounted." --icon ~/Downloads/pictures/tbhk/t5.jpg
		fi
	fi
}

if [ $(simple-mtpfs --list-devices | wc -l) -ge 1 ] && [ -n "$(grep simple-mtpfs /proc/mounts)" ]; then
	chkumnt=$(printf "No\nYes" | dmenu -p "Unmount android device?")
	case $chkumnt in
		Yes)
			andmnt=$(mount -l | awk '$1 == "simple-mtpfs" {print $3}' | dmenu -i -c -p "Unmount which android mount?")
			if ! sudo fusermount -u $andmnt; then
				notify-send "$andmnt unmount failed, check if any programs are using the drive."
				exit 1
			else
				notify-send "$andmnt unmounted."
			fi;;
		No)
			_umount;;
		*)
			exit
	esac
else
	_umount
fi
