#!/bin/bash

if [ $# -lt 1 ]; then
	echo "U¿ycie: $0 <link_do_napisów>"
	exit 1
fi

OUTPUT=`echo $1 | sed -re 's#http://napisy24.pl/download/(archiwum/)?([0123456789]+)/#\2#g'`.zip
UA="Mozilla/5.0 (X11; U; Linux x86_64; de-AT; rv:1.9.0.5) Gecko/2008122010 Iceweasel/3.0.5 (Debian-3.0.5-1)"

wget --user-agent="$UA" --referer=http://napisy24.pl/ $1 -O "$OUTPUT"

if [ -z "$2" ]; then
	unzip -o "$OUTPUT"
	rm "$OUTPUT"
	rm -f Napisy24.pl.url
else
	echo
	echo "Saved as $OUTPUT"
fi
