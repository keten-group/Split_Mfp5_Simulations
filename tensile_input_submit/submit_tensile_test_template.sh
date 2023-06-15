#!/bin/bash
#SBATCH --job-name="<job_name>"
#SBATCH -A p31412
#SBATCH -p short    ## partition
#SBATCH -N 1  ## number of nodes
#SBATCH -n 28  ## number of cores
#SBATCH --output=R-%x.%j.out
#SBATCH --ntasks-per-node=28  ## number of cores
#SBATCH --mem-per-cpu=1G
#SBATCH -t 00:05:00

# This script submits a lammps simulation and organizes the output files automatically into the directory ../tensile_test_out.
module purge all
module load lammps/20200303-openmpi-4.0.5-intel-19.0.5.281

dir=../tensile_test_out
if [ ! -d "$dir" ];then
	mpirun -np 28 lmp -in tensile_test.in -log lammps.log
	mkdir $dir
	### Organize Directories ###
	mv R-* *.dcd *_end.data *_10ns.restart *.log *.txt $dir
	cp 7_T300_P1.data $dir
else
	echo "Directory ${dir} already exists."
fi