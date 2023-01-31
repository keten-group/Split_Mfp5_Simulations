#!/bin/bash
#SBATCH --job-name="copy_lmp.in"
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

declare -a HT_type=(33 \
					32 \
					28 \
					26 \
					30 \
					27 \
					31 \
					32 \
					33 \
					32)

declare -a OT_type=(34 \
					33 \
					29 \
					27 \
					31 \
					28 \
					32 \
					33 \
					34 \
					33)

declare -a HH_shake_bondtype=(58 \
						   55 \
						   43 \
						   39 \
						   51 \
						   38 \
						   54 \
						   53 \
						   58 \
						   53)

declare -a OH_shake_bondtype=(59 \
						   56 \
						   44 \
						   40 \
						   52 \
						   39 \
						   55 \
						   54 \
						   59 \
						   54)

for (( i=0; i<${#sims[@] - 1}; i++ ))
do
	tensile_test=../${sims[$i]}/tensile_test
	[ !  -d "$tensile_test" ] && mkdir -p "$tensile_test"

	sed 's$<OH_shake_bondtype>$'"${OH_shake_bondtype[$i]}"'$g' < tensile_test_template.in > tensile_test_temp1.in
	sed 's$<HT_type>$'"${HT_type[$i]}"'$g' < tensile_test_temp1.in > tensile_test_temp2.in
	sed 's$<OT_type>$'"${OT_type[$i]}"'$g' < tensile_test_temp2.in > tensile_test_temp3.in
	sed 's$<HH_shake_bondtype>$'"${HH_shake_bondtype[$i]}"'$g' < tensile_test_temp3.in > tensile_test.in


	rm tensile_test_temp1.in tensile_test_temp2.in tensile_test_temp3.in
	mv tensile_test.in $tensile_test
	echo $i
	annealing_out=../${sims[$i]}/annealing_out
	[ -d "$annealing_out" ] && cp ${annealing_out}/7_T300_P1.data $tensile_test

done


