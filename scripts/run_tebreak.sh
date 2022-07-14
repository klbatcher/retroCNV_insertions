#!/bin/bash

#Identify discordant read clusters using tebreak. Requires tebreak.
#telomeremask.bed and ncbi_refseq_exons.bed are provided
#ncbi_refseq.fa is a list of gene sequences which is produced by make_kmers.sh

#identify discordant read clusters in 'file.bam'
tebreak -b file.bam -r canFam3.fa -d ncbi_refseq_exons.bed -m telomeremask.bed -i ncbi_refseq.fa --debug --disc_only --min_disc_reads 4 -p 8
