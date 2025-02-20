import numpy as np
import os
import sys
import re

PDB_file = sys.argv[1]
special_residue = sys.argv[2]

proff='ff19SB'
watff='opc'


# Pattern for reading water number
f = open('leap.log').read()
pattern = re.compile(r'Added (?P<water>\d+) residues')
matches = [match.group('water') for match in re.finditer(pattern,f)]
Nion = round(0.0187*int(matches[-1])*0.15)
print(Nion)

# calculate how many water molecules are added
leap1_name = ''.join([PDB_file,'_2.in'])

with open(leap1_name,'w') as write:
    print(''.join(['source leaprc.protein.',proff]),end='\n',file=write)
    print(''.join(['source leaprc.water.',watff]),end='\n',file=write)
    print(''.join(['m=loadpdb ',PDB_file,'-1.pdb']),end='\n',file=write)
    if special_residue:
        print('loadAmberPrep ../../ALB_pdbs/special_residue/'+special_residue+'.prepin',end='\n',file=write)
        print('loadAmberParams ../../ALB_pdbs/special_residue/frcmod2.'+special_residue,end='\n',file=write)
        print('loadAmberParams ../../ALB_pdbs/special_residue/frcmod1.'+special_residue,end='\n',file=write)
    print(''.join(['solvateBox m ',watff.upper(),'BOX 12.5']),end='\n',file=write)
    print(''.join(['addIonsRand m Na+ ',str(Nion),' Cl- ',str(Nion)]),end='\n',file=write)
    print('addIons m Na+ 0',end='\n',file=write)
    print('addIons m Cl- 0',end='\n',file=write)
    print(''.join(['savepdb m ',PDB_file,'-2.pdb']),end='\n',file=write)
    print(''.join(['saveAmberParm m ',PDB_file,'.prmtop ',PDB_file,'.inpcrd']),end='\n',file=write)
    print('quit',end='',file=write)

