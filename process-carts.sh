#!/bin/bash

# make sure to download the cartridge files from colorcomputerarchive.com before using
# wget -v --mirror -p --convert-links --no-parent http://www.colorcomputerarchive.com/coco/Cartridges/


# perform some housekeeping

# if DW2SD folder exits, purge it
if [ -d "DW2SD" ]; then
	rm -r "DW2SD"
fi

# if ccflash-pyDW.sh script exists, delete it
if [ -e "ccflash-pyDW.sh" ]; then
	rm "ccflash-pyDW.sh"
fi

# if ccflash-report.txt exists, delete it
if [ -e "ccflash-report-$1.txt" ]; then
	rm "ccflash-report-$1.txt"
fi

# if DATA.MID exists, delete it
if [ -e "DATA.MID" ]; then
	rm "DATA.MID"
fi

# if PRGFLASH/MENU.BAS exists, delete it
if [ -e "PRGFLASH/MENU.BAS" ]; then
	rm "PRGFLASH/MENU.BAS"
fi

# if PRGFLASH/PRGFLASH.DSK exists, delete it
if [ -e "PRGFLASH/PRGFLASH.DSK" ]; then
	rm "PRGFLASH/PRGFLASH.DSK"
fi

# end of housekeeping


echo echo Inserting  [  \"PRGFLASH\" ]  DSK image >> ccflash-pyDW.sh
echo echo "\(used for flashing new MENU to CoCoFLASH cartridge\)" >> ccflash-pyDW.sh
echo echo >> ccflash-pyDW.sh

# change the 'dw instance select x' as per your requirement
echo $HOME/pyDriveWire/pyDwCli http://localhost:6800 dw instance select 0 >> ccflash-pyDW.sh

echo $HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk eject 0 >> ccflash-pyDW.sh
echo $HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk insert 0 \"/media/share1/DW4/CCFLASH/PRGFLASH/PRGFLASH.DSK\" >> ccflash-pyDW.sh
echo echo >> ccflash-pyDW.sh
echo read -p  \"Press any key to insert next DSK image...\" -n1 -s >> ccflash-pyDW.sh
echo echo >> ccflash-pyDW.sh
echo echo >> ccflash-pyDW.sh
echo echo >> ccflash-pyDW.sh
echo >> ccflash-pyDW.sh
echo >> ccflash-pyDW.sh


# ROM trailer/footer info to convert them to a BIN:
# 2K				00 08 00 40 00						FF 00 00 40 00
# 4K				00 10 00 40 00						FF 00 00 40 00
# 8K				00 20 00 40 00						FF 00 00 40 00
# 10/12K			00 30 00 40 00						FF 00 00 40 00
# 15K				00 3E 00 40 00						FF 00 00 40 00	(15,872)
# 15K				00 3F 00 40 00						FF 00 00 40 00	(16,128)
# 16K				00 40 00 40 00						FF 00 00 40 00	(16,384)
# 16K				00 3F F0 40 00						FF 00 00 40 00	(16,368)

# find all *.ccc (cartridge files) and process them

shopt -s nocaseglob
shopt -s globstar
shopt -s nocasematch

# start of counter variable
counter=1

# start of CocoFLASH bank to begin programming (BANK 0 & 1 are reserved for MENU)
bankno=2

for i in $PWD/$1/**/*.ccc; do # Whitespace-safe and recursive

	fullfilename="$i"
	filename=$(basename "$fullfilename")
	fname="${filename%.*}"
	filesize=$(stat -c%s "$fullfilename")
	cartsize=$(numfmt --to=iec $filesize)

	# extract RS catalog number from cartridge filename description
	catnum=$(echo "$i" | grep -o -P '26-.{0,4}')

	# extract parent folder name from full path
	filepath=$i
	parentname="$(basename "$(dirname "$filepath")")"


	# check for non-original versions of cartridges and exclude them
	#if [[ $fullfilename != *"[a1]"* ]] && [[ $fullfilename != *"[b1]"* ]] && [[ $fullfilename != *"[o1]"* ]] && [[ $fullfilename != *"[h1]"* ]] && [[ $fullfilename != *"26-xxxx"* ]]; then

		# if RS catalog number for catridge is not blank, process the file
		if [ ! -z "$catnum" ]; then

			echo Processing "$filename - $filesize - $cartsize - $catnum"


			# create folder based on ROM size (in K)
			if [ ! -d "$cartsize" ]; then
				mkdir "$cartsize"
			fi

			# create folder based on ROM size (in K)/ Radio Shack catalog number
			if [ ! -d "$cartsize/$catnum" ]; then
				mkdir "$cartsize/$catnum"
			fi

			# used for DW2SD program
			if [ ! -d "DW2SD" ]; then
				mkdir "DW2SD"
			fi

			# used for DW2SD program
			if [ ! -d "DW2SD/$fname" ]; then
				mkdir "DW2SD/$fname"
			fi


			# if the destination DSK image does not exist, create it
			if [ ! -f "$cartsize/$catnum/$catnum.DSK" ]; then
				decb dskini "$cartsize/$catnum/$catnum.DSK" -n"$fname"
			fi

			if [ ! -f "DW2SD/$fname/catnum.DSK" ]; then
        			decb dskini "DW2SD/$fname/$catnum.DSK" -n"$fname"
			fi


			# if cartridge is under 128K, include CocoFLASH companion files to DSK image
			# if not, skip them as there will not be enough room on DSK image for split ROM
			if [ $filesize -lt 131072 ]; then

				# add Barry's ROM to BIN conversion programs to DSK image
				decb copy -0 -a -r "PRGFLASH/PRGFLASH.BAS" "$cartsize/$catnum/$catnum.DSK","PRGFLASH.BAS"
				decb copy -2 -b -r "PRGFLASH/PRGFLASH.BIN" "$cartsize/$catnum/$catnum.DSK","PRGFLASH.BIN"
				decb copy -2 -b -r "PRGFLASH/BASLOAD.BIN" "$cartsize/$catnum/$catnum.DSK","BASLOAD.BIN"

				decb copy -0 -a -r "PRGFLASH/PRGFLASH.BAS" "DW2SD/$fname/$catnum.DSK","PRGFLASH.BAS"
				decb copy -2 -b -r "PRGFLASH/PRGFLASH.BIN" "DW2SD/$fname/$catnum.DSK","PRGFLASH.BIN"
				decb copy -2 -b -r "PRGFLASH/BASLOAD.BIN" "DW2SD/$fname/$catnum.DSK","BASLOAD.BIN"
			fi


			cp "$i" "$cartsize/$catnum/$catnum.ROM"


			# if cartridge is 2K...
			if [ $filesize -eq 2048 ]; then

				 # define cart bank type and total (4K) banks used
 				 banktype=2
				 banksused=1

				# add header/footer to ROM file to convert to a BIN (2K)
				for c in $cartsize/$catnum/$catnum.ROM; do

					printf "\x00\x08\x00\x40\x00" | cat - $c > $c.BIN
					printf "\xFF\x00\x00\x40\x00" >> $c.BIN
					rm $c
					mv $c.BIN $c

					cp "$cartsize/$catnum/$catnum.ROM" "DW2SD/$fname/$catnum.BIN"
					mv "$cartsize/$catnum/$catnum.ROM" "$cartsize/$catnum/$catnum.BIN"

					binname=$(basename "$c")
					decb copy -2 -b -r "$cartsize/$catnum/$catnum.BIN" "$cartsize/$catnum/$catnum.DSK","$catnum.BIN"
					decb copy -2 -b -r "$cartsize/$catnum/$catnum.BIN" "DW2SD/$fname/$catnum.DSK","$catnum.BIN"

				done

			fi



			# if cartridge is 4K...
			if [ $filesize -eq 4096 ]; then

				# define cart bank type and total (4K) banks used
 			 	banktype=2
 			 	banksused=1

				# add header/footer to ROM file to convert to a BIN (4K)
				for c in $cartsize/$catnum/$catnum.ROM; do

					printf "\x00\x10\x00\x40\x00" | cat - $c > $c.BIN
					printf "\xFF\x00\x00\x40\x00" >> $c.BIN
					rm $c
					mv $c.BIN $c
					cp "$cartsize/$catnum/$catnum.ROM" "DW2SD/$fname/$catnum.BIN"
					mv "$cartsize/$catnum/$catnum.ROM" "$cartsize/$catnum/$catnum.BIN"

					binname=$(basename "$c")
					decb copy -2 -b -r "$cartsize/$catnum/$catnum.BIN" "$cartsize/$catnum/$catnum.DSK","$catnum.BIN"  
					decb copy -2 -b -r "$cartsize/$catnum/$catnum.BIN" "DW2SD/$fname/$catnum.DSK","$catnum.BIN"  

				done

			fi



			# if cartridge is 8K...
			if [ $filesize -eq 8192 ]; then

				# define cart bank type and total (4K) banks used
 			 	banktype=2
				banksused=2

				# add header/footer to ROM file to convert to a BIN (8K)
				for c in $cartsize/$catnum/$catnum.ROM; do

					printf "\x00\x20\x00\x40\x00" | cat - $c > $c.BIN
					printf "\xFF\x00\x00\x40\x00" >> $c.BIN
					rm $c
					mv $c.BIN $c
					cp "$cartsize/$catnum/$catnum.ROM" "DW2SD/$fname/$catnum.BIN"
					mv "$cartsize/$catnum/$catnum.ROM" "$cartsize/$catnum/$catnum.BIN"

					binname=$(basename "$c")
					decb copy -2 -b -r "$cartsize/$catnum/$catnum.BIN" "$cartsize/$catnum/$catnum.DSK","$catnum.BIN"
					decb copy -2 -b -r "$cartsize/$catnum/$catnum.BIN" "DW2SD/$fname/$catnum.DSK","$catnum.BIN"

				done

			fi



			# if cartridge is 10K...
			if [ $filesize -eq 10240 ]; then

				# define cart bank type and total (4K) banks used
 				banktype=2
 				banksused=3

				# add header/footer to ROM file to convert to a BIN (12K)
				for c in $cartsize/$catnum/$catnum.ROM; do

					printf "\x00\x28\x00\x40\x00" | cat - $c > $c.BIN
					printf "\xFF\x00\x00\x40\x00" >> $c.BIN
					rm $c
					mv $c.BIN $c
					cp "$cartsize/$catnum/$catnum.ROM" "DW2SD/$fname/$catnum.BIN"
					mv "$cartsize/$catnum/$catnum.ROM" "$cartsize/$catnum/$catnum.BIN"

					binname=$(basename "$c")
					decb copy -2 -b -r "$cartsize/$catnum/$catnum.BIN" "$cartsize/$catnum/$catnum.DSK","$catnum.BIN"
					decb copy -2 -b -r "$cartsize/$catnum/$catnum.BIN" "DW2SD/$fname/$catnum.DSK","$catnum.BIN"

				done

			fi



     			# if cartridge is 12K...
			if [ $filesize -eq 12288 ]; then

				# define cart bank type and total (4K) banks used
 				banktype=2
 				banksused=3

				# add header/footer to ROM file to convert to a BIN (12K)
				for c in $cartsize/$catnum/$catnum.ROM; do

					printf "\x00\x30\x00\x40\x00" | cat - $c > $c.BIN
					printf "\xFF\x00\x00\x40\x00" >> $c.BIN
					rm $c
					mv $c.BIN $c
					cp "$cartsize/$catnum/$catnum.ROM" "DW2SD/$fname/$catnum.BIN"
						mv "$cartsize/$catnum/$catnum.ROM" "$cartsize/$catnum/$catnum.BIN"

					binname=$(basename "$c")
					decb copy -2 -b -r "$cartsize/$catnum/$catnum.BIN" "$cartsize/$catnum/$catnum.DSK","$catnum.BIN"
					decb copy -2 -b -r "$cartsize/$catnum/$catnum.BIN" "DW2SD/$fname/$catnum.DSK","$catnum.BIN"

				done

			fi



			# if cartridge is 15K...
			if [ $filesize -eq 15872 ]; then

				# define cart bank type and total (4K) banks used
 				banktype=2
 				banksused=4

				# add header/footer to ROM file to convert to a BIN (16K)
				for c in $cartsize/$catnum/$catnum.ROM; do

					printf "\x00\x3E\x00\x40\x00" | cat - $c > $c.BIN
					printf "\xFF\x00\x00\x40\x00" >> $c.BIN
					rm $c
					mv $c.BIN $c
					cp "$cartsize/$catnum/$catnum.ROM" "DW2SD/$fname/$catnum.BIN"
					mv "$cartsize/$catnum/$catnum.ROM" "$cartsize/$catnum/$catnum.BIN"

					binname=$(basename "$c")
					decb copy -2 -b -r "$cartsize/$catnum/$catnum.BIN" "$cartsize/$catnum/$catnum.DSK","$catnum.BIN"
					decb copy -2 -b -r "$cartsize/$catnum/$catnum.BIN" "DW2SD/$fname/$catnum.DSK","$catnum.BIN"

				done

			fi



			# if cartridge is 15K...
			if [ $filesize -eq 16128 ]; then

				# define cart bank type and total (4K) banks used
 				banktype=2
 				banksused=4

				# add header/footer to ROM file to convert to a BIN (16K)
				for c in $cartsize/$catnum/$catnum.ROM; do

					printf "\x00\x3F\x00\x40\x00" | cat - $c > $c.BIN
					printf "\xFF\x00\x00\x40\x00" >> $c.BIN
					rm $c
					mv $c.BIN $c
					cp "$cartsize/$catnum/$catnum.ROM" "DW2SD/$fname/$catnum.BIN"
					mv "$cartsize/$catnum/$catnum.ROM" "$cartsize/$catnum/$catnum.BIN"

					binname=$(basename "$c")
					decb copy -2 -b -r "$cartsize/$catnum/$catnum.BIN" "$cartsize/$catnum/$catnum.DSK","$catnum.BIN"
					decb copy -2 -b -r "$cartsize/$catnum/$catnum.BIN" "DW2SD/$fname/$catnum.DSK","$catnum.BIN"

				done

			fi



			# if cartridge is 16K...
			if [ $filesize -eq 16384 ]; then

				# define cart bank type and total (4K) banks used
 				banktype=2
 				banksused=4

				# add header/footer to ROM file to convert to a BIN (16K)
				for c in $cartsize/$catnum/$catnum.ROM; do

					printf "\x00\x40\x00\x40\x00" | cat - $c > $c.BIN
					printf "\xFF\x00\x00\x40\x00" >> $c.BIN
					rm $c
					mv $c.BIN $c
					cp "$cartsize/$catnum/$catnum.ROM" "DW2SD/$fname/$catnum.BIN"
					mv "$cartsize/$catnum/$catnum.ROM" "$cartsize/$catnum/$catnum.BIN"

					binname=$(basename "$c")
					decb copy -2 -b -r "$cartsize/$catnum/$catnum.BIN" "$cartsize/$catnum/$catnum.DSK","$catnum.BIN"
					decb copy -2 -b -r "$cartsize/$catnum/$catnum.BIN" "DW2SD/$fname/$catnum.DSK","$catnum.BIN"

				done

			fi



			# if cartridge is 16K...
			if [ $filesize -eq 16368 ]; then

				# define cart bank type and total (4K) banks used
 				banktype=2
 				banksused=4

				# add header/footer to ROM file to convert to a BIN (16K)
				for c in $cartsize/$catnum/$catnum.ROM; do

					printf "\x00\x3F\xF0\x40\x00" | cat - $c > $c.BIN
					printf "\xFF\x00\x00\x40\x00" >> $c.BIN
					rm $c
					mv $c.BIN $c
					cp "$cartsize/$catnum/$catnum.ROM" "DW2SD/$fname/$catnum.BIN"
					mv "$cartsize/$catnum/$catnum.ROM" "$cartsize/$catnum/$catnum.BIN"

					binname=$(basename "$c")
					decb copy -2 -b -r "$cartsize/$catnum/$catnum.BIN" "$cartsize/$catnum/$catnum.DSK","$catnum.BIN"
					decb copy -2 -b -r "$cartsize/$catnum/$catnum.BIN" "DW2SD/$fname/$catnum.DSK","$catnum.BIN"

				done

			fi



			# if cartridge is 32K (requires flashing 2 16K banks in reverse order)...
			#if [ $filesize -gt 32000 ] && [ $filesize -lt 33000 ]; then
			if [ $filesize -gt 32000 ]; then

				# define cart bank type and total (4K) banks used
 				banktype=34

				# convert hex 0D (carriage return) to 0A (line feed) prior to splitting
				tr '\r' '\n' < "$i"  > "$i.temp"; rm "$i"; mv "$i.temp" "$i"

				# split ROM files over 16K in size
				/usr/bin/split -b 16384 -d "$i" "$cartsize/$catnum/$catnum."

				# DO NOT ADD header/footer to ROM file.  Not required for split files
				for c in $cartsize/$catnum/$catnum.0*; do

					banksused=$((banksused+4))

					binname=$(basename "$c")
					decb copy -1 -a -r "$c" "$cartsize/$catnum/$catnum.DSK","$binname"
					decb copy -1 -a -r "$c" "DW2SD/$fname/$catnum.DSK","$binname"

				done

			fi



			# if cartridge is 64K or over...
			if [ $filesize -gt 64000 ]; then

				# define cart bank type and total (4K) banks used
 				banktype=34

                               # convert hex 0D (carriage return) to 0A (line feed) prior to splitting
                                tr '\r' '\n' < "$i"  > "$i.temp"; rm "$i"; mv "$i.temp" "$i"

				# split ROM files over 16K in size
				/usr/bin/split -b 16384 -d "$i" "$cartsize/$catnum/$catnum."

				# DO NOT ADD header/footer to ROM file. Not required for split files
				for c in $cartsize/$catnum/$catnum.00*; do

					banksused=$((banksused+4))

					binname=$(basename "$c")
					decb copy -1 -a -r "$c" "$cartsize/$catnum/$catnum.DSK","$binname"
					decb copy -1 -a -r "$c" "DW2SD/$fname/$catnum.DSK","$binname"

				done

			fi


			# generate quick report of files
			#echo $counter,\""$fullfilename\"",\""$parentname\"",\""$filename\"",\""$fname\"",$filesize | grep -E '.CCC|.ccc' >> ccflash-report-$1.txt
			#echo $((counter-1))  $fname  $cartsize  $bankno  $banktype >> ccflash-report-$1.txt
			echo CART: $counter  [BANK NO: $bankno]   [BANK TYPE: $banktype]   [BANKS USED: $banksused]   [CART SIZE: $cartsize]   $fname >> ccflash-report-$1.txt

			# generate pyDriveWire script to run that will swap DSK images for each cart to flash
			echo echo Inserting  [  \"$fname\" ]  DSK image >> ccflash-pyDW.sh
			echo echo BANK NO: $bankno   BANK TYPE: $banktype   BANKS USED: $banksused   CART SIZE: $cartsize >> ccflash-pyDW.sh
			echo echo >> ccflash-pyDW.sh
			echo $HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk eject 0 >> ccflash-pyDW.sh
			echo $HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk insert 0 \"/media/share1/DW4/CCFLASH/DW2SD/$fname/$catnum.DSK\" >> ccflash-pyDW.sh
			echo echo >> ccflash-pyDW.sh
			echo read -p  \"Press any key to insert next DSK image...\" -n1 -s >> ccflash-pyDW.sh
			echo echo >> ccflash-pyDW.sh
			echo echo >> ccflash-pyDW.sh
			echo echo >> ccflash-pyDW.sh
			echo >> ccflash-pyDW.sh
			echo >> ccflash-pyDW.sh

			counter=$((counter+1))

			# truncate each cartridge description to 24 characters
			fname16=$(echo $fname | cut -d'(' -f 1)
			fname24=$(echo $fname16 | cut -c1-28)
			fnamemenu=$(echo $fname24 | cut -c 5-)

			# generate BASIC statements for CocoFLASH 'MENU.BAS' program (written by Barry Nelson)
			echo $((counter+10000)) DATA \""$fnamemenu\"",$bankno,$banktype >> DATA.MID

			bankno=$((bankno + banksused))
					banksused=0


		fi

	#fi

done


echo -e
unix2dos ccflash-report-$1.txt
unix2dos DATA.MID
echo -e

# make ccflash-pyDW.sh script executable
chmod a+x ccflash-pyDW.sh


# create new MENU.BAS with all new cartridge entries
cat PRGFLASH/MENU.PRE DATA.MID PRGFLASH/MENU.SUF > PRGFLASH/MENU.BAS
rm DATA.MID

# build new PRGFLASH.DSK image
cd PRGFLASH
makeDSK.sh
cd ..

shopt -u nocaseglob
shopt -u globstar
shopt -u nocasematch

echo Done!
