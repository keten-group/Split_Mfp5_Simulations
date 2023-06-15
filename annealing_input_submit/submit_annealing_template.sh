#!/bin/bash
#SBATCH --job-name="<job_name>"
#SBATCH -A p31412
#SBATCH -p short    ## partition
#SBATCH -N 1  ## number of nodes
#SBATCH -n 28  ## number of cores
#SBATCH --output=R-%x.%j.out
#SBATCH --ntasks-per-node=28  ## number of cores
#SBATCH -t 00:10:00

# This script submits a lammps simulation and organizes the output files into directory ../annealing_out.

module purge all
module load lammps/20200303-openmpi-4.0.5-intel-19.0.5.281 # Change this.

dir=../annealing_out
struc_name=ionized
if [ ! -d "$dir" ];then
	mpirun -np 28 lmp -in annealing.in -log network.log
	mkdir $dir
	mv *density* minimized* network.log *_T* $dir
	cp $struc_name* annealing.in submit_annealing.sh $dir
	mv R-*.out ./$dir
else
	echo "Directory ${dir} already exists."
fi