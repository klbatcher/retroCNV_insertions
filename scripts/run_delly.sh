#!/bin/bash

#Identify retroCNV present in the reference assembly. Locations of canfam3 retrocopies provided by "retrogeneDB_locations.bed". Requires delly, samtools and bcftools.


#Isolate regions of canfam3 that contain references retrocopies for analysis
for f in $files
do
samtools view -b -o $f.refcopies.bam $f.bam -L retrogeneDB_locations.bed
done


#SV calling by sample, output data into directory 'bcf'
mkdir bcf
for f in $files
do
delly call -g canFam3.fa -o bcf/$f.bcf $f.refcopies.bam
done


#Merge all SV sites into a unified site list
delly merge -o sites.bcf bcf/*.bcf


#Genotype the merged SV site list across all samples
for f in $files
do
delly call -g canFam3.fa -v sites.bcf -o bcf/$f.geno.bcf $f.refcopies.bam
done


#Merge all genotyped samples to get a single VCF/BCF using bcftools merge
bcftools merge -m id -O b -o merged.bcf bcf/*.geno.bcf
bcftools view merged.bcf > final.vcf