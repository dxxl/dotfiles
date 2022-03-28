#!/bin/sh

_mount(){
	fscheck=$(lsblk -no "fstype" "$chs")
	usr=$(echo "$USER")
	grp=$(groups | awk '{print $1}')
	userid=$(id -u "$USER")
	grpid=$(id -g "$USER")
	case $fscheck in
		ntfs)
			sudo mount -t ntfs "$chs" "$mntpt" -o rw,umask=0000,uid="$userid",gid="$grpid"
			sudo mount --all -o remount,rw -t ntfs;;
		vfat)
			sudo mount -t vfat "$chs" "$mntpt" -o rw,umask=0000,uid="$userid",gid="$grpid";;
		*)
			sudo mount $chs $mntpt
			sudo chown "$usr":"$grp" "$mntpt";;
	esac
	notify-send "$chs mounted to $mntpt." --icon ~/Downloads/pictures/tbhk/t3.jpg
}

_dircheck(){
	dir=$(find /home/$USER -type d -maxdepth 2 2>/dev/null)
	mntpt=$(echo "$dir" | dmenu -p "Mount point?")
	if [ ! -d "$mntpt" ]; then
		mkdir=$(printf "No\nYes" | dmenu -p "$mntpt does not exist. Create it?")
			if [ "$mkdir" = "Yes" ]; then
				sudo mkdir -p "$mntpt"
				$1
			else
				exit
			fi
		else
			$1
	fi
}

_mountproc(){
	mnt=$(lsblk -lp | grep "part $" | awk '{print $1, "(" $4 ")"}')
	chs=$(echo "$mnt"| dmenu -p "Mount which?" | awk '{print $1}')
	if [ -z "$chs" ]
	then
		exit
	else
		_dircheck _mount
	fi
}

_andmount(){
	if ! sudo simple-mtpfs --device $chs -o allow_other $mntpt; then
		notify-send "Error mounting android device, check if the device is properly set as MTP."
	else
		notify-send "Android device mounted at $mntpt."
	fi
}

if [ $(simple-mtpfs --list-devices | wc -l) -ge 1 ] && [ -z $(grep simple-mtpfs /proc/mounts) ]; then
	chkmnt=$(printf "No\nYes" | dmenu -p "Mount the android device?")
	case $chkmnt in
		No)
			_mountproc;;
		Yes)
			andls=$(simple-mtpfs --list-devices | dmenu -p "Mount which device?")
			chs=$(echo ${andls%%:*})
			_dircheck _andmount;;
		*)
			exit
	esac
else
	_mountproc
fi
