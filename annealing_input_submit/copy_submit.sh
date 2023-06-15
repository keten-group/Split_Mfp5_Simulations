#!/bin/bash
#SBATCH --job-name="copy_submit.sh"
#SBATCH -A p31412
#SBATCH -p short    ## partition
#SBATCH -N 1  ## number of nodes
#SBATCH -n 1  ## number of cores
#SBATCH --output=R-%x.%j.out
#SBATCH --ntasks-per-node=1  ## number of cores
#SBATCH -t 00:10:00

# This script copies a bash script that can be used to submit each simulation to queue.

declare -a sims=('Nfp5-Cfp5_n24'\
				 'Nfp5_n24' \
				 'Cfp5_n24' \
				 'Cfp5YtoS_n24'\
				 'Nfp5YtoS_n24'\
				 'Cfp5KRtoSS_n24'\
				 'Nfp5-Cfp5YtoS_n24'\
				 'Nfp5-Cfp5KRtoSS_n24'\
				 'Nfp5KRtoSS_n24'\
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
	sed 's$<job_name>$'"${job_name[$i]}"'$g' < submit_annealing_template.sh > submit_annealing.sh

	mv submit_annealing.sh ../${sims[$i]}/annealing
done


