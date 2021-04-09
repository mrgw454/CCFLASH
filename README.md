# CCFLASH
Script for processing cartridges from TRS-80 Color Computer Archive and prepping them for use with CocoFLASH

Linux (bash) is required to run this script.

More information about the CocoFLASH can be found here:

http://www.go4retro.com/products/cocoflash/


github repo for original CocoFLASH software can be found here:

https://github.com/go4retro/CocoFLASH


TRS-80 Color Computer Archive (cartridge files):

http://www.colorcomputerarchive.com/coco/Cartridges/


Not required, but HIGHLY recommended is Michael Furman's pyDriveWire (to help with automation).

https://github.com/n6il/pyDriveWire



INSTRUCTIONS:

Use git pull to download all files into their own folder using the following command:

https://github.com/mrgw454/CCFLASH.git


Download all/any cartridge files you want (such as from the TRS-80 Color Computer Archive) and place them into a sub-folder (such as 'cca').  The filename suffix for the cartridges should be *.ccc.

All cartridge files need to be ROM based, not binary.  This means the normal cartridge BIN preamble and footer should not be present.


Once you have all the cartridges files you wish to process, you are ready to run the scripts.  We are using a folder called 'cca' for this example.

./sort-carts.sh cca

A new folder will be created called 'cca-sorted.'  This will contain a copy of all the cartridges, renamed by ROM size and then alphabetically.  This is important when we perform the final processing.

./process-carts.sh cca-sorted

This will process all the 'renamed/sorted' cartridges.  When complete you should see new top level folders based on cartridge size (i.e. 4.0K, 8.0K, 16K, etc.).  Inside of those folders will be processed cartridge files (converted from ROM to BIN) and
placed individually into folders with the proper Radio Shack catalog number (26-xxxx).

Each cartridge will have it's BIN(s) copied to it's own DSK image (using the catalog number as the filename).  In addition, the proper flashing utilities will be included on each DSK image (for flashing directly on a Coco to the CoCoFLASH).
Each DSK image will also have an HDBDOS/YA-DOS volume label using the full cartridge description from the cartrdige filename (in the cca/cca-sorted folders).


A new PRGFLASH/MENU.BAS will be created and it will include all the matching DATA statements for each processed cartridge.  This will be used as the Cartridge Selection Menu when you use the CoCoFLASH.

You will also find a 'ccflash-report-cca-sorted.txt' report.  An example looks like this:

CART: 1 [BANK NO: 12] [BANK TYPE: 2] [BANKS USED: 1] [CART SIZE: 2.0K] 002 Audio Spectrum Analyzer (1981) (26-3156) (Steve Bjork) [!]
CART: 2 [BANK NO: 13] [BANK TYPE: 2] [BANKS USED: 1] [CART SIZE: 2.0K] 002 Diagnostics (1980) (26-3019) (Tandy) [!]
CART: 3 [BANK NO: 14] [BANK TYPE: 2] [BANKS USED: 1] [CART SIZE: 2.0K] 002 Diagnostics V2.0 (1982) (26-3019) (Tandy)
CART: 4 [BANK NO: 15] [BANK TYPE: 2] [BANKS USED: 1] [CART SIZE: 2.0K] 002 Videotex V1.2 (1981) (26-2222) (Tandy) [!]
CART: 5 [BANK NO: 16] [BANK TYPE: 2] [BANKS USED: 1] [CART SIZE: 4.0K] 004 Art Gallery (1981) (26-3061) (Robert G. Kilgus) [!]
CART: 6 [BANK NO: 17] [BANK TYPE: 2] [BANKS USED: 1] [CART SIZE: 4.0K] 004 Bingo Math (1980) (26-3150) (Tandy) [!]
CART: 7 [BANK NO: 18] [BANK TYPE: 2] [BANKS USED: 1] [CART SIZE: 4.0K] 004 Bustout (1981) (26-3056) (Tandy) [!]
CART: 8 [BANK NO: 19] [BANK TYPE: 2] [BANKS USED: 1] [CART SIZE: 4.0K] 004 Castle Guard (1981) (26-3079) (The Image Producers) [!]
CART: 9 [BANK NO: 20] [BANK TYPE: 2] [BANKS USED: 1] [CART SIZE: 4.0K] 004 Checker King (1980) (26-3055) (Personal Software)


Finally, you will see a new script called 'ccflash-pyDW.sh' which will be used with pyDriveWire to help provide DSK image swapping when performing the flashing/programming of the CoCoFLASH.  


This is still a work in progress.  Eventally, I plan to a develop a way to create a single, flashable file (based on a compilation of ROMs) which can be programmed into the CocoFLASH.  Video tutorial will be coming soon.





