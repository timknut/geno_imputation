#!/bin/bash

# Tim Knutsen
# Mon Jul 11 21:21:08 CEST 2016

# Script takes an illumina Finalreport in GenomeList format and outputs 
# a plink *.ped file automatically named infile.ped. Convertion is done by calling
# ioSNP.py present in this folder.

infile=$1
outfile=$(basename $1 .txt).ped 
ioSNP=snptranslate/ioSNP.py


# Test outfile
# echo $outfile


