#!/bin/sh
xset b 0
setxkbmap -option # reset
setxkbmap -option terminate:ctrl_alt_bksp
setxkbmap -option altwin:ctrl_alt_win
setxkbmap -option caps:ctrl_modifier
xmodmap -e 'keycode 22 = Delete'  # apple keyboard

xsetroot -solid black -cursor_name top_left_arrow

which dropbox && dropbox start

exec /usr/bin/evilwm -term $HOME/.bin/my_term -snap 10 -fn iso8859-16


##-- old crap --##
# setxkbmap -option altwin:swap_lalt_lwin  # apple keyboard
# setxkbmap -option ctrl:swapcaps
# xmodmap -e 'keycode 22 = BackSpace'  # apple keyboard
