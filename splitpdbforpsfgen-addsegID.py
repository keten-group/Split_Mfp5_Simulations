#!/usr/bin/env python
# coding: utf-8

# 7/13/21 - Read in a pdb file with multiple solvated protein chains and use unique chain ID column for each chain to create separate pdbs for each segment and the water. Give each chain a segment ID for use with psfgen as well.

#create and join a data path for where output files should be stored
#this may change if directories are rearranged!
import os
project_path = os.path.abspath('.')

# pdb_in = "melt_packed_packmol.pdb"
pdb_in = "chains_packed.pdb"
numchains = 0 # count the number of chains identified
with open(pdb_in) as pdbfile:
    lines = pdbfile.readlines()
    i = -1
    while i < len(lines)-2:
        i += 1
        index = 1
        index_blank = "     "
        if lines[i][:4] == 'ATOM' and lines[i][13:16] != 'CLA':
            numchains += 1
            out_name = "melt_chain" + str(numchains) + ".pdb"
            pdb_out = open(out_name, "wt") # open new pdb file to be written to
            index_str = str(index)
            index_len = len(index_str)
            segid = "P" + str(numchains)
            segid_len = len(segid)
            # stitch together line as string with incremented index
            new_line = lines[i][:6] + index_blank[:5-index_len] + index_str + lines[i][11:72] + segid + lines[i][76-(4-segid_len):]
            pdb_out.write(new_line)
            while lines[i+1][:3] != 'END' and lines[i+1][21] == lines[i][21]:
                i += 1
                index += 1
                index_str = str(index)
                index_len = len(index_str)
                # stitch together line as string with incremented index
                new_line = lines[i][:6] + index_blank[:5-index_len] + index_str + lines[i][11:72] + segid + lines[i][76-(4-segid_len):]
                pdb_out.write(new_line)
            pdb_out.write("END")
            pdb_out.close()
        elif lines[i][:4] == 'ATOM' and lines[i][13:16] == 'CLA':
            out_name = "melt_ions" + ".pdb"
            pdb_out = open(out_name, "wt") # open new pdb file to write water pdb file
            index_str = str(index)
            index_len = len(index_str)
            segid = "I"
            segid_len = len(segid)
            # stitch together line as string with incremented index
            new_line = lines[i][:6] + index_blank[:5-index_len] + index_str + lines[i][11:72] + segid + lines[i][76-(4-segid_len):]
            pdb_out.write(new_line)
#             while lines[i+1][21] == lines[i][21]:
            while lines[i+1][:3] != 'END' and lines[i+1][21] == lines[i][21]:
                i += 1
                index += 1
                index_str = str(index)
                index_len = len(index_str)
                new_line = lines[i][:6] + index_blank[:5-index_len] + index_str + lines[i][11:72] + segid + lines[i][76-(4-segid_len):]
                pdb_out.write(new_line)
            pdb_out.write("END")
            pdb_out.close()                 
        elif lines[i][:6] == 'HETATM':
            out_name = "melt_water" + ".pdb"
            pdb_out = open(out_name, "wt") # open new pdb file to write water pdb file
            index_str = str(index)
            index_len = len(index_str)
            segid = "W"
            segid_len = len(segid)
            # stitch together line as string with incremented index
            new_line = lines[i][:6] + index_blank[:5-index_len] + index_str + lines[i][11:72] + segid + lines[i][76-(4-segid_len):]
            pdb_out.write(new_line)
#             while lines[i+1][21] == lines[i][21]:
            while lines[i+1][:6] == 'HETATM':
                i += 1
                index += 1
                index_str = str(index)
                index_len = len(index_str)
                new_line = lines[i][:6] + index_blank[:5-index_len] + index_str + lines[i][11:72] + segid + lines[i][76-(4-segid_len):]
                pdb_out.write(new_line)
            pdb_out.write("END")
            pdb_out.close()
            break          