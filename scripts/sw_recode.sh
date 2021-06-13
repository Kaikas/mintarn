#!/bin/bash
# Find the current encoding of the file
encoding=$(file -i "$1" | sed "s/.*charset=\(.*\)$/\1/")

if [ ! "windows-1252" == "${encoding}" ]
then
	# Encodings differ, we have to encode
	echo "recoding from ${encoding} to "ANSI windows-1252" file : $1"
	recode ${encoding}..windows-1252 $1
fi
