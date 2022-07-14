#!/bin/bash

#commands used to create a blastdb for each new reference, and then query them for retrocopies present in 'retrocopy.fa'

makeblastdb -in great_dane.fna -dbtype nucl -out great_dane

blastn -db great_dane.fna -query retrocopy.fa -out output.txt -outfmt "6 qseqid sseqid pident qlen length mismatch gapopen qstart qend sstart send evalue bitscore"
