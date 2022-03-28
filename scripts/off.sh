#!/bin/sh

A=$(printf "SHUTDOWN\nREBOOT" | dmenu -p OPTIONS:)

case $A in
	SHUTDOWN)
		sudo shutdown -P now
		;;
	REBOOT)
		sudo reboot
		;;
esac
