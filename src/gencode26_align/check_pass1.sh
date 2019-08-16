#!/bin/bash

cd ../../

dsfile="data/processed/ADI_fastq/seq_key.txt"

n_datasets=$( wc -l $dsfile |  awk '{print $1}' )

for i in $( seq 2 $n_datasets ); do
	sample=$( awk -v I=$i 'NR == I {print $1}' $dsfile )
	instr=$( awk -v I=$i 'NR == I {print $2}' $dsfile )
	run=$( awk -v I=$i 'NR == I {print $3}' $dsfile )
	flowcell=$( awk -v I=$i 'NR == I {print $4}' $dsfile )
	lane=$( awk -v I=$i 'NR == I {print $5}' $dsfile )

	bam="data/processed/GRCh38_gencode26_alignment_fat_adi/adi_pass1/${sample}/${instr}/${run}/${flowcell}/${lane}/Aligned.out.bam"

	src/samtools-1.6/bin/samtools quickcheck -v $bam
done
