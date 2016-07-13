#!/bin/bash

# Tim Knutsen
# Mon Jul 11 21:21:08 CEST 2016

# Add simple usage instructions. 
display_usage() {
	echo
	echo -e "Script takes an illumina Finalreport in GenomeList format and outputs"
	echo "a plink *.ped file automatically named [infile].ped. Convertion is done by calling"
	echo "snptranslate present in this repo." 
	echo -e "\nUsage: sh $0 [FinalReport file] \n"
}	 

# if less than two arguments supplied, display usage 
if [  $# -le 1 ]
	then
	display_usage
	exit 1
fi 

# check whether user had supplied -h or --help . If yes display usage 
if [[ ( $# == "--help") ||  $# == "-h" ]]
	then 
	display_usage
	exit 0
fi 

prefix=/mnt/users/tikn/for_folk/geno # Tim  
#prefix=/Users/paolo/Documents/Roslin/Geno_project/git_imputation/ # Paolo 

infile=$1

outfile=$(basename $1 .txt).ped 
ioSNP=${prefix}/geno_imputation/scripts/snptranslate/ioSNP.py

# Test outfile
echo "Writing $outfile" 

"$ioSNP" -i "$infile" -n Genomelist -o "$outfile" -u Plink
