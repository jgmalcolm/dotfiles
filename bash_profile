#!/bin/sh
# run for interactive logins

case `uname` in
    Linux)
    which stty &>/dev/null && stty stop ^S intr ^C
    which setterm &>/dev/null && setterm -blength 0
    ;;
esac

. ${HOME}/.bashrc

test -r /sw/bin/init.sh && . /sw/bin/init.sh

# Setting PATH for MacPython 2.6
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/2.6/bin:$PATH"
export PATH

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
