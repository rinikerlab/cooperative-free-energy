#!/bin/bash -l
#SBATCH --job-name=mmgbsa-XXX-RUN-COMPLEX
#SBATCH --nodes=1
# BATCH --ntasks-per-node=1
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=1
#SBATCH --time="1-0"
#SBATCH --mem-per-cpu=4G


module load gcc/8.2.0    # to make consistent with Franz's plumed
module load cmake/3.16.5
module load openmpi/4.1.4

source /cluster/project/igc/shuyu/software/amber22/amber.sh

# Object variables
run=RUN
complex=COMPLEX


# I/O variables
prm=../../../XXX/$complex'_mbondi2.prmtop'
nc=../../../XXX/$complex'_'$run'.nc'
output=./$complex'_output'$run
echo $prm $nc $output


# MPI1
if [ ! -f $output.dat ]; then
	mpirun -np 8 MMPBSA.py.MPI -i ../../../template/mmgbsa.in -y $nc -cp $prm -sp $prm -o $output.dat -eo $output.csv 
fi


