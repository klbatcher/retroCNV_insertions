#!/bin/bash

#requires a list of table files produced by find_parent_genes.sh and a list of discordant reads produced by run_tebreak.sh
#filter list of kmer hits for only parent genes with numg0 > 5, fg0 > .1, and mean_non0 > 1
#the file "final.table" will contain a list of all parent genes
#the file "all.insertions" will contain all discordant read pilups for those parent genes

tables=`cat fof.txt`
for f in $tables
do
awk '($7>=0.1 && $6>5 && $9>1)' $f.table > $f.fix.table
awk '{print $1}' $f.fix.table > $f
grep -f $f $f.tebreak.disc.txt > $f.insertions
rm $f
done

#make one combined table with no duplicates
list=`ls *.fix.table`
awk '!duplicate[$1]' $list | awk '!seen[$1]++' > final.table

#make one combined list of insertion sites
list=`ls *.insertions`
cat $list > all.insertions


#get total count for each parent gene in dataset

#first make a file listing all transcripts
cat final.table | awk '{print $1}' > genelist.txt

#then count the total occurance of each gene
list=`cat genelist.txt`
for f in $list; do grep $f *.fix.table -o | wc -l >> counts.txt; done