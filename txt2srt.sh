#!/bin/bash

# Copyright 2008 by Michal Kowalczuk <michal@kowalczuk.eu>
# licensed under WTFPL (http://sam.zoy.org/wtfpl/)
# version 0.1

MPLAYER=/usr/bin/mplayer
NAPIPY=$HOME/bin/napi.py

if [ $# -lt 1 ]; then
    echo "Usage: $0 movie [ subfile ] [ subfps ]"
    exit 1
fi

MOVIE="$1"
BASE="`echo "$MOVIE" | rev | cut -d . -f 2- | rev`"
SRT="$BASE.srt"

if [ -n "$3" ]; then
    SUBFPS="-subfps $3"
fi

if [ ! -f "$MOVIE" ]; then
    echo "nie ma filma - nie ma srt-a"
fi

if [ $# -lt 2 ]; then
    SUB="$BASE.txt"
    $NAPIPY "$MOVIE"
else
    SUB="$2"
fi

if [ ! -f "$SUB" ]; then
    echo "nie ma napisa - nie ma srt-a"
    exit 1
fi

SUB_UTF8=`mktemp`

iconv -f cp1250 -t utf8 < "$SUB" > "$SUB_UTF8"
echo q | $MPLAYER -vo null -ao null -sub "$SUB_UTF8" $SUBFPS -subcp utf8 -dumpsrtsub "$MOVIE" 2>&1

iconv -f utf8 -t cp1250 < dumpsub.srt > "$SRT"
rm -f "$SUB_UTF8" dumpsub.srt
