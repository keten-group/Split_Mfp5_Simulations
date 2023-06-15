#!/bin/bash
#SBATCH --job-name="submit all tensile"
#SBATCH -A p31412
#SBATCH -p short    ## partition
#SBATCH -N 1  ## number of nodes
#SBATCH -n 1  ## number of cores
#SBATCH --output=R-%x.%j.out
#SBATCH --ntasks-per-node=1  ## number of cores
#SBATCH -t 00:01:00

# This script submits all tensile testing simulations at once.

cd Cfp5_n24/tensile_test
sbatch submit_tensile_test.sh

cd ../../Cfp5KRtoSS_n24/tensile_test
sbatch submit_tensile_test.sh

cd ../../Cfp5YtoS_n24/tensile_test
sbatch submit_tensile_test.sh

cd ../../fp5_n12/tensile_test
sbatch submit_tensile_test.sh

cd ../../Nfp5-Cfp5_n24/tensile_test
sbatch submit_tensile_test.sh

cd ../../Nfp5-Cfp5KRtoSS_n24/tensile_test
sbatch submit_tensile_test.sh

cd ../../Nfp5-Cfp5YtoS_n24/tensile_test
sbatch submit_tensile_test.sh

cd ../../Nfp5_n24/tensile_test
sbatch submit_tensile_test.sh

cd ../../Nfp5KRtoSS_n24/tensile_test
sbatch submit_tensile_test.sh

cd ../../Nfp5YtoS_n24/tensile_test
sbatch submit_tensile_test.sh

