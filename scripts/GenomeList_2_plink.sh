#!/bin/bash

# Tim Knutsen
# Mon Jul 11 21:21:08 CEST 2016

# Script takes an illumina Finalreport in GenomeList format and outputs 
# a plink *.ped file automatically named infile.ped. Convertion is done by calling
# snptranslate present in this repo.

# Usage: sh GenomeList_2_plink.sh [FinalReport file]

prefix=/mnt/users/tikn/for_folk/geno # Guess we need to have two prefixes and uncomment based on who is using it. Tim  
#prefix= # Guess we need to have two prefixes and uncomment based on who is using it. Paolo 

infile=$1
outfile=$(basename $1 .txt).ped 
ioSNP=${prefix}/geno_imputation/scripts/snptranslate/ioSNP.py

# Test outfile
echo "Writing $outfile" 

"$ioSNP" -i "$infile" -n Genomelist -o "$outfile" -u Plink
