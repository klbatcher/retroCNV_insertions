# Canine RetroCNV

## Supplemental Code for Batcher et al. 2022, "Recent, full-length gene retrocopies are common in canids"

The file 'locations.txt' contains the gene name, 30mer count, location, and whether or not a reference retrocopy exists for each gene
The file 'ncbi_refseq_exons.bed' is the bed formatted location of all gene exons in CanFam3. They are used as discordant targets by tebreak.
The file 'telomeremask.bed' is the bed formatted location of telomeres which are masked while running tebreak.
The file 'retrogeneDB_locations.bed' is a list of retrocopies in the canfam3 reference genome obtained from retrogeneDB.
Files used to reproduce circos plots and ideogram plots are included.

## Scripts

download_sra.sh: Download data from the sequence read archive and convert to bam format. Requires sratoolkit.

align.sh: Align illumina paired-end FASTQ files to a reference. Requires minimap2 and samtools.

make_kmers.sh: Produce a list of mRNA specific 30-mers for retroCNV discovery. The files "gene_list_of_30mer.txt", "all30mer.fa", and "ncbi_fix.fa" are used for downstream analysis. Requires gffread, jellyfish, and mrsfast. 

find_parent_genes.sh: Identify a list of retroCNV parent gene candidantes from whole genome sequencing data. Requires jellyfish and samtools.

run_tebreak.sh: Identify discordant read clusters using tebreak. Requires tebreak.

combine_tables.sh: Filter and combine files produced by find_parent_genes.sh and run_tebreak.sh to produce a list of putitive retroCNV parent genes and insertion sites for further analysis. Also counts the total occurance of each parent gene.

run_delly.sh: Identify retroCNV present in the reference assembly. Locations of canfam3 retrocopies provided by "retrogeneDB_locations.bed". Requires delly, samtools and bcftools.

run_blast.sh: Commands used to query alternative references for retroCNV locations.

retroCNV_variant_calling.sh: Identify variants accross the parent gene sequences for retroCNV specific SNV analysis. Requires bcftools.

ideogram.R: R commands used to produce ideogram in supplemental figure S2. 

####pacbio scripts

