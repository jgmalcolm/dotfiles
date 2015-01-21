#!/bin/sh

if [ $# -gt 0 ]; then
    for png in $@; do
        eps=${png%.png}.eps
        [ ${png} -nt ${eps} ] && echo $png && convert $png $eps
    done
else
    for png in *.png; do
        eps=${png%.png}.eps
        [ ${png} -nt ${eps} ] && echo $png && convert $png $eps
    done
fi

