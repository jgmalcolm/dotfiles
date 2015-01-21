#!/bin/sh

if [ $# -gt 0 ]; then
    for eps in $@; do
        png=$(echo $eps | sed 's/^\(.*\)\.eps/\1.png/')
        [ ${eps} -nt ${png} ] && echo $eps && convert $eps $png
    done
else
    for eps in *.eps; do
        png=$(echo $eps | sed 's/^\(.*\)\.eps/\1.png/')
        [ ${eps} -nt ${png} ] && echo $eps && convert $eps $png
    done
fi
