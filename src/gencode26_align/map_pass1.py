#!/usr/bin/env python
#$ -S /u/local/apps/python/2.7.3/bin/python
#$ -cwd
#$ -j y
#$ -pe shared 12
#$ -l h_data=4000M,h_rt=9:00:00,highp
#$ -v QQAPP=openmp
#$ -v LD_LIBRARY_PATH
#$ -v PYTHON_LIB
#$ -v PYTHON_DIR
#$ -M malvarez@mail
#  Notify at beginning and end of job
#$ -m n
#$ -r n
#$ -o map_pass1.py.log

import os
import sys
from subprocess import call

star = "../STAR-2.5.2b/bin/Linux_x86_64/STAR"
genomeDir = "../../data/processed/gencode26_align/genome4Pass1/"

outdir = "../../data/processed/gencode26_align/pass1/"
if not os.path.exists(outdir):
	os.makedirs(outdir)


# Get Sample IDs
with open("../../data/processed/fastq/seq_key.txt") as f:
  lines = f.readlines()

nlines = len(lines)
ntasks = 1
step = int(nlines / ntasks)
# task = int(os.getenv("SGE_TASK_ID")) - 1
task = 0
start = task * step
stop = (task + 1) * step
if (task + 1) == ntasks:
	stop = nlines
if start == 0:
	start = 1

for line in lines[start:stop]:
  linel = line.strip().split("\t")
  sampleID = linel[0]
  machine = linel[1]
  run_n = linel[2]
  flow_cell = linel[3]
  lane = linel[4]
  fastq_r1 = linel[5]
  fastq_r2 = linel[6]
  read1path = fastq_r1
  read2path = fastq_r2
  outpre = outdir + "/" + sampleID + "/" + machine + "/" + run_n + "/" + flow_cell + "/" + lane + "/"
  if not os.path.exists(outpre):
    os.makedirs(outpre)
  call([star,
    "--runThreadN", "12",
    "--genomeDir", genomeDir,
    "--genomeLoad", "LoadAndKeep",
    "--readFilesIn", read1path, read2path,
    "--readFilesCommand", "zcat",
    "--alignIntronMin", "20",
    "--alignIntronMax", "1000000",
    "--outFilterMultimapNmax", "1",
    "--chimSegmentMin", "15",
    "--outFilterMismatchNmax", "10",
    "--outFilterMismatchNoverLmax", "0.04",
    "--outSAMattributes", "All",
    "--outSAMtype", "BAM", "Unsorted",
    "--outFileNamePrefix", outpre])

call([star, "--genomeDir", genomeDir, "--genomeLoad", "Remove"])
