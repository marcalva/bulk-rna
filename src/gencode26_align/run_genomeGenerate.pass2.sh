#!/bin/bash
#$ -cwd
#$ -j y
#$ -pe shared 12
#$ -l h_data=4000M,h_rt=6:00:00,highp
#$ -v QQAPP=openmp
#$ -M malvarez@mail
#  Notify at beginning and end of job
#$ -m n
#$ -r n
#$ -o run_genomeGenerate.pass2.sh.log

star=../STAR-2.5.2b/bin/Linux_x86_64/STAR

refFasta="../../data/ref/gencode26/GRCh38.primary_assembly.genome.fa"
gencodeAnno="../../data/ref/gencode26/gencode.v26.primary_assembly.annotation.gtf"
rlMinusOne=74
genomedir="../../data/processed/gencode26_align/genome4Pass2/"
mkdir -p $genomedir

$star --runMode genomeGenerate \
  --runThreadN 12 \
  --genomeDir $genomedir \
  --genomeFastaFiles $refFasta \
  --sjdbGTFfile $gencodeAnno \
  --sjdbFileChrStartEnd ${genomedir}/all.SJ.out \
  --sjdbOverhang $rlMinusOne
