Table of Contents
=================

  * [Geno imputation](#geno-imputation)
    * [Purpose of this reposiory](#purpose-of-this-reposiory)
    * [Rules](#rules)
  * [Pipeline](#pipeline)
    * [Make plink map files.](#make-plink-map-files)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

# Geno imputation
Welcome to the Geno Imputation github repository. We want this to b a common code base for developing the genotype reference for Geno imputed with AlphaImpute. 

## Purpose of this reposiory
**Our goal** is to write scripts that both document and does the convertion from Chip raw-data and imputation. We should be able to run the scripts regardless of if we are sitting in Ås or Edinburg.

## Rules
1. Add a user specific `prefix` to all scripts that refer to programs or data outside the `geno_imputation` folder. 

**Example:**

```sh
prefix=/mnt/users/tikn/for_folk/geno #  Tim  
#prefix=/some/Roslin/path #  Paolo 

infile=$1
outfile=$(basename $1 .txt).ped 
ioSNP=${prefix}/geno_imputation/scripts/snptranslate/ioSNP.py

"$ioSNP" -i "$infile" -n Genomelist -o "$outfile" -u Plink
```
# Pipeline
Link to other .md docs,, or have everything here with a big TOC at the top. 
## Make plink map files.
See [this markdown ](https://github.com/timknut/geno_imputation/blob/master/scripts/prepare_plink_map_example.md). We make one `Rmd` like this for every chip type.

**UPDATE** 
Paolo #1 hinted that ioSNP.py will create the plink map file, which is a better solution. 
Convert annotation file to map file accepted by ioSNP.py

```sh
awk 'NR > 1 {print $4,$6,0,$5}' OFS='\t' illumina54k_v2_annotationfile.txt > illumina54k_v2_annotationfile.map
```

