#!/bin/sh -x
set -eu

dir=$(dirname $0)

echo $dir

link() { rm -rf $HOME/.$1; ln -s $dir/$1 $HOME/.$1; }
copy() { rm -rf $HOME/.$1; cp -p $dir/$1 $HOME/.$1; }

# ssh,gdb hate symlinks
cp -p $dir/ssh_config   $HOME/.ssh/config
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
