#!/bin/bash
#SBATCH --job-name="simGen"
#SBATCH -A p31412
#SBATCH -p normal    ## partition
#SBATCH -N 1  ## number of nodes
#SBATCH -n 1  ## number of cores
#SBATCH --output=R-%x.%j.out
#SBATCH -t 48:00:00

module purge all

# The array sims indicates which chain species are present in a system and is used to as the directory
# name of each simulation. If two types are connected by a hyphen,
# it means that there is an equal molar fraction each chain type (Nfp5 or Cfp5) in each system. If there is only one
# chain type listed, then that system is a homogeneous melt of chains of that type. If 'YtoS' or
# 'KRtoSS' are appended to a chain type, it means that tyrosine (Y) or lysine (K) and arginine (R) residues are 
# mutated to serine (S) for that chain type. These mutations are reflected by the sequences listed in
# arrays chain_A and chain_B.
declare -a sims=('Nfp5-Cfp5'\
				 'Nfp5' \
				 'Cfp5' \
				 'Cfp5YtoS'\
				 'Nfp5YtoS'\
				 'Cfp5KRtoSS'\
				 'Nfp5-Cfp5YtoS'\
				 'Nfp5-Cfp5KRtoSS'\
				 'Nfp5KRtoSS'\
				 'fp5')

# The array chain_A lists the primary sequence of one half of the protein chains
# in the system defined by the corresponding position in array sims. Each letter
# represents a single common amino acid.

declare -a chain_A=('SEEYKGGYYPGNTYHYHSGGSYHGSGYHGGYKGKYY'\
					   'SEEYKGGYYPGNTYHYHSGGSYHGSGYHGGYKGKYY'\
					   'KAKKYYYKYKNSGKYKYLKKARKYHRKGYKKYYGGGSS'\
					   'KAKKSSSKSKNSGKSKSLKKARKSHRKGSKKSSGGGSS'\
					   'SEESKGGSSPGNTSHSHSGGSSHGSGSHGGSKGKSS'\
					   'SASSYYYSYSNSGSYSYLSSASSYHSSGYSSYYGGGSS'\
					   'SEESKGGSSPGNTSHSHSGGSSHGSGSHGGSKGKSS'\
					   'SEEYSGGYYPGNTYHYHSGGSYHGSGYHGGYSGSYY'\
					   'SEEYSGGYYPGNTYHYHSGGSYHGSGYHGGYSGSYY'\
					   'SEEYKGGYYPGNTYHYHSGGSYHGSGYHGGYKGKYYKAKKYYYKYKNSGKYKYLKKARKYHRKGYKKYYGGGSS')

# The array chain_B lists the primary sequence of one half of the protein chains
# in the system defined by the corresponding position in array sims. Each letter
# represents a single common amino acid.

declare -a chain_B=('KAKKYYYKYKNSGKYKYLKKARKYHRKGYKKYYGGGSS'\
						'SEEYKGGYYPGNTYHYHSGGSYHGSGYHGGYKGKYY' \
						'KAKKYYYKYKNSGKYKYLKKARKYHRKGYKKYYGGGSS' \
						'KAKKSSSKSKNSGKSKSLKKARKSHRKGSKKSSGGGSS' \
						'SEESKGGSSPGNTSHSHSGGSSHGSGSHGGSKGKSS'\
						'SASSYYYSYSNSGSYSYLSSASSYHSSGYSSYYGGGSS'\
						'KAKKSSSKSKNSGKSKSLKKARKSHRKGSKKSSGGGSS'\
						'SASSYYYSYSNSGSYSYLSSASSYHSSGYSSYYGGGSS'\
						'SEEYSGGYYPGNTYHYHSGGSYHGSGYHGGYSGSYY'
						'SEEYKGGYYPGNTYHYHSGGSYHGSGYHGGYKGKYYKAKKYYYKYKNSGKYKYLKKARKYHRKGYKKYYGGGSS')

# The array charge lists the net charge on all protein in the system defined
# by the corresponding position in array sims. This is also equal to the 
# number of chlorides added to neutralize charge.

declare -a charge=(192 \
				   24 \
				   360 \
				   360 \
				   24 \
				   0 \
				   192 \
				   0 \
				   0 \
				   192)

# The array numWaters lists the number of water molecules necessary to generate
# a melt that is 10% water by weight for the system defined by the corresponding
# position in array sims.

declare -a numWaters=(602 \
					  545 \
					  660 \
					  558 \
					  444 \
					  534 \
					  480 \
					  529 \
					  525 \
					  602)

mkdir ../split_fp_simulations
for ((i=0 ; i<${#sims[@] -1} ; i++))
do
	#################### Routine to create one simulation ###################

	# Make a directory where all files specific to this simulation will be stored.
	dir=${sims[$i]}_n12
	mkdir ../split_fp_simulations/$dir

	# Assign the two chain types from chain_A and chain_B for the current iteration to variables for use later.
	seq_A=${chain_A[$i]}
	seq_B=${chain_B[$i]}

	# Make a temporary prefix to name pdb files for individual chains generated later.
	pdb_A='xfp5_A'
	pdb_B='xfp5_B'
	if [${sims[$i]} = 'fp5']
	then
		N=6 # For full length fp5, only add half as many chains.
	else
		N=12 # The number of duplicates of chain type from chain_A and from chain_B to be added to one simulation.
	fi


	# Generate N random chain configurations for chaintypes seq_A and seq_B. 
	module load python/anaconda3.6
	source activate /projects/p31412/Mfp_Brushes/envs/fga_mfp # Load necessary conda environment to run script 'multiLooseChainGenerator.py'
	python multiLooseChainGenerator.py -n $N -o_filename $pdb_A -seq $seq_A -o_path .
	python multiLooseChainGenerator.py -n $N -o_filename $pdb_B -seq $seq_B -o_path .

	# Pack all resulting protein structures, water molecules, and chloride into a box using Packmol.
	touch pack1_chains.inp 
	printf "# pack each individual chain together\ntolerance 2.0\noutput chains_packed.pdb\nfiletype pdb\nmaxit 20\n" >> pack1_chains.inp

	for ((c=1; c<=$N ; c++))
	do
		printf " \n\nstructure ${pdb_A}${c}.pdb\n    number 1\n    inside cube 0. 0. 0. 250\nend structure" >> pack1_chains.inp
		printf " \n\nstructure ${pdb_B}${c}.pdb\n    number 1\n    inside cube 0. 0. 0. 250\nend structure" >> pack1_chains.inp
	done

	if [ ${charge[$i]} != 0 ]
	then
		# https://ryanstutorials.net/bash-scripting-tutorial/bash-if-statements.php
		printf " \n\nstructure chloride.pdb\n    number ${charge[$i]}\n    inside cube 0. 0. 0. 250\nend structure" >> pack1_chains.inp
	fi
	printf " \n\nstructure water.pdb\n    number ${numWaters[$i]}\n    inside cube 0. 0. 0. 250\nend structure" >> pack1_chains.inp

	/home/jjg9482/packmol/packmol < pack1_chains.inp # Run Packmol executable with input script 'pack1_chains.inp'

	# Perform PSFGEN to generate pdb/psf/pqr files
	python splitpdbforpsfgen-addsegID.py # Execute python script that splits the structure 'chains_packed.pdb' into individual chains and water/ions.
										 # in preparation for VMD psfgen plugin.
	psfgen_out='xfp5_melt'
	sed 's$<psfgen_out>$'"$psfgen_out"'$g' < psfgen.tcl > psfgen_temp1.tcl
	sed 's$<N>$'"$(($N*2))"'$g' < psfgen_temp1.tcl > psfgen_temp.tcl
	rm psfgen_temp1.tcl
	module load vmd
	vmd -dispdev text -e psfgen_temp.tcl

	### Convert pdb and psf from psfgen to lammps datafile using charmm2lammps.pl script.
	mv ionized_noTER.pdb ionized.psf charmm2lammps_all36_tip3
	cd charmm2lammps_all36_tip3
	python addTER.py -i ionized_noTER.pdb -o ionized.pdb # Add TER line after the end of each segment (individual chain, water, ions)
														 # to prep for charmm2lammps.pl.
	perl charmm2lammps.pl -cmap=36 all36_prot_C2L_TIP3_OH_CLA ionized # Execute charmm2lammps.pl script.

	# Reorganize Directories (necessary to avoid file overwrite)
	mkdir ../../split_fp_simulations/$dir/annealing
	mv ionized.pdb ionized.psf ionized.data ../../split_fp_simulations/$dir/annealing
	mkdir ../../split_fp_simulations/$dir/temp_files
	mv ionized* ../../split_fp_simulations/$dir/temp_files
	cd ..
	mv ionized.pqr pack1_chains.inp melt* *temp.tcl xfp5_* chains_packed.pdb ../split_fp_simulations/$dir/temp_files
done
mv R-* ../split_fp_simulations/
cp -r annealing_input_submit ../split_fp_simulations
cp -r tensile_input_submit ../split_fp_simulations
######### END ##########
