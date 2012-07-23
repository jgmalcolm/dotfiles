#!/bin/sh -x
set -eu

CONFIG=/misc/nfs/config

link() { rm -rf $HOME/.$1; ln -s $CONFIG/$1 $HOME/.$1; }
copy() { rm -rf $HOME/.$1; cp -p $CONFIG/$1 $HOME/.$1; }

# ssh,gdb hate symlinks
cp -p $CONFIG/ssh_config   $HOME/.ssh/config
copy gdbinit

# these guys are fine with symlinks
link xinitrc
link bashrc
link bash_profile
link screenrc
link emacs
link elisp
link eshell
link gitconfig
link vimrc
