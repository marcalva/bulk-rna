# RNA-seq pipeline

Pipeline to map RNA-seq reads using STAR 2.5.2b and GRCh38 Gencode v26.

## Downloading pre-requisites

We need to download the softwares, references, and annotations.

We start with downloading STAR, samtools, htslib, picard tools, references fastas, and GTF annotations
```bash
cd src
./download_programs.sh
cd ref
./download_refs.sh
cd ../../
```

Build the reference genome SA index for STAR
```bash
cd src/gencode26_align
qsub run_genomeGenerate.pass1.sh
cd ../../
```

## Alignment

Before starting the alignment, create a sequencing key that contains 
information on the sequencing machine, flow cell, lane, sample info, and fastq paths. 
You can do this by hand or run the following script that pulls the above data 
from the Illumina fastq files. This relies on specific formatting so you have to  
edit the script to work on your fastq files

```bash
cd src/gencode26_align
python get_seq_key.py
cd ../../
```

This places a key file in `data/processed/fastq/seq_key.txt`.

Then, the pass 1 alignment python script reads the info from this key file 
to map the fastq reads

```bash
cd src/gencode26_align
qsub map_pass1.py
cd ../../
```

We collect the splice junctions from the mapping to create a second genome, with these 
junctions added to the reference genome.
```bash
cd src/gencode26_align
./collectSJ.sh
cd ../../
```

We create the second genome SA index

```bash
cd src/gencode26_align
qsub run_genomeGenerate.pass2.sh
cd ../../
```

Map to second pass genome

```bash
cd src/gencode26_align
qsub map_pass2.py
cd ../../
```

QC for each of the sequencing runs. This pulls mapping statistics output by STAR, as well as runs 
PicardTools' CollectRnaSeqMetrics

```bash
cd src/gencode26_align
python get_map_stats.py
qsub run_picard.sh
cd ../../
```

Merge the QC output into 1 file

```bash
cd src/gencode26_align
Rscript merge_mapstats_persample.R
python merge_picard_persample.py
cd ../../
```

We add in the read group information into the BAM files, and then sort by position

```bash
cd src/gencode26_align
qsub add_rg_sort.pass2.sh
cd ../../
```

Merge the BAM files for each sample

```bash
cd src/gencode26_align
qsub merge_rg.pass2.sh
cd ../../
```

Sort reads by read name for input to featureCounts

```bash
cd src/gencode26_align
qsub sortByRN.sh
cd ../../
```

Read counts at genes using featureCounts

```bash
cd src/gencode26_align
qsub run_featureCounts_pass2.sh
cd ../../
```

Format featureCounts output

```bash
cd src/gencode26_align
qsub run_featureCounts_pass2.sh
cd ../../
```



