#!/bin/bash

current=$(pwd)
source prepare_functions.sh
mkdir simulations
cd ./simulations/
for i_pdbid in $(seq 0 22 ); do
        pdbid=${ALL[$i_pdbid]}
        mkdir $pdbid
        cd $pdbid
        complex=$pdbid'_ALB'
        # Get intput files
        cp  ../../template/*.in .
        cp  ../../template/*.sh .
        # Modify the restraint residues
        NRES=$(awk ' ($3=="Na+") {print $5-1; exit}' $complex'-2.pdb') # Residue for positional restraints
        for j in *.sh; do sed -i 's/PDBID/'$complex'_wat/g' $j ; done
        for k in *.in; do sed -i 's/NRES/'$NRES'/g'      $k ; done  
        echo $complex $NRES
        bash min.sh
	bash pro.sh
        cd $current/simulations/
done                   
