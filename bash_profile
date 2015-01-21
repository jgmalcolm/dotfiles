#!/bin/sh
# run for interactive logins

case `uname` in
  Linux)
    which stty &>/dev/null && stty stop ^S intr ^C
    which setterm &>/dev/null && setterm -blength 0
    ;;
esac

. ${HOME}/.bashrc

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
