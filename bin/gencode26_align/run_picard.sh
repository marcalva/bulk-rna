#!/bin/bash
#$ -cwd
#$ -j y
#$ -l h_data=16000M,h_rt=1:00:00
#$ -M malvarez@mail
#$ -t 1-24
#  Notify at beginning and end of job
#$ -m n
#$ -r n
#$ -o run_picard.sh.log.$TASK_ID

. /u/local/Modules/default/init/modules.sh
module load java/1.8.0_77

cd ../../

dsfile="data/processed/fastq/seq_key.txt"

i=$(( $SGE_TASK_ID + 1 ))

ds=$( awk -v I=$i 'NR == I {print $1}' $dsfile )
sample=$( awk -v I=$i 'NR == I {print $1}' $dsfile )
instr=$( awk -v I=$i 'NR == I {print $2}' $dsfile )
runn=$( awk -v I=$i 'NR == I {print $3}' $dsfile )
flowcell=$( awk -v I=$i 'NR == I {print $4}' $dsfile )
lane=$( awk -v I=$i 'NR == I {print $5}' $dsfile )

bam="data/processed/gencode26_align/pass2/${sample}/${instr}/${runn}/${flowcell}/${lane}/Aligned.out.RG.sorted.bam"

outdir="data/processed/gencode26_align/picard/"
mkdir -p ${outdir}/${sample}/${instr}/${runn}/${flowcell}/${lane}/
out="${outdir}/${sample}/${instr}/${runn}/${flowcell}/${lane}/picard.RNA_Metrics"

java -Xmx16g -jar src/picard.jar CollectRnaSeqMetrics \
	I=$bam \
	REF_FLAT=data/ref/refFlat.txt.gz \
	STRAND=FIRST_READ_TRANSCRIPTION_STRAND \
	O=$out

