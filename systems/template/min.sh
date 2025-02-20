#!/bin/bash

mpirun -n 8 pmemd.MPI -O -i min.in -p PDBID.prmtop -c PDBID.inpcrd -o PDBID_min.out -r PDBID_min.rst -ref PDBID.inpcrd 
mpirun -n 8 pmemd.MPI -O -i min2.in -p PDBID.prmtop -c PDBID_min.rst -o PDBID_min2.out -r PDBID_min2.rst -ref PDBID_min.rst
