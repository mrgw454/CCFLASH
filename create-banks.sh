# if previous sector bucket folder exists, purge it
if [ -d "$1-banks" ]; then
        rm -r "$1-banks"
fi


# create new sector bucket folder
if [ ! -d "$1-banks" ]; then
	mkdir "$1-banks"
fi

counter=12

cd "$1-banks"

# create 134 sector buckets
for i in {8..134}
do
	sa=$(printf "%03d" $i)
	echo Creating sector bucket: sa$sa
	mkdir sa$sa
	cd sa$sa

		# create 16 banks within each sector bucket
		for b in  {1..16}
		do

			bank=$(printf "%04d" $counter)
			echo "   bank$bank"
			mkdir bank$bank
			counter=$((counter+1))

		done

cd ..

done
