# create empty hard drive image for use with YA-DOS

# old way
#dd bs=256 of=CCFLASH.dsk count=322562

# new way
truncate -s 32M CCFLASH.DSK
