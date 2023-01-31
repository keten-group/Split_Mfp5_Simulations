#!/bin/bash
#SBATCH --job-name="copy_submit.sh"
#SBATCH -A p31412
#SBATCH -p short    ## partition
#SBATCH -N 1  ## number of nodes
#SBATCH -n 1  ## number of cores
#SBATCH --output=R-%x.%j.out
#SBATCH --ntasks-per-node=1  ## number of cores
#SBATCH -t 00:10:00

## cd $PBS_O_WORKDIR
declare -a sims=('Nfp5-Cfp5_n12'\
				 'Nfp5_n12' \
				 'Cfp5_n12' \
				 'Cfp5YtoS_n12'\
				 'Nfp5YtoS_n12'\
				 'Cfp5KRtoSS_n12'\
				 'Nfp5-Cfp5YtoS_n12'\
				 'Nfp5-Cfp5KRtoSS_n12'\
				 'Nfp5KRtoSS_n12'\
				 'fp5_n12')

declare -a job_name=('n-c'\
					 'n'\
					 'c'\
					 'cYtoS'\
					 'nYtoS'\
					 'cKRtoSS'\
					 'n-cYtoS'\
					 'n-cKRtoSS'\
					 'nKRtoSS'\
					 'fp5')

for (( i=0; i<${#sims[@] - 1}; i++ ))
do
	sed 's$<job_name>$'"${job_name[$i]}"'$g' < submitLAMMPSannealing_template.sh > submitLAMMPSannealing.sh

	mv submitLAMMPSannealing.sh ../${sims[$i]}/annealing
done


