#!/bin/bash
#SBATCH --job-name="copy_lmp.in"
#SBATCH -A p31412
#SBATCH -p short    ## partition
#SBATCH -N 1  ## number of nodes
#SBATCH -n 1  ## number of cores
#SBATCH --output=R-%x.%j.out
#SBATCH --ntasks-per-node=1  ## number of cores
#SBATCH -t 00:10:00

# This script adds the proper oxygen and hydrogen atom types to lammps input template file to run fix shake and copies it into each annealing directory.

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

declare -a HT_type=(33 \
					32 \
					28 \
					26 \
					30 \
					27 \
					31 \
					32 \
					32 \
					33)

declare -a OT_type=(34 \
					33 \
					29 \
					27 \
					31 \
					28 \
					32 \
					33 \
					33 \
					34)

declare -a HH_shake_bondtype=(58 \
						   54 \
						   43 \
						   39 \
						   50 \
						   38 \
						   54 \
						   53 \
						   52 \
						   58)

declare -a OH_shake_bondtype=(59 \
						   55 \
						   44 \
						   40 \
						   51 \
						   39 \
						   55 \
						   54 \
						   53 \
						   59)

for (( i=0; i<${#sims[@] - 1}; i++ ))
do
	sed 's$<OH_shake_bondtype>$'"${OH_shake_bondtype[$i]}"'$g' < annealing_template.in > annealing_temp1.in
	sed 's$<HT_type>$'"${HT_type[$i]}"'$g' < annealing_temp1.in > annealing_temp2.in
	sed 's$<OT_type>$'"${OT_type[$i]}"'$g' < annealing_temp2.in > annealing_temp3.in
	sed 's$<HH_shake_bondtype>$'"${HH_shake_bondtype[$i]}"'$g' < annealing_temp3.in > annealing.in

	rm annealing_temp1.in annealing_temp2.in annealing_temp3.in
	mv annealing.in ../${sims[$i]}/annealing
done


