Table of Contents
=================

  * [Table of Contents](#table-of-contents)
  * [Geno imputation](#geno-imputation)
    * [Purpose of this reposiory](#purpose-of-this-reposiory)
    * [Rules](#rules)
  * [Pipeline](#pipeline)
    * [Common folder tree](#common-folder-tree)
    * [Prepare marker map files.](#prepare-marker-map-files)
      * [Convert annotation file to map file accepted by ioSNP.py](#convert-annotation-file-to-map-file-accepted-by-iosnppy)
    * [Convert raw-data.](#convert-raw-data)
      * [Affymetrix 55K](#affymetrix-55k)
    * [QC of converted raw data <strong>before</strong> imputation.](#qc-of-converted-raw-data-before-imputation)
      * [Suggestions for filtering:](#suggestions-for-filtering)
    * [Documentation and scripts for imputation.](#documentation-and-scripts-for-imputation)

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
## Common folder tree
Look like this in Tims local repo, as of july 14. 2016.
```sh
tikn@login-0:~/for_folk/geno/geno_imputation/genotype_rawdata$ tree -d
.
├── affymetrix_54k
│   └── plink_format
├── illumina25k
│   └── plink_format
├── illumina54k_v1
│   └── plink_format
├── illumina54k_v2
│   ├── collection_Genomematrix_files
│   │   └── plink_format
│   └── plink_format
├── illumina777k
│   └── plink_format
├── marker_mapfiles
└── summarize_rawdata
    ├── collection2
    └── edited_FinalReport_54kV2_collection_ed1

16 directories

```
## Prepare marker map files.  
ioSNP.py will create the plink map file, which is a better solution than doing it manually in R. 
### Convert annotation file to map file accepted by ioSNP.py
Annotation files can be [downloaded from SNPchimp](http://bioinformatics.tecnoparco.org/SNPchimp/index.php/download/download-cow-data)
After `gunzipping`, something like the following creates the .map annotation file needed. 
```sh
awk 'NR > 1 {print $4,$6,0,$5}' OFS='\t' illumina54k_v2_annotationfile.txt > illumina54k_v2_annotationfile.map
```
## Convert raw-data.
1. Describe convertion workflow and location of scripts.

### Affymetrix 55K
Use snptranslate-script from https://github.com/timknut/snptranslate/blob/master/seqreport_edit.py

usage: `seqreport.py -m genotype_rawdata/marker_mapfiles/affy50k_annotation_final_list_20160715.txt -r [dummy reportfilename] -o outfile_semi.ped [Affy .call file]`

2. Define file structure for converted data.

## QC of converted raw data **before** imputation. 
### Suggestions for filtering:
* Missingess per animal. 90 % 
* Missingness per SNP 95 %
* HWE p < 1e-7
* Mendelian error filtering per SNP and animal. (Although AlphaImpute do a good job at this.)
* Heterozygosity per animal

## Documentation and scripts for imputation.
