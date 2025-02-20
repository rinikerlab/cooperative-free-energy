#!/bin/bash

# antechamber -fi ccif -i SEP_nc.cif -bk SEP -fo ac -o sep.ac -c bcc -at amber -nc 2
# antechamber -fi mol2 -i sep.mol2 -bk SEP -fo ac -o sep.ac -c bcc -at amber -nc -2
prepgen -i sep.ac -o sep.prepin -m sep.mc -rn SEP # modify atom type
parmchk2 -i sep.prepin -f prepi -o frcmod.sep -a Y \
         -p $AMBERHOME/dat/leap/parm/parm19.dat
         
grep -v "ATTN" frcmod.sep > frcmod1.sep # Strip out ATTN lines
parmchk2 -i sep.prepin -f prepi -o frcmod2.sep
