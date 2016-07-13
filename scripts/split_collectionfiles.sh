#!/bin/bash

# Tim Knutsem
# Wed Jul 13 22:10:55 CEST 2016

## The raw data contained two concat. Genomematrix files. This script documents how they where split on the [Header] pattern.

# *_collection2
awk '/^\[Header\]/{
	x="../genotype_rawdata/illumina54k_v2/collection_Genomematrix_files/FinalReport_54kV2_collection2_"++i".txt";
	} {
	print > x;}' ../genotype_rawdata/illumina54k_v2/FinalReport_54kV2_collection2.txt

# collection_ed1
awk '/^\[Header\]/{
	x="../genotype_rawdata/illumina54k_v2/collection_Genomematrix_files/FinalReport_54kV2_collection_ed1_"++i".txt";
	} {
	print > x;}' ../genotype_rawdata/illumina54k_v2/FinalReport_54kV2_collection_ed1.txt
