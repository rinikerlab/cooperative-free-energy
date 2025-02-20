#!/bin/bash

c=1
while [ $c -lt 10 ]
do
pmemd.cuda -O -i eq1.in -p PDBID.prmtop -c PDBID_min2.rst -o PDBID_$c'_eq'1.out -r PDBID_$c'_eq'1.rst -ref PDBID_min2.rst -x eq1.nc
pmemd.cuda -O -i eq2.in -p PDBID.prmtop -c PDBID_$c'_eq'1.rst -o PDBID_$c'_eq'2.out -r PDBID_$c'_eq'2.rst -ref PDBID_$c'_eq'1.rst -x eq2.nc
pmemd.cuda -O -i eq3.in -p PDBID.prmtop -c PDBID_$c'_eq'2.rst -o PDBID_$c'_eq'3.out -r PDBID_$c'_eq'3.rst -ref PDBID_$c'_eq'2.rst -x eq3.nc
pmemd.cuda -O -i eq4.in -p PDBID.prmtop -c PDBID_$c'_eq'3.rst -o PDBID_$c'_eq'4.out -r PDBID_$c'_eq'4.rst -ref PDBID_$c'_eq'3.rst -x eq4.nc
pmemd.cuda -O -i eq5.in -p PDBID.prmtop -c PDBID_$c'_eq'4.rst -o PDBID_$c'_eq'5.out -r PDBID_$c'_eq'5.rst -ref PDBID_$c'_eq'4.rst -x eq5.nc
pmemd.cuda -O -i eq6.in -p PDBID.prmtop -c PDBID_$c'_eq'5.rst -o PDBID_$c'_eq'6.out -r PDBID_$c'_eq'6.rst -ref PDBID_$c'_eq'5.rst -x eq6.nc

pmemd.cuda -O -i mdh_10ns.in -p PDBID.prmtop -c PDBID_$c'_eq'6.rst -o PDBID_prod$c.out -r PDBID_prod$c.rst -ref PDBID_$c'_eq'6.rst -x PDBID_prod$c.nc
let c=c+1
done                                     
