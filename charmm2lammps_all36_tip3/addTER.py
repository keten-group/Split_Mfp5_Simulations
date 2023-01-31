# 2/1/2022 - Read in pdb file and write it out line by line to a new file with appropriate modifications. PDB 3.0 column format is followed.

# Note: For multiple chains, make sure that TER lines are not added after water molecules are.
# <!-- Modifications: TIP3 atom names OH2 changed to OH1, H2 changed to H, H1 changed to H to match charmm2lammps topology and parameter files. -->

#create and join a data path for where output files should be stored
#this may change if directories are rearranged!
import os
project_path = os.path.abspath('.')

### Initialize Argparse ###
import argparse
parser = argparse.ArgumentParser()
parser.add_argument("-i", "--in_name", type=str, help="Input pdb filename.")
parser.add_argument("-o", "--out_name", type=str, help="Output pdb filename.")
args=parser.parse_args()
in_name = args.in_name
out_name = args.out_name

# in_name = 'network_missingTER.pdb'
# out_name = 'network.pdb'
text_file = open(out_name, "wt")
numters = 0 # count the number of terminal lines that have been added
with open(in_name) as pdbfile:
    lines = pdbfile.readlines()
    for i in range(len(lines)-1):
        if lines[i][:4] == 'ATOM' or lines[i][:6] == "HETATM": 
        #increment atom index of current line by numters
            atom_indx = lines[i][6:11]
            x = int(atom_indx)
            new_indx = x + numters
            new_indx_str = str(new_indx)
            new_indx_len = len(new_indx_str)
            # stitch together line as string with incremented index
            new_line = lines[i][:6] + lines[i][6:11-new_indx_len] + new_indx_str + lines[i][11:]
            if i < len(lines)-2 and lines[i][21] != lines[i+1][21]:
                # check if there is a terminal line
                if lines[i+1][:2] != 'TER':
                    # Print this line followed by TER line
                    text_file.write(new_line)
                    numters = numters + 1 # track how many TER lines have been added
                    ter_indx = new_indx + 1 # ter line gets own index incremented by 1
                    ter_indx_str = str(ter_indx)
                    ter_indx_len = len(ter_indx_str)
                    ter_line = 'TER   ' + lines[i][6:11-ter_indx_len] + ter_indx_str + '      ' + lines[i][17:26] + '\n'
                    text_file.write(ter_line)
                else:
                    text_file.write(new_line)
            else:
                text_file.write(new_line)
        else:
            text_file.write(lines[i])
    text_file.write(lines[len(lines)-1])
    text_file.close()



