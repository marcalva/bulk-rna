#!/usr/bin/python

import os
import sys

os.chdir("../../")

samplesfs = open("data/processed/fastq/seq_key.txt")
hdr = samplesfs.readline().split()
samples = samplesfs.readlines()
samplesfs.close()

ofs = open("data/processed/gencode26_align/pass2/map_stats.txt", 'w')
ol = hdr[:5] + ["num_input_reads", "uniq_map_num", "uniq_map_perc", "mismatch_rate", "num_multimap", "percent_multimap", "num_chimeric", "percent_chimeric"]

ofs.write("\t".join(ol) + "\n")

for s in samples:
	s = s.strip().split()
	sample = s[0]
	machine = s[1]
	runn = s[2]
	fc = s[3]
	lane = s[4]
	logfile = "data/processed/gencode26_align/pass2/" + "/".join([sample, machine, runn, fc, lane]) + "/Log.final.out"
	ifs = open(logfile, 'r')
	for i in range(5):
		junk = ifs.readline()
	l = ifs.readline().strip().split()
	num_input_reads = l[5]
	
	junk = ifs.readline()
	junk = ifs.readline()
	
	l = ifs.readline().strip().split()
	uniq_map_num = l[5]
	
	l = ifs.readline().strip().split()
	uniq_map_perc = l[5].replace("%", "")
	
	for i in range(7):
		junk = ifs.readline()
	
	l = ifs.readline().strip().split()
	mismatch_rate = l[6].replace("%", "")
	
	for i in range(7):
		junk = ifs.readline()
	
	l = ifs.readline().strip().split()
	num_multimap = l[9]
	l = ifs.readline().strip().split()
	percent_multimap = l[9].replace("%", "")
	for i in range(5):
		junk = ifs.readline()
	l = ifs.readline().strip().split()
	num_chimeric = l[5]
	l = ifs.readline().strip().split()
	percent_chimeric = l[5].replace("%", "")

	ifs.close()
	ol = s[:5] + [ num_input_reads, uniq_map_num, uniq_map_perc, mismatch_rate, num_multimap, percent_multimap, num_chimeric, percent_chimeric]
	
	ofs.write("\t".join(ol) + "\n")

ofs.close()
	
	
	
	
