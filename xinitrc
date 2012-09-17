#!/bin/sh
xset b 0
setxkbmap -option terminate:ctrl_alt_bksp
setxkbmap -option ctrl:swapcaps
setxkbmap -option altwin:swap_lalt_lwin  # apple keyboard
xmodmap -e 'keycode 22 = Delete'  # apple keyboard
#xmodmap -e 'keycode 22 = BackSpace'  # apple keyboard

xsetroot -solid black -cursor_name top_left_arrow

#which dropbox && dropbox start

exec /usr/bin/evilwm -term $HOME/.bin/my_term -snap 10 -fn iso8859-16
