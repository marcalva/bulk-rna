#!/bin/bash

cd ../../

mkdir -p data/ref

cd data/ref

# Gencode v26 data (used for analysis)
mkdir -p gencode26
cd gencode26

wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_26/GRCh38.primary_assembly.genome.fa.gz
gunzip -f GRCh38.primary_assembly.genome.fa.gz

wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_26/gencode.v26.annotation.gtf.gz
gunzip -f gencode.v26.annotation.gtf.gz

wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_26/gencode.v26.primary_assembly.annotation.gtf.gz
gunzip -f gencode.v26.primary_assembly.annotation.gtf.gz

# gencode v26 mapped to GRCh37 coordinates
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_26/GRCh37_mapping/gencode.v26lift37.annotation.gtf.gz
gunzip -f gencode.v26lift37.annotation.gtf.gz

# refFlat
cd ../
wget http://hgdownload.cse.ucsc.edu/goldenPath/hg38/database/refFlat.txt.gz


