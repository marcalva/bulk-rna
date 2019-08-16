#!/usr/bin/python

import os
import sys
import gzip

os.chdir("../../")
fastqdir = "/u/project/pajukant/pajukant/2019-9156-138612475/FASTQ_Generation_2019-07-16_02_00_43Z-189837551/"
fastqdirs = os.listdir(fastqdir)

out_dir = "data/processed/fastq/"
if not os.path.exists(out_dir):
	os.makedirs(out_dir)

rg_dict = {}

outfs = open(out_dir + "seq_key.txt", 'w')
outfs.write("\t".join(["sample", "machine", "run", "flow_cell", "lane", "fastq_r1", "fastq_r2"]) + "\n")

for l in fastqdirs:
	sample_id = l.split("_L")[0]
	fastqs = os.listdir(fastqdir + l)
	fastqs_r1 = [x for x in fastqs if "_R1_" in x]
	for fr1 in fastqs_r1:
		fr2 = fr1.replace("_R1_", "_R2_")
		fr1 = fastqdir + l + "/" + fr1
		fr2 = fastqdir + l + "/" + fr2
		fstr = gzip.open(fr1, 'r')
		line = fstr.readline()
		fstr.close()
		line = line.replace("@", "")
		linel = line.split(":")
		machine = linel[0]
		run_n = linel[1]
		flow_cell = linel[2]
		lane = linel[3]
		keyid = "\t".join([sample_id, machine, run_n, flow_cell, lane])
		if keyid not in rg_dict:
			rg_dict[keyid] = [fr1, fr2]
		else:
			rg_dict[keyid][0] = rg_dict[keyid][0] + "," + fr1
			rg_dict[keyid][1] = rg_dict[keyid][1] + "," + fr2

for k in rg_dict:
	linel = k.split("\t")
	fastq = rg_dict[k]
	linel.append(fastq[0])
	linel.append(fastq[1])
	outfs.write("\t".join(linel) + "\n")


outfs.close()	

