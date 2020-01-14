# RNA-seq pipeline

Pipeline to map RNA-seq reads using STAR 2.5.2b and GRCh38 Gencode v26.

## Downloading pre-requisites

Download the STAR aligner, samtools, htslib, 
picard tools, references fastas, and GTF annotations
```bash
cd bin
./download_programs.sh
cd ref
./download_refs.sh
cd ../../
```

Mapping with STAR requires that the reference genome is indexed. This 
needs to be done for a specific read length (e.g. 75 read lengths need a 
separate genome index from 150 base pair read lengths). This script 
builds the reference genome SA index for STAR
```bash
cd bin/gencode26_align
qsub run_genomeGenerate.pass1.sh
cd ../../
```

## Alignment

It's much easier to map multiple samples if there is a key containing the 
samples, fastq files, and their paths. This script creates a key that 
maps sample IDs, fastq files, its flow cell, lane, and path. This requires 
that the fastq files be structured in a directory where each folder in this 
parent directory is a sample directory, and all fastq files within the sample 
directory come from that one sample. This also assumes that the reads are 
paired. I don't have anything for single-end reads at the moment. By 
default, the key is output in a file `sample/sample.fastq.txt`. You can make 
this file by hand with the columns

|sample|instrument| run_number| flow_cell| lane| path|
|-------|--------|------------|-----------|----|---|

where path contains the path to the fastq files with R1 and R2 separated by 
a semicolon, for example `R1.fastq.gz;R2.fastq.gz`.


```bash
cd bin/gencode26_align
python get_seq_key.py
cd ../../
```

The pass 1 alignment script maps the reads to detect splice junctions.

```bash
cd bin/gencode26_align
qsub map_pass1.py
cd ../../
```

We collect the splice junctions from the mapping to create a second genome, with these 
junctions added to the reference genome.
```bash
cd bin/gencode26_align
./collectSJ.sh
cd ../../
```

We create the second genome SA index

```bash
cd bin/gencode26_align
qsub run_genomeGenerate.pass2.sh
cd ../../
```

Map to second pass genome

```bash
cd bin/gencode26_align
qsub map_pass2.py
cd ../../
```

QC for each of the sequencing runs. This pulls mapping statistics output by STAR, as well as runs 
PicardTools' CollectRnaSeqMetrics

```bash
cd bin/gencode26_align
python get_map_stats.py
qsub run_picard.sh
cd ../../
```

Merge the QC output into 1 file

```bash
cd bin/gencode26_align
Rscript merge_mapstats_persample.R
python merge_picard_persample.py
cd ../../
```

We add in the read group information into the BAM files, and then sort by position

```bash
cd bin/gencode26_align
qsub add_rg_sort.pass2.sh
cd ../../
```

Merge the BAM files for each sample

```bash
cd bin/gencode26_align
qsub merge_rg.pass2.sh
cd ../../
```

Sort reads by read name for input to featureCounts

```bash
cd bin/gencode26_align
qsub sortByRN.sh
cd ../../
```

Read counts at genes using featureCounts

```bash
cd bin/gencode26_align
qsub run_featureCounts_pass2.sh
cd ../../
```

Format featureCounts output

```bash
cd bin/gencode26_align
qsub run_featureCounts_pass2.sh
cd ../../
```


