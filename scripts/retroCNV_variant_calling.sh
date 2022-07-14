#!/bin/bash

#Identify variants accross parent gene sequences for retroCNV specific SNV analysis. Requires bcftools.


#Given the list of retroCNV parent genes in parentgenes.txt, create a file of all retrocopy parent genes exons
genes=`cat parentgenes.txt`
for f in $genes
do
grep $'\t'$f$'\t' ncbi_refseq_exons.bed >> myexons.bed
done


#Perform variant calling accross all retrocopy parent genes on a list of bam files
bcftools mpileup -Ou -d 100 -R myexons.bed -f canFam3.fa -b bamfilelist.txt | bcftools call -mv -Ob -o allvariants.bcf
bcftools view allvariants.bcf > allvariants.vcf