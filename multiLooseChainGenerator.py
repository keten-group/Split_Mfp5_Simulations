
# 4/28/21

# This code takes a text input file with no spaces made up of one letter codes for simple amino acids and generates a chain with large random walk backbone angles.

#create and join a data path for where output files should be stored
#this may change if directories are rearranged!
import Bio.PDB
import argparse
parser = argparse.ArgumentParser()
parser.add_argument('-seq', '--input_sequence', type=str, help='String of single letter amino acid IDs.')
parser.add_argument('-o_path', '--output_path', type=str, help='Path and name of output pdb file.')
parser.add_argument("-n", "--numchains", type=int, help="Desired number of chains")
parser.add_argument("-o_filename", "--output_filename", type=str, help="Naming convention for output chains.")
args = parser.parse_args()
N = args.numchains
# in_file_name = args.input_sequence
out_path=args.output_path
out_name=args.output_filename
# import os
# project_path = os.path.abspath('..')
# unique_dir_name = False
# while unique_dir_name == False:
#     directory_name = 'melt_pack_equilibrate_out'
#     data_path = os.path.join(project_path, directory_name)
#     if not os.path.exists(data_path):
#         os.makedirs(data_path)
#         unique_dir_name = True
#     else:
#         print("Directory already exists. Please rename existing directory.")
#         exit()

# seq = open(in_file_name, 'r').read()
seq=args.input_sequence

import PeptideBuilder
from PeptideBuilder import Geometry
import random
# establish initial residue to build off of.
# Loop through to create N chains
for m in range(0,N):
    initial_aa = seq[0]
    initial_geo = Geometry.geometry(initial_aa)
    structure = PeptideBuilder.initialize_res(initial_geo)
    for i in range(len(seq)):
        aa = seq[i]
        if i != 0:
            aa_geo = Geometry.geometry(aa)
            #choose large random angles between 120 and 240 (-120)
            aa_geo.phi = 180 + random.uniform(-60,60)
            aa_geo.psi_im1 = 180 + random.uniform(-60,60)
            PeptideBuilder.add_residue(structure, aa_geo)
    out_filename = out_name + str(m+1) + '.pdb'
    out = Bio.PDB.PDBIO()
    out.set_structure(structure)
    out.save(out_filename)


