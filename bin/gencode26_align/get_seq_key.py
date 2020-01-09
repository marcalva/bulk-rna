#!/usr/bin/python
# Create a key for paired end read fastq files
#
# Pulls the fastq files present within a parent directory
# 'fastq_dir' specifies the parent directory.
# Within fastq_dir, each directory must correspond to a sample. The 
# name of each directory is assumed to be the sample name
# 
# The script recursively lists files in each sample folder, and grabs 
# fastq files based on the suffix
#

import os
import sys
import gzip

def isfastq(x):
    if (x[-9:] == ".fastq.gz") or \
    (x[-6:] == ".fastq") or \
    (x[-3:] == ".fq") or \
    (x[-6:] == ".fq.gz"):
        return True
    else:
        return False

def isr1(x, r = ["R1_001", "R1001"]):
    for i in r:
        if i in x:
            return True
    return False

def isr2(x, r = ["R2_001", "R2001"]):
    for i in r:
        if i in x:
            return True
    return False

fastq_dir = "data/fastq/"

samples = os.listdir(fastq_dir)

if not os.path.isdir("sample"):
    os.makedirs("sample")

ofs = open("sample/sample.fastq.txt", 'w')
ofs.write("\t".join(["sample", "instrument", "run_number", "flow_cell", "lane", "path"]) + "\n")

for sample in samples:
    fastq_dir_s = fastq_dir + sample + "/"
    for r, d, f in os.walk(fastq_dir_s):
        fastqs = [x for x in f if isfastq(x)]
        if (len(fastqs) == 0):
            continue
        f1files = sorted([x for x in fastqs if isr1(x)])
        f2files = sorted([x for x in fastqs if isr2(x)])
        if (len(f1files) != len(f2files)):
            print("Number of R1 fastq files doesn't match number of R2 fastq files")
            sys.exit(1)
        for i in range(len(f1files)):
            fastq1path = r + "/" + f1files[i]
            fastq2path = r + "/" + f2files[i]
            if fastq1path[-3:] == ".gz":
                fastq1fs = gzip.open(fastq1path, 'rt')
            else:
                fastq1fs = open(fastq1path, 'rt')
            rid1 = fastq1fs.readline()
            fastq1_rn = rid1[0]
            fastq1fs.close()
            if fastq2path[-3:] == ".gz":
                fastq2fs = gzip.open(fastq2path, 'rt')
            else:
                fastq2fs = open(fastq2path, 'rt')
            rid2 = fastq2fs.readline()
            fastq2_rn = rid2[0]
            fastq2fs.close()
            if fastq1_rn != fastq2_rn:
                print("Paired files do not match for sample " + sample)
                print(f1files)
                print(f2files)
                sys.exit(1)
            ridl = rid1.split(":")
            instrmnt =  ridl[0].replace("@", "")
            runnum = ridl[1]
            flowcell = ridl[2]
            lane = ridl[3]
            fastqpaths = fastq1path + ';' + fastq2path
            lineout = "\t".join([sample, instrmnt, runnum, flowcell, lane, fastqpaths]) + "\n"
            ofs.write(lineout)

ofs.close()

