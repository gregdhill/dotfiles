export LC_ALL=C
if [ "$(tty)" = "/dev/tty1" ]; then
	exec sway
fi
