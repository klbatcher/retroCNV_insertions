#!/bin/bash

#produces a table file with a lit of retroCNV candidate parent genes
#requires jellyfish and samtools
#requires the files "all30mer.fa" and "gene_list_of_30mer.txt" which are produced by make_kmers.sh, and "locations.txt" which is provided
 

#provide a list of bam files in fof.txt
files=`cat fof.txt`

for f in $files
do

#count mrna specific 30mers from whole genome sequencing data. 
jellyfish count -m 30 -s 1G -C -t 6 -o $f.30mer.jf --if all30mer.fa <(samtools fastq $f.bam)

#merge gene name and sequence into one line, then sort and combine read counts + gene names
join -t" " -1 1 -2 1 gene_list_of_30mer.txt <(jellyfish dump $f.30mer.jf -L 1 | awk '{getline x;print x;}1' | sed 'N;s/\n/ /' | sed 's/>//g' | sort) > $f.hits.txt

#count occurance of each non0 gene
awk '{A[$2]++}END{for(i in A)print i,A[i]}' $f.hits.txt > $f.non0.txt

#count total kmers per gene
awk -F ' ' '{a[$2] += $3} END{for (i in a) print i, a[i]}' $f.hits.txt > $f.total.txt

#combine 
join -t" " -1 1 -2 1 $f.non0.txt $f.total.txt | sort > $f.combined
join -t" " -1 1 -2 1 locations.txt $f.combined > $f.final

#produce and add headers to final table file.
awk -F " " ' {print $1, $3, $4, $2, $2-$5, $5, $5/$2, $6, $6/$5}' $f.final > $f.temp
echo -e "gene location ref_copy numKmer num0 numg0 fg0 totaln0 mean_non0"| cat - $f.temp> $f.table

#remove temporary files
rm $f.non0.txt $f.total.txt $f.hits.txt $f.final $f.combined $f.temp

done