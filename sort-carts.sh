#!/bin/bash

# find all ccc (cartridge files) and process them

shopt -s nocaseglob
shopt -s globstar
shopt -s nocasematch

# start of counter variable
counter=1

# if sort folder exits, purge it
if [ -d "$1-sorted" ]; then
	rm -r "$1-sorted"
fi

# create folder to place sorted ROM/CART files
if [ ! -d "$1-sorted" ]; then
	mkdir "$1-sorted"
fi


for i in $PWD/$1/**/*.ccc; do # Whitespace-safe and recursive

	fullfilename="$i"
	filename=$(basename "$fullfilename")
	fname="${filename%.*}"
	fpath=$(dirname "$fullfilename")
	filesize=$(stat -c%s "$fullfilename")
	#cartsize=$(numfmt --to=iec $filesize)
	cartsize=$(numfmt --to=iec --round=up $filesize)
	cartsize2=$(echo ${cartsize%?})
	cartsize3=$(printf "%03d" $cartsize2)

	# extract RS catalog number from cartridge filename description
	catnum=$(echo "$i" | grep -o -P '26-.{0,4}')

	# extract parent folder name from full path
	filepath=$i
	parentname="$(basename "$(dirname "$filepath")")"


	echo \""$fpath/$cartsize3 $filename\""
	cp "$fullfilename" "$fpath-sorted/$cartsize3 $filename"

	counter=$((counter+1))

done

shopt -u nocaseglob
shopt -u globstar
shopt -u nocasematch

echo Done!
