#!/bin/bash

current=$(pwd)
source ../../prepare_functions.sh

for lig in ${ALL[@]}; do
	echo $lig
	original_mol2=$lig'_L_fixed.mol2'
	gaff2_mol2=$lig'_gaff2.mol2'
	gaff2_frc=$lig'_gaff2.frcmod'
	gaff2_lib=$lig'_gaff2.lib'
	
	# Parameterization
	# nc=-1 for 4mdk, 5j8o, 3m51
	# nc=+1 for 5fqd
	
	antechamber -i $original_mol2 -at gaff2 -c bcc -fi mol2 -fo mol2 -o $gaff2_mol2 -rn LIG 
	parmchk2 -i $gaff2_mol2 -f mol2 -o $gaff2_frc
	
	# generate corresponding atom names
	cp ./ligand_template leap.in
	sed -i 's/XXX/'$lig'/g' leap.in
	tleap -f leap.in
	
	sed -i 's/'$lig'/LIG/g' $gaff2_lib
	
done


