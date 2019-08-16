#!/bin/bash
#$ -cwd
#$ -j y
#$ -pe shared 4
#$ -l h_data=4000M,h_rt=4:00:00,highp
#$ -M malvarez@mail
#  Notify at beginning and end of job
#$ -m n
#$ -r n
#$ -t 1-24
#$ -o add_rg_sort.pass2.sh.log.$TASK_ID

. /u/local/Modules/default/init/modules.sh
module load java/1.8.0_77

cd ../../

pass2_dir="data/processed/gencode26_align/pass2/"

samtools="src/samtools-1.6/bin/samtools"

dsfile="data/processed/fastq/seq_key.txt"

n_datasets=$( wc -l $dsfile |  awk '{print $1}' )
ntasks=24
step=$(( n_datasets / ntasks ))
task=$(( $SGE_TASK_ID ))
start=$(( $task * $step ))
stop=$(( $start + $step - 1 ))
if [[ $SGE_TASK_ID == $ntasks ]]; then
	stop=$(( $n_datasets - 1 ))
fi

for i in $( seq $start $stop ); do
	# Since header, add 1
	i=$((i + 1))
	sample=$( awk -v I=$i 'NR == I {print $1}' $dsfile )
	instr=$( awk -v I=$i 'NR == I {print $2}' $dsfile )
	runn=$( awk -v I=$i 'NR == I {print $3}' $dsfile )
	flowcell=$( awk -v I=$i 'NR == I {print $4}' $dsfile )
	lane=$( awk -v I=$i 'NR == I {print $5}' $dsfile )

	ibam="${pass2_dir}/${sample}/${instr}/${runn}/${flowcell}/${lane}/Aligned.out.bam"
	obam="${pass2_dir}/${sample}/${instr}/${runn}/${flowcell}/${lane}/Aligned.out.RG.sorted.bam"
	rgid="${flowcell}.${lane}"
	lb="${sample}"
	pl="illumina"
	pu="${flowcell}.${lane}.${sample}"
	sm=${sample}
	
	echo $sample

	java -Xmx16g -jar src/picard.jar AddOrReplaceReadGroups \
		I=$ibam \
		O=$obam \
		SO=coordinate \
		RGID=$rgid \
		RGLB=$sample \
		RGPL=$pl \
		RGPU=$pu \
		RGSM=$sample

done
