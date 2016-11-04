#!/bin/bash

# Date Wed Jul  6 15:45:40 CEST 2016 
# Tim Knutsen

folder=collection2
tempfile=$(mktemp)
# grep the date and Chip from each file.
egrep -H  "Processing Date|Content" ${folder}/*  > date_and_chip_${folder}.txt
# Reformat tabs
cat date_and_chip_${folder}.txt  | tr -s "\t" > $tempfile && mv $tempfile date_and_chip_${folder}.txt

# grep the samples and filename
#cd $folder
#egrep -A1  "\[Data\]" * | grep "new.*.txt-" | sed 's/-//' > ../file_and_samples_${folder}.txt
#cd ..

# Do rest in R 
