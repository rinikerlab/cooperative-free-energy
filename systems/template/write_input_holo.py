import numpy as np
import os
import sys
import re
import argparse

# Set up argument parser
parser = argparse.ArgumentParser(description="Generate input files for AMBER.")
parser.add_argument("-id", "--pdbid", required=True, help="PDB ID")
parser.add_argument("-c", "--complex", required=True, help="Complex name")
parser.add_argument("-sr", "--special_residue", nargs='+', help="Special residue names", default=[])
parser.add_argument("--proff", default='ff19SB', help="Protein force field")
parser.add_argument("--watff", default='opc', help="Water force field")

args = parser.parse_args()

PDBID = args.pdbid
COMPLEX = args.complex
special_residues = args.special_residue
proff = args.proff
watff = args.watff
LIG = f'../../ALB_pdbs/Ligands/{PDBID}_gaff2'

# calculate how many water molecules are added
leap1_name = ''.join([COMPLEX,'_1.in'])

with open(leap1_name, 'w') as write:
    print('source leaprc.gaff2', end='\n', file=write)
    print(f'source leaprc.protein.{proff}', end='\n', file=write)
    print(f'source leaprc.water.{watff}', end='\n', file=write)
    for special_residue in special_residues:
        print(f'loadAmberPrep ../../ALB_pdbs/special_residue/{special_residue}.prepin', end='\n', file=write)
        print(f'loadAmberParams ../../ALB_pdbs/special_residue/frcmod2.{special_residue}', end='\n', file=write)
        print(f'loadAmberParams ../../ALB_pdbs/special_residue/frcmod1.{special_residue}', end='\n', file=write)
    print(f'loadamberparams {LIG}.frcmod', end='\n', file=write)
    print(f'loadoff {LIG}.lib', end='\n', file=write)
    print(f'm=loadpdb {COMPLEX}_amber.pdb', end='\n', file=write)
    print(f'savepdb m {COMPLEX}-1.pdb', end='\n', file=write)
    print(f'solvateBox m {watff.upper()}BOX 12.5', end='\n', file=write)
    print('quit', end='', file=write)

