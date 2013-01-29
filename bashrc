#!/bin/sh
# run on non-interactive logins

umask 002
#ulimit -c unlimited  # produce core files upon segfault

shopt -s checkwinsize # reassess window size between commands

alias ls="BLOCK_SIZE=\'1 ls -1 --color" # enable thousands grouping
alias l='ls'
alias ll='ls -l'
alias lrt='ls -rt'
alias llrt='ls -lrt'
alias la='ls -A'
alias lla='ls -lA'
alias ..='cd ..'
alias -- -='cd -'
alias g=git
alias gi=git
alias gs='git st'
alias gd='git di'
alias gf='git f'
alias dm='du -sm * | sort -n'
alias gdb='gdb --quiet'
#function _head {
#  [ $# -ge 1 -a "${1#-}" = "$1" ] \
#    && \head -$((${LINES:-12}-2)) $@ \
#    || \head $@;
#}
#alias head=_head
#alias tail='tail -n $((${LINES:-12}-2)) -s.1' #Likewise, also more responsive -f
alias hd='od -Ax -tx1z -v' # hexdump


export GREP_OPTIONS=--color=auto
export GREP_COLOR="1;33;40"  # yellow on black
alias r='stty sane'

function h { history | tail -15; }
function s { local cmd="screen -ADR $(whoami)"; [[ $# == 0 ]] && $cmd || ssh -t $@ $cmd; }
function x { local cmd="screen -Ax  $(whoami)"; [[ $# == 0 ]] && $cmd || ssh -t $@ $cmd; }
function line   { sed "$1q;d" $2; }
function rmline { sed -i'' -e "$1d" $2; }
function buffer { (test -t 1 && less -F - || cat) } # stdin to less if terminal
function tmpdir { pushd `mktemp -d -t tmpXXX`; }
function mkdircd { mkdir -p $1 && cd $1; }
function calc   { echo "$@" | bc -l; }
function E { emacs -bg black -fg white $@; }
function e { emacsclient -t $@; }
function ex { [[ $# == 0 ]] && emacsclient -c -n || ssh -Xf $@ emacsclient -c -n & exit; }
function pdf { xpdf $@ & exit; }
function mdb { matlab -Dgdb; }
alias unansi='sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"' # strip ansi color escape sequences
function c { cal -3 $@; }
function svndi { svn di $@ | colordiff | buffer; }
alias svnst='svn st'
function dos2unix { sed 's/\o15//g' -i $@; }
alias gup='git up'
function gb {
    fmt='%ci %h %C(yellow)%ar%C(reset)%C(green)%d%C(reset) %C(red)%an%Creset %s'
    for k in `git branch -av | sed 's/^..[^ ]* *\([a-f0-9]*\) .*$/\1/'| sort -u`; do
        echo `git log -1 --pretty="$fmt" $k`;
    done | sort -nr | sed 's/^[^ %]* [^ ]* [^ ]* //' | buffer;
}

function matrix { tr -c "[:digit:]" " " < /dev/urandom | dd cbs=$COLUMNS conv=unblock | GREP_COLOR="1;32" grep --color "[^ ]"; }

export LESS="-iFmRSX" #QR
export LESSOPEN="|lesspipe.sh %s"  # special less file hooks
export LESSCLOSE=

alias m="matlab -nojvm -nosplash"
alias M="matlab -nodesktop -nosplash"

if [[ `uname -m` == x86_64 ]]; then ARCH=64; fi
if [[ `uname` == Darwin ]]; then
  alias ls='ls -1G' # Darwin hates '--color' parameter
  c() { cal $@; }
fi

# timestap history
export HISTFILE=~/.bash_history
echo "# $(date)" >>$HISTFILE
export HISTFILESIZE=100000
export HISTSIZE=100000
export HISTCONTROL=ignoreboth # Don't store duplicate adjacent items in the history
shopt -s histappend
export PROMPT_COMMAND="history -a && history -r" # each cmd updates hist on disk

# adapted from github.com/huyng/bashmarks
touch ~/.bookmarks
. ~/.bookmarks
function mark {  # mark current directory
    tmp=$(mktemp -t tmpXXX)
    mv ~/.bookmarks $tmp
    grep -v "export DIR_$1=" $tmp >~/.bookmarks
    echo "export DIR_$1=$PWD" >>~/.bookmarks
}

function j {  # jump to bookmark
   . ~/.bookmarks
   cd $(eval $(echo echo $(echo \$DIR_$1)))
}

function list {  # list bookmarks (with dirname)
   . ~/.bookmarks
   env | grep "^DIR_" | cut -c5- | grep -E --color "^[^=]*"
}
function _list {  # list bookmarks (without dirname)
   . ~/.bookmarks
   env | grep "^DIR_" | cut -c5- | grep "^.*=" | cut -f1 -d "="
}

function _jump { # completion command for jump
    local curw
    COMPREPLY=()
    curw=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($(compgen -W '`_list`' -- $curw))
    return 0
}
complete -F _jump j
shopt -s progcomp

# tab-complete git tags/branches/etc.
for base in /etc/bash_completion.d /opt/local/etc/bash_completion.d /usr/share/bash-completion/completions; do
    [ -r $base/git ] || continue
    . $base/git
    complete -o bashdefault -o default -o nospace -F _git g # alias g=git
    break
done

# setup git prompt if possible (set default first)
export PS1='\[\033[1G\e[33m\]\h\[\e[0m\].\[\033[32m\]\W\[\033[0m\] \$ '
for p in /usr/share/git/git-prompt.sh /usr/share/git/completion/git-prompt.sh; do
    [ -r $p ] || continue
    . $p
    export PS1='\[\033[1G\e[33m\]\h\[\e[0m\].\[\033[32m\]\W\[\033[0m\]$(__git_ps1 "{%s}") \$ '
done

set visual-bell none

BLOCK_SIZE='si'

# setup PATH (top of list is highest precedence)
[[ `uname` =~ CYGWIN.* ]] || PATH=   # windows already set PATH
for p in \
    $HOME/.bin \
    /usr/local/matlab/bin \
    /usr/local/cuda/bin \
    /usr/local/bin \
    /usr/local/sbin \
    /opt/local/bin \
    /opt/local/sbin \
    /usr/bin \
    /usr/sbin \
    /bin \
    /sbin \
    /usr/X/bin \
    /usr/X11R6/bin \
    /usr/local/java/default/bin \
    /usr/local/sge/ge2011.11/bin/linux-x64 \
    ; do
  [ -x $p ] && PATH=$PATH:$p
done
unset p
export PATH=${PATH##:}

export MANPATH=/usr/share/man:/usr/local/man:/opt/local/man:/usr/local/cuda/man:/usr/local/sge/ge2011.11/man
export INFOPATH=/usr/local/info:/usr/share/info:/opt/local/info

export SGE_EXECD_PORT=6445
export SGE_QMASTER_PORT=7890
export SGE_ROOT=/usr/local/sge/ge2011.11

export PAGER=less
export VISUAL=vim
export EDITOR=vim
export ALTERNATE_EDITOR=vi
export NETHACKOPTIONS  # for screen fun
