#!/bin/bash

#given a list of paired-end FASTQ files in fof.txt, aligns them to the canfam3 reference, marks and remove duplicates, converts to bam format and creates an index.
#requires minimap2 and samtools

files=`cat fof.txt`
for f in $files
do
minimap2 -t 6 -ax sr canfam3.ucsc.fa "$f"_R1_001.fastq.gz "$f"_R2_001.fastq.gz | \
samtools fixmate -m -O bam - "$f".fixmate.bam
samtools sort --threads=4 -l 6 -m1G -O bam "$f".fixmate.bam | \
samtools markdup -O bam -@4 -r - "$f".bam
samtools index "$f".bam
rm "$f".fixmate.bam
done