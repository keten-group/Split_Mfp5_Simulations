#!/bin/bash
#SBATCH --job-name="<job_name>"
#SBATCH -A p31412
#SBATCH -p long    ## partition
#SBATCH -N 4  ## number of nodes
#SBATCH -n 112  ## number of cores
#SBATCH --output=R-%x.%j.out
#SBATCH --ntasks-per-node=28  ## number of cores
#SBATCH --mem-per-cpu=1G
#SBATCH -t 168:00:00

## cd $PBS_O_WORKDIR
module purge all
module load lammps/20200303-openmpi-4.0.5-intel-19.0.5.281

dir=../tensile_test_out
if [ ! -d "$dir" ];then
	mpirun -np 112 lmp -in tensile_test.in -log lammps.log
	mkdir $dir
	### Organize Directories ###
	mv R-* *.dcd *_end.data *_10ns.restart *.compute *.log *.txt $dir
	cp 7_T300_P1.data $dir
else
	echo "Directory ${dir} already exists."
fi