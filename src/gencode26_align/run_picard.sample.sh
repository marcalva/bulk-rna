#!/bin/bash
#$ -cwd
#$ -j y
#$ -l h_data=16000M,h_rt=2:00:00
#$ -M malvarez@mail
#$ -t 1-12
#  Notify at beginning and end of job
#$ -m n
#$ -r n
#$ -o run_picard.sample.sh.log.$TASK_ID

. /u/local/Modules/default/init/modules.sh
module load java/1.8.0_77

cd ../../

mapfile="data/processed/fastq/seq_key.txt"
sample=$( awk 'NR > 1 {print $1}' $mapfile | sort -u | awk "NR == $SGE_TASK_ID" - )
bam="data/processed/gencode26_align/pass2/${sample}/Aligned.out.RG.sorted.bam"

outdir="data/processed/gencode26_align/picard/${sample}/"
mkdir -p $outdir
out="${outdir}/${sample}.picard.RNA_Metrics"

java -Xmx16g -jar src/picard.jar CollectRnaSeqMetrics \
	I=$bam \
	REF_FLAT=data/ref/refFlat.txt.gz \
	STRAND=FIRST_READ_TRANSCRIPTION_STRAND \
	O=$out
