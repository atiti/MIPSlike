#!/bin/bash

cd assembler/
FEXT=`echo "$1" |awk -F . '{print $NF}'`
FNAME=`echo "$1" |sed "s/\.$FEXT//g"`
if [ "$FEXT" = "c" ]; then
	echo "Compiling C code..."
	mipsel-unknown-linux-gnu-gcc -S -fomit-frame-pointer -mips1 $1
	if [ "$?" != "0" ]; then
		echo "Error during compilation.";
		exit;
	fi;	
fi;

RES="$FNAME.s"
echo "Bootstrapping compiled $FNAME.s ..."
./bootstrap.sh $RES
echo "Assembling code into hex ..."
./assembler $RES.hex
cd ..
echo "Building ROM.vhd..."
#python ROMmaker/rommaker.py assembler/outputFile VHDL/MIPSlike/ROM.vhd
python ROMmaker/rommakerv2.py assembler/outputFile VHDL/MIPSlike/ROMv2.vhd
echo "Done."
