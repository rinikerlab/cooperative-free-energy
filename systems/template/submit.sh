#!/bin/bash
#SBATCH --job-name=PDBID_HF
#SBATCH --nodes=1
# BATCH --ntasks-per-node=1
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=1
#SBATCH --partition=barracuda
#SBATCH --gres=gpu:0
# BATCH --constraint="gtx1080ti|gtx1080"
# BATCH -w cuda-node020
# BATCH --exclusive
#SBATCH --time="3-0"
#SBATCH --mail-user="ge56gid@mytum.de"
#SBATCH --mail-type=BEGIN,END 



ml load orca
ml load openmpi/4.0.1

# Setting OPENMPI paths
which mpirun
export PATH=$PATH:/apps/gcc-6.3.0/openmpi/4.0.1/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/apps/gcc-6.3.0/openmpi/4.0.1/lib


export orcadir=/apps/orca/4.2.1/orca_4_2_1_linux_x86-64_openmpi314/

#$orcadir/orca opt2.in > ID_opt2.out
$orcadir/orca HF.in > PDBID_HF.out
