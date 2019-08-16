#!/usr/bin/python

import os

dsfs = open("../../data/processed/fastq/seq_key.txt", 'r')
dsheader = dsfs.readline().strip().split("\t")

pdir = "../../data/processed/gencode26_align/picard/"

outfile = open(pdir + "all.picard.metrics", 'w')

header = False
for line in dsfs:
	linel = line.strip().split("\t")
	sample = linel[0]
	machine = linel[1]
	runn = linel[2]
	fc = linel[3]
	lane = linel[4]
	metricsfn = pdir + "/".join([sample, machine, runn, fc, lane]) + "/picard.RNA_Metrics"
	metricsfs = open(metricsfn, 'r')
	metricslines = metricsfs.readlines()
	if not header:
		h = dsheader + metricslines[6].strip().split("\t")
		outfile.write("\t".join(h) + "\n")
		header = True
	sl = metricslines[7].strip().split("\t")
	ol = linel + sl
	outfile.write("\t".join(ol) + "\n")
	metricsfs.close()

outfile.close()
