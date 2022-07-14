#!/bin/bash

#this produces the files "all30mer.fa" and "gene_list_of_30mer.txt" which are used to identify retroCNV parent genes.
#requires gffread, samtools, jellyfish and mrsfast.

#download canfam3 reference and NCBI refseq annotation file in UCSC format
wget http://hgdownload.soe.ucsc.edu/goldenPath/canFam3/bigZips/canFam3.fa.gz
gunzip canFam3.fa.gz
wget http://hgdownload.soe.ucsc.edu/goldenPath/canFam3/bigZips/genes/canFam3.ncbiRefSeq.gtf.gz
gunzip canFam3.ncbiRefSeq.gtf.gz


#get gene sequences in fasta format
samtools faidx canFam3.fa
gffread canFam3.ncbiRefSeq.gtf -g canFam3.fa -ZFU --no-pseudo -w ncbi_refseq.fa


#convert all transcripts to the same gene name
awk -v FS="\t" 'NR==FNR {match($9, /transcript_id "([^"]+)"/ , t); match($9, /gene_name "([^"]+)"/, g); transcript[t[1]]=g[1]; next} {match($0, />([^ ]+)/, t); gsub(t[1], transcript[t[1]]); print}' canFam3.ncbiRefSeq.gtf ncbi_refseq.fa | sed 's/ .*//g' > ncbi_fix.fa
mv ncbi_fix.fa ncbi_refseq.fa


#collect 30mers that are in the transcriptome but not in the canfam3 reference genome
jellyfish count -m 30 -s 500M -C -t 6 -o unique30mer.jf -U 0 --if ncbi_refseq.fa canFam3.fa
jellyfish dump unique30mer.jf > unique30mer.txt


#create index for mrsfast and then remove all 30mers within 2 edit distance of the reference genome
mrsfast --index canFam3.fa
mrsfast --search canFam3.fa --seq unique30mer.txt -e 2 -o unique30mer_filter.txt


#make a file for each gene and lump all transcripts from same gene into same file
mkdir genes
cd genes
cat ../ncbi_refseq.fa | awk '{
        if (substr($0, 1, 1)==">") {filename=(substr($0,2) ".fa")}
        print $0 > filename
}'


#for each gene, count the 30mers that have a match in unique30mer_filter.txt.nohit, then jellyfish dump into a new file
mkdir 30mers
for file in *; do jellyfish count -m 30 -s 10M -C -t 4 -L 1 -o $file.jf --if $file ../unique30mer_filter.txt.nohit; jellyfish dump $file.jf > 30mers/$file.30mer.fa; rm $file.jf; done



#after removing genes with <5 30mer hits: merge all of the unique reads into one multifasta; this file will be used for downstream analysis
cd 30mers
for file in *; do awk 'NR%2{ print ">'$file'"; } NR % 2 == 0 { print; }' $file | sed 's/.fa.*//g' >> ../../all30mer.fa; done


#reformat 30mer file
cd ../../
awk '{getline x;print x;}1' all30mer.fa | sed 'N;s/\n/ /' | sed 's/>//g' | sort > gene_list_of_30mer.txt