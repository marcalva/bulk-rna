#!/bin/bash

module load gcc/7.2.0

# Download STAR
wget https://github.com/alexdobin/STAR/archive/2.5.2b.tar.gz
tar xzvf 2.5.2b.tar.gz 
rm 2.5.2b.tar.gz

# Download samtools
wget https://github.com/samtools/samtools/releases/download/1.6/samtools-1.6.tar.bz2
tar xjf samtools-1.6.tar.bz2
rm samtools-1.6.tar.bz2
cd samtools-1.6
./configure --disable-lzma --prefix=$PWD
# If it complains about curses, use 
# ./configure --disable-lzma --prefix=$PWD --without-curses
make
make install
cd htslib-1.6
./configure --disable-lzma --prefix=$PWD
make
make install
cd ../../

# Download picard-tools
wget https://github.com/broadinstitute/picard/releases/download/2.20.5/picard.jar

# Download subread featureCounts
wget https://versaweb.dl.sourceforge.net/project/subread/subread-1.6.2/subread-1.6.2-Linux-x86_64.tar.gz
tar xzvf subread-1.6.2-Linux-x86_64.tar.gz
rm subread-1.6.2-Linux-x86_64.tar.gz

