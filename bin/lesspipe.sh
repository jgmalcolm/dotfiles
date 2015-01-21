#!/bin/sh
fn="$1"
case "$fn" in
    *.tgz|*.tar.gz)  tar tzf "$fn" ;;
    *.tar)           tar tf "$fn" ;;
    *.tar.bz2)       tar tjf "$fn" ;;
    *.zip)           unzip -l "$fn" ;;
    *.gz)            gunzip -c "$fn" ;;
    *.bz2)           bunzip2 -c "$fn" ;;
    *.tbz)           tar tjf "$fn" ;;
    *.bf)            openssl bf -d <"$fn";;
    *.patch|*.diff)  colordiff <"$fn";;
esac
[ -d "$fn" ] && ls -1FlA "$fn"  # directory listings
