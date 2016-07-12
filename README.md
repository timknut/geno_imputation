# Geno imputation
Welcome to the Geno Imputation github repository. We want this to b a common code base for developing the genotype reference for Geno imputed with AlphaImpute. 

**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [Geno imputation](#)
	- [Purpose of this reposiory](#)
	- [Rules](#)
	- [Pipeline](#)

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
## Pipeline
Link to other .md docs,, or have everything here with a big TOC at the top. 
