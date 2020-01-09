#!/bin/bash
#$ -cwd
#$ -j y
#$ -l h_data=16000M,h_rt=2:00:00
#$ -M malvarez@mail
#$ -t 1-12
#  Notify at beginning and end of job
#$ -m n
#$ -r n
#$ -o sortByRN.sh.log.$TASK_ID

. /u/local/Modules/default/init/modules.sh
module load java/1.8.0_77

cd ../../

sample=$( awk 'NR > 1 {print $1}' data/processed/fastq/seq_key.txt | sort -u | awk "NR == $SGE_TASK_ID" )
bamdir="data/processed/gencode26_align/pass2/${sample}"
inbam="${bamdir}/Aligned.out.RG.sorted.bam"
outbam="${bamdir}/Aligned.out.RG.sortedByRN.bam"

picard="src/picard.jar"

java -jar -Xmx16G $picard SortSam \
	I=$inbam \
	O=$outbam \
	SO=queryname
