import numpy as np
import os
import sys

PDB_file = sys.argv[1]
proff='ff19SB'
watff='opc'


# calculate how many water molecules are added
leap1_name = ''.join([PDB_file.split('.')[0],'_1.in'])

with open(leap1_name,'w') as write:
    print(''.join(['source leaprc.protein.',proff]),end='\n',file=write)
    print(''.join(['source leaprc.water.',watff]),end='\n',file=write)
    print(''.join(['m=loadpdb ',PDB_file,'_amber.pdb']),end='\n',file=write)
    print(''.join(['savepdb m ',PDB_file,'-1.pdb']),end='\n',file=write)
    print(''.join(['solvateBox m ',watff.upper(),'BOX 12.5']),end='\n',file=write)
    print('quit',end='',file=write)
