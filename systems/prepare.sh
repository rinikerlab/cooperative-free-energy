#!/bin/bash

# Variables 
source prepare_functions.sh
current=$(pwd)
PDB_dir=$current/ALB_pdbs
mkdir ./simulations
cd $current/simulations

for i_pdbid in $(seq 0 22) ; do
	pdbid=${ALL[$i_pdbid]}
	echo $pdbid
	mkdir $pdbid
	cd $pdbid
	prepare_trimer $pdbid
	cd $current/simulations
done


rm */*_renum.txt
rm */*_amber_sslink
rm */*_amber_nonprot.pdb
