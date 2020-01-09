#!/bin/bash
#$ -cwd
#$ -j y
#$ -l h_data=4000M,h_rt=2:00:00
#$ -t 1-12
#$ -M malvarez@mail
#  Notify at beginning and end of job
#$ -m n
#$ -r n
#$ -o merge_rg.pass2.sh.log.$TASK_ID

cd ../../
sample=$( awk 'NR > 1 {print $1}' data/processed/fastq/seq_key.txt | sort -u | awk "NR == $SGE_TASK_ID" )
src/samtools-1.6/bin/samtools merge -f \
	data/processed/gencode26_align/pass2/${sample}/Aligned.out.RG.sorted.bam \
	data/processed/gencode26_align/pass2/${sample}/*/*/*/*/*sorted.bam

src/samtools-1.6/bin/samtools index data/processed/gencode26_align/pass2/${sample}/Aligned.out.RG.sorted.bam
