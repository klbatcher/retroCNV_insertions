#!/bin/bash

#requires sratoolkit and aspera-connect
#given a sequence run accession, download the data from the sequence read archive and covert to bam format

prefetch -X 500G SRRxxxx --transport ascp -a asperaweb_id_dsa.putty
sam-dump SRRxxxx | samtools view -bS > SRRxxxx.bam
