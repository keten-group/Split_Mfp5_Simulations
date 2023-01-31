#!/usr/bin/env python
# coding: utf-8

# add segment ID to a single pdb chain. 8/25/21
import os
project_path = os.path.abspath('.')
# data_path = os.path.abspath('addsegID_out')
# if not os.path.exists(data_path):
#     os.makedirs(data_path)
import argparse
parser = argparse.ArgumentParser()
parser.add_argument("-f", "--filename", type=str, help="Input pdb filename.")
parser.add_argument("-sid", "--segID", type=str, help="Two character segID to be added.")
parser.add_argument("-cid", "--chainID", type=str, help="Single character chain ID.")
args=parser.parse_args()
pdb_in=args.filename
# out_name = "segID" + args.filename
# out_path = f"{data_path}/{out_name}"
segid=args.segID
chainid=args.chainID
if len(segid) != 2:
    print("segID must be two characters.")
    os._exit()
with open(pdb_in) as pdbfile:
    lines = pdbfile.readlines()
    i = 0
    index = 1
    index_blank = "     "
    if lines[1][:4] == 'ATOM':
        out_name = "segID" + pdb_in
        pdb_out = open(out_name, "wt") # open new pdb file to be written to
        index_str = str(index)
        index_len = len(index_str)
        segid_len = len(segid)
        # stitch together line as string with incremented index
        new_line = lines[i][:6] + index_blank[:5-index_len] + index_str + lines[i][11:21] + chainid + lines[i][22:72] + segid + lines[i][76-(4-segid_len):]
        pdb_out.write(new_line)
        for i in range(len(lines)-3):
            i += 1
            index += 1
            index_str = str(index)
            index_len = len(index_str)
            # stitch together line as string with incremented index
            new_line = lines[i][:6] + index_blank[:5-index_len] + index_str + lines[i][11:21] + chainid + lines[i][22:72] + segid + lines[i][76-(4-segid_len):]
            pdb_out.write(new_line)
        ter_line = lines[len(lines)-2][:21] + chainid + lines[len(lines)-2][22:]
        pdb_out.write(ter_line)
        pdb_out.write("END")
        pdb_out.close()
    elif lines[i][:6] == 'HETATM':
        out_name = "segID" + pdb_in
        pdb_out = open(out_name, "wt") # open new pdb file to write water pdb file
        index_str = str(index)
        index_len = len(index_str)
        segid = "W"
        segid_len = len(segid)
        # stitch together line as string with incremented index
        new_line = lines[i][:6] + index_blank[:5-index_len] + index_str + lines[i][11:21] + chainid + lines[i][22:72] + segid + lines[i][76-(4-segid_len):]
#             while lines[i+1][21] == lines[i][21]:
        for i in range(len(lines)-2):
            i += 1
            index += 1
            index_str = str(index)
            index_len = len(index_str)
            new_line = lines[i][:6] + index_blank[:5-index_len] + index_str + lines[i][11:21] + chainid + lines[i][22:72] + segid + lines[i][76-(4-segid_len):]
            pdb_out.write(new_line)
        pdb_out.write("END")
        pdb_out.close()      