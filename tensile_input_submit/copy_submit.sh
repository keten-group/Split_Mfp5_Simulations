#!/bin/bash
#SBATCH --job-name="copy_submit"
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
				 'fp5_n12'\
				 'Nfp5KRtoSS_n12')

declare -a job_name=('T_n-c'\
				 'T_n-n' \
				 'T_c' \
				 'T_cYtoS'\
				 'T_nYtoS'\
				 'T_cKRtoSS'\
				 'T_n-cYtoS'\
				 'T_n-cKRtoSS'\
				 'T_fp5'\
				 'T_nKRtoSS')

for (( i=0; i<${#sims[@] - 1}; i++ ))
do
	dir=../${sims[$i]}/tensile_test
	sed 's$<job_name>$'"${job_name[$i]}"'$g' < submit_tensile_test_template.sh > submit_tensile_test.sh
	mv submit_tensile_test.sh $dir

done


