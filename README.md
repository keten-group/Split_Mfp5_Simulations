<!-- For developers:
Please use bold font for file names, directories, and file paths.
Please use italic font for variables.
Follow heading styles.
# First-level heading
## Second-level heading
### Third-level heading
See https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax for formatting syntax.
-->

# Split Mfp5 Simulations
Instructions to generate and run simulations presented in J. Graham and S. Keten "Increase in charge and density improves strength and toughness of mfp5 inspired protein materials" ACS Biomaterials Science and Engineering 2023

If you use this tool, please cite the above paper.

## Employed Software Version Histories:

- LAMMPS version used is from March 3, 2020 downloadable here: https://download.lammps.org/tars/index.html

- Packmol version 20.1.1 was used. Download and instructions for Packmol can be found here: https://m3g.github.io/packmol/

- Conda version 4.10.3

- Anaconda version 4.3.0

- Python version 3.6.0

- VMD version 1.9.3

- perl v5.16.3

- GNU Bash, version 4.2.46(2)-release (x86_64-redhat-linux-gnu)

## File Descriptions:

### In main directory generate_paper_simulations

- **addsegID.py** - Adds a particular segment ID and chain ID to an existing pdb of a single chain. This is necessary to use the VMD psfgen plugin.

- **chloride.pdb** - PDB file for a chloride ion with arbitrary coordinates assigned.

- **fga_fp5.yml** - Conda .yml file, which can be used to create an environment compatible with scripts written for this project.

- **multiLooseChainGenerator.py** - Takes as input a text file with no spaces made up of the one letter shorthand for common amino acids and generates a pdb for a linear protein chain with random dihedral angles restricted between 120 and 240 degrees.

- **psfgen.tcl** - Generates psf, pdb, and per files of the protein melt system with all protein, water, and ions using VMD's psfgen plugin.

- **sodium.pdb** - PDB file for a sodium ion with arbitrary coordinates assigned.

- **splitpdbforpsfgen-addsegID.py** - Splits the pdb file entitled 'chains_packed.pdb' into pdb files of each individual chain and water/ions. Output files are **melt_ions.pdb**, **melt_water.pdb**, and **melt_chain{1...numchains}.pdb**

## Instructions:

1. Create a conda environment from **fga_fp5.yml** in a location of your choosing using instructions found in [conda documentation]
(https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#creating-an-environment-from-an-environment-yml-file). 

1. Download packmol in a location of your choosing.

1. Ensure all software versions being used are correct.

1. File **submit.sh** contains all the bash commands necessary to build simulations and can be run using the command "bash submit.sh". Before running **submit.sh**, there are a few lines of code that must be changed. 1) Change the line "source activate /projects/p31412/Mfp_Brushes/envs/fga_mfp" such that it specifies the path to your newly created conda environment. 2) Correct the line "/home/jjg9482/packmol/packmol < pack1_chains.inp" such that the command specifies the path to your newly installed packmol executable. Keep '< pack1_chains.inp' after you have specified the path. This indicates which packmol input file to use. 3) Change the commands "module load python/anaconda3.6" and "module load vmd" to specify paths to your pre-compiled versions of anaconda and vmd. 4) Run the script using "bash submit.sh"

1. Change directories into the newly generated directory containing all simulations entitled **split_fp_simulations** and navigate into the directory **annealing_input_submit**. **split_fp_simulations** is outside of the directory **generate_paper_simulations**. Run the bash script **copy_lmpin.sh** using "bash copy_lmpin.sh", which will modify **annealing_template.in** and copy it as **annealing.in** into the **annealing** directory of each simulation.

1. Run the bash script **copy_submit.sh** using "bash copy_submit.sh", which will modify **submit_annealing_template.sh** and copy it as **submit_annealing.sh** into the **annealing** directory of each simulation.

1. Navigate into each simulation's **annealing** directory and submit them using the commands in **submit_annealing.sh**. Note that the mpirun command executes a parallelizable version of lammps and there are a number of settings passed by #SBATCH specifying batch job details which will vary by computing cluster. Alternatively, **submit_all_annealing.sh** has been copied into **split_fp_simulations**, which navigates into each directory and runs the bash commands found in **submit_annealing.sh** using sbatch.

1. Once the simulations are complete, navigate into the directory **tensile_input_submit** and run **copy_lmpin.sh**, which will modify **tensile_test_template.in** and copy it as **tensile_test.in** into the **tensile_test** directory of each simulation. This script also copies the final data file **7_T300_P1.data** output by **annealing.in** into **tensile_test** so that the simulation can contain from the equilibrium configuration.

1. Run the bash script **copy_submit.sh**, which will modify **submit_tensile_test_template.sh** and copy it as **submit_tensile_test.sh** into the **tensile_test** directory of each simulation.

1. Navigate into each simulation's **tensile_test** directory and submit them using the commands in **submit_tensile_test.sh**. Note that the mpirun command executes a parallelizable version of lammps and there are a number of settings passed by #SBATCH specifying batch job details which will vary by computing cluster. Alternatively, **submit_all_tensile.sh** has been copied into **split_fp_simulations**, which navigates into each directory and runs the bash commands found in **submit_tensile.sh** using sbatch.

