#!/bin/bash

# antechamber -fi ccif -i cso_nc.cif -bk cso -fo ac -o cso.ac -c bcc -at amber -nc 2
# antechamber -fi mol2 -i cso.mol2 -bk cso -fo ac -o cso.ac -c bcc -at amber -nc 0
prepgen -i cso.ac -o cso.prepin -m cso.mc -rn CSO # CA type XC, HA type H1, N type N, O type O, see $AMBERHOME/dat/leap/prep/amino12.in 
parmchk2 -i cso.prepin -f prepi -o frcmod.cso -a Y -p $AMBERHOME/dat/leap/parm/parm10.dat
         
grep -v "ATTN" frcmod.cso > frcmod1.cso # Strip out ATTN lines
parmchk2 -i cso.prepin -f prepi -o frcmod2.cso
