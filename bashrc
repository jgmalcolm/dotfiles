#!/bin/sh
# run on non-interactive logins

umask 002  # mask off world write

shopt -s checkwinsize # reassess window size between commands
shopt -s cdspell # fix 'cd folder' spelling mistakes

alias ls="BLOCK_SIZE=\'1 ls -1F --color" # enable thousands grouping
alias l='ls'
alias ll='ls -l'
alias lrt='ls -rt'
alias llrt='ls -lrt'
alias la='ls -A'
alias lla='ls -lA'
alias ..='cd ..'
alias -- -='cd -'
alias g=git
alias gs='git st'
alias gd='git di'
alias gf='git f'
alias dm='du -smc * | sort -n'
alias gdb='gdb --quiet'
alias hd='od -Ax -tx1z -v' # hexdump

function m { matlab -nodesktop -nosplash; }
function mdb { matlab -Dgdb; }

export GREP_OPTIONS=--color=auto
export GREP_COLOR="1;33;40"  # yellow on black
alias r='stty sane'

function s { local cmd="screen -ADR $(whoami)"; [[ $# == 0 ]] && $cmd || ssh -t $@ $cmd; }
function x { local cmd="screen -Ax  $(whoami)"; [[ $# == 0 ]] && $cmd || ssh -t $@ $cmd; }
function line   { sed "$1q;d" $2; } # line <line> [file]
function rmline { sed -i'' -e "$1d" $2; }  # rmline <line> [file]
function buffer { (test -t 1 && less -F - || cat) } # stdin to less if terminal
function tmpdir { pushd `mktemp -d -t tmpXXX`; }
function mkdircd { mkdir -p $1 && cd $1; }
function calc   { echo "$@" | bc -l; } # math with floats
function e { emacsclient -t $@; }
alias unansi='sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"' # strip ansi color escape sequences
function c { cal -3 $@; }
function dos2unix { sed -i '' -e 's///g' $@; }
function gb {
    fmt='%ci %h %C(yellow)%ar%C(reset)%C(green)%d%C(reset) %C(red)%an%Creset %s'
    for k in `git branch -av | sed 's/^..[^ ]* *\([a-f0-9]*\) .*$/\1/'| sort -u`; do
        echo `git log -1 --pretty="$fmt" $k`;
    done | sort -nr | sed 's/^[^ %]* [^ ]* [^ ]* //' | buffer;
}

function matrix { tr -c "[:digit:]" " " < /dev/urandom | dd cbs=$COLUMNS conv=unblock | GREP_COLOR="1;32" grep --color "[^ ]"; }

# http://www.gnu.org/software/src-highlite/source-highlight.html#Using-source_002dhighlight-with-less
export LESS="-iFmRSX" #QR
export LESSOPEN="|lesspipe.sh %s"  # special less file hooks
export LESSCLOSE=

if [[ `uname -m` == x86_64 ]]; then ARCH=64; fi
if [[ `uname` == Darwin ]]; then
  alias ls='ls -1GF' # Darwin hates '--color' parameter
  c() { cal $@; }
fi

# timestap history
export HISTFILE=~/.bash_history
echo "# $(date)" >>$HISTFILE
export HISTFILESIZE=1000
export HISTSIZE=1000
export HISTCONTROL=ignoreboth # Don't store duplicate adjacent items in the history
export PROMPT_COMMAND="history -a && history -r" # each cmd updates hist on disk
# 'history -r' slows down the prompt

# adapted from github.com/huyng/bashmarks
touch ~/.bookmarks
. ~/.bookmarks
function mark {  # mark current directory
    tmp=$(mktemp -t tmpXXX)
    mv ~/.bookmarks $tmp
    grep -v "export DIR_$1=" $tmp >~/.bookmarks
    echo "export DIR_$1='$PWD'" >>~/.bookmarks
}

function j {  # jump to bookmark
   . ~/.bookmarks
   cd "$(eval $(echo echo $(echo \$DIR_$1)))"
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

# setup git prompt if possible (set default first)
# ${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\]
export PS1='\[\033[1G\e[33m\]\h\[\e[0m\].\[\033[32m\]\W\[\033[0m\] \$ '
[ -r ~/.git-prompt.sh     ] && source ~/.git-prompt.sh
[ -r ~/.git-completion.sh ] && source ~/.git-completion.sh
export PS1='\[\033[1G\e[33m\]\h\[\e[0m\].\[\033[32m\]\W\[\033[0m\]$(__git_ps1 "{%s}") \$ '

set visual-bell none

BLOCK_SIZE='si'

# setup PATH (top of list is highest precedence)
[[ `uname` =~ CYGWIN.* ]] || PATH=   # windows already set PATH
for p in \
    $HOME/.bin \
    /usr/local/matlab/bin \
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
    ; do
  [ -x $p ] && PATH=$PATH:$p
done
unset p
export PATH=${PATH##:}

export MANPATH=/usr/share/man:/usr/local/man:/opt/local/man
export INFOPATH=/usr/local/info:/usr/share/info:/opt/local/info

[ $TERM == "screen.rxvt" ] && export TERM=xterm-256color

export PAGER=less
export VISUAL='emacsclient'
export EDITOR='emacsclient'
export ALTERNATE_EDITOR=vim
export NETHACKOPTIONS  # for screen fun
