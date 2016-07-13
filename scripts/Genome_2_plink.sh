#!/bin/bash

# Tim Knutsen
# Mon Jul 11 21:21:08 CEST 2016

set -o nounset   # Prevent unset variables from been used.
set -o errexit   # Exit if error occurs

# Add simple usage instructions. 
display_usage() {
	echo
	echo -e "Script takes an illumina Finalreport in GenomeList or Genomematrix format and outputs"
	echo "a plink *.ped and *.map file automatically named plink_format/[infile].ped/map"
	echo "Convertion is done by calling snptranslate present in this repo." 
	echo -e "\nUsage: sh $0 [FinalReport file] [input-format](Genomelist or Genomematrix) [markerfile] \n"
}	 

# if less than 3 arguments supplied, display usage 
if [  $# -le 2 ]
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
ioSNP=${prefix}/geno_imputation/scripts/snptranslate/ioSNP.py

infile=$1
informat=$2
infiledir=$(dirname "$infile")
mkdir -p ${infiledir}/plink_format
outfile=${infiledir}/plink_format/$(basename $1 .txt).ped 
outfile2=${infiledir}/plink_format/$(basename $1 .txt).map
#markerfile=${prefix}/geno_imputation/genotype_rawdata/marker_mapfiles/illumina54k_v2_annotationfile.map
markerfile=$3

# Test outfile
echo "Writing $outfile and $outfile2. Using $markerfile" 

"$ioSNP" -i "$infile" -n $informat -o "$outfile" -u Plink --output2 $outfile2 -m $markerfile
