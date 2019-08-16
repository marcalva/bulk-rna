#!/bin/bash
#$ -cwd
#$ -j y
#$ -pe shared 8
#$ -l h_data=4000M,h_rt=10:00:00,highp
#$ -M malvarez@mail
#  Notify at beginning and end of job
#$ -m n
#$ -r n
#$ -o run_featureCounts_pass2.sh.log

featurecounts="../subread-1.6.2-Linux-x86_64/bin/featureCounts"

touch samples.txt
for sample in $( awk 'NR > 1 {print $1}' ../../data/processed/fastq/seq_key.txt | sort -u ); do
	echo "../../data/processed/gencode26_align/pass2/${sample}/Aligned.out.RG.sortedByRN.bam"
done > samples.txt

gtf="../../data/ref/gencode26/gencode.v26.primary_assembly.annotation.gtf"
outdir="../../data/processed/gencode26_align/featureCounts/"
out="${outdir}/gencode26.featureCounts.txt"
mkdir -p $outdir

$featurecounts \
	-p \
	-T 8 \
	-B \
	-a $gtf \
	--extraAttributes gene_name,gene_type \
	-o $out \
	-s 2 \
	$( cat samples.txt )

