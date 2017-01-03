Table of Contents
=================

  * [Table of Contents](#table-of-contents)
  * [Geno imputation](#geno-imputation)
    * [Purpose of this reposiory](#purpose-of-this-reposiory)
    * [Rules](#rules)
  * [NB! Validate that Tim's <a href="https://en.wikipedia.org/wiki/Tacit_knowledge">tacit knowledge</a> is accounted for!](#nb-validate-that-tims-tacit-knowledge-is-accounted-for)
  * [Pipeline](#pipeline)
    * [Split collection files.](#split-collection-files)
    * [Common folder tree](#common-folder-tree)
    * [Automatically summarize raw data in folder tree.](#automatically-summarize-raw-data-in-folder-tree)
    * [Prepare marker map files.](#prepare-marker-map-files)
      * [Convert annotation file to map file accepted by ioSNP.py](#convert-annotation-file-to-map-file-accepted-by-iosnppy)
    * [Convert raw-data.](#convert-raw-data)
      * [Affymetrix 55K](#affymetrix-55k)
      * [Illumina](#illumina)
    * [Merge converted plink files](#merge-converted-plink-files)
    * [QC of converted raw data <strong>before</strong> imputation.](#qc-of-converted-raw-data-before-imputation)
      * [Suggestions for filtering:](#suggestions-for-filtering)
    * [Convert to alphaimpute format](#convert-to-alphaimpute-format)
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
# NB! Validate that Tim's [tacit knowledge](https://en.wikipedia.org/wiki/Tacit_knowledge) is accounted for!
- [ ] **Flipping**: Illumina 50K and 777k should be flipped to the forward strand. She lists in chip-folders on the Dropbox Geno_sharing. Flipping is done by Paolo with `plink --flip`
- [ ] **Remap 25k markers on affy 50k** Convertion list `final_corrected_Affy25K_on_50K.txt` in Dropbox.
- [ ] **Correct subsetting of Affy 50k markers.** See list in Affy50k Dropbox folder. `final_list_to_Paolo_may_2016_affy50k_markers2_keep`
- [ ] **Markers wrongly positioned because of assembly problems** See `assembly_fail_markers_to_exclude_*` in affy50k and illumina 777k folders in Dropbox.
- [ ] **Have Paolo recieved and included the latest Affymetrix data?**
- [ ] **Keep most recent or higher density sample** when same sample is genotyped on same or several platforms. 

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

```bash
# Code to go from the raw data at ftpgeno.geno.no:/avlgeno/Raw_Data_Files to the common code tree
# ftp download raw data to $ftpgeno and gunzip files
ftpgeno=/mnt/users/gjuvslan/geno/geno_imputation/ftpgeno
cd genotype_rawdata
mkdir -p illumina25k illumina54k_v1 illumina54k_v2 illumina54k_v2/collections illumina777k affymetrix54k
ln -s -t illumina25k $ftpgeno/Raw_Data_Files/FinalReport_25k.txt
ln -s -t illumina54k_v1 $ftpgeno/Raw_Data_Files/FinalReport_54kV1*
ln -s -t illumina54k_v2 $ftpgeno/Raw_Data_Files/FinalReport_54kV2*
ln -s -t illumina54k_v2/ $ftpgeno/Raw_Data_Files/Nordic_*
ln -s -t illumina54k_v2/ $ftpgeno/Raw_Data_Files/Swedish_54k_ed1.txt 
mv illumina54k_v2/FinalReport_54kV2_collection* illumina54k_v2/collections
ln -s -t illumina777k $ftpgeno/Raw_Data_Files/FinalReport_777k*
ln -s -t affymetrix54k/ $ftpgeno/Raw_Data_Files/Batch*.calls.txt 
cd ..
```

## Split collection files.
Some of the files are collections of Illumina MATRIX-format files. See eg. `genotype_rawdata/FinalReport_54kV2_collection2.txt`. The script [split_collectionfiles.sh](scripts/split_collectionfiles.sh) shows how this was done in Tims version of the REPO.

```bash
# Split the collections, ~2 min
cd genotype_rawdata/illumina54k_v2/collections/
awk '/^\[Header\]/{x=FILENAME"."++i} {print >x;}' FinalReport_54kV2_collection_ed1.txt
awk '/^\[Header\]/{x=FILENAME"."++i} {print >x;}' FinalReport_54kV2_collection2.txt
mv FinalReport_54kV2_collection_ed1.txt Collection_FinalReport_54kV2_collection_ed1.txt
mv FinalReport_54kV2_collection2.txt Collection_FinalReport_54kV2_collection2.txt
cd ../../..
```

## Automatically summarize raw data in folder tree. 
See [produce_list.sh](genotype_rawdata/summarize_rawdata/produce_list.sh) and [parse_date_chip_sample_collection2.r](genotype_rawdata/summarize_rawdata/parse_date_chip_sample_collection2.r) for a suggestion on how to do this.

**Produces the folllowing table:**

|sample_id     |processing_date     |chip           |file_path       |file |
|:-------------|:-------------------|:--------------|:---------------|:----|
|11210365_2029 |2015-08-27 13:31:00 |BovineSNP50_v2 |collection2/xaa |xaa  |
|11210181_1098 |2015-08-27 13:31:00 |BovineSNP50_v2 |collection2/xaa |xaa  |
|15670347_1067 |2015-08-27 13:31:00 |BovineSNP50_v2 |collection2/xaa |xaa  |
|16366250_1562 |2015-08-27 13:31:00 |BovineSNP50_v2 |collection2/xaa |xaa  |
|16538211_637  |2015-08-27 13:31:00 |BovineSNP50_v2 |collection2/xaa |xaa  |
|16366330_1103 |2015-08-27 13:31:00 |BovineSNP50_v2 |collection2/xaa |xaa  |

```bash
#grep Illumina FinalReports for headers, normalize whitespace and create table
grep -A 8 -m 1 "\[Header" illumina*/*/Final* illumina*/Final* | grep -v -e "\[" -e "--" > tmp
sed -i -e s/Processing\\t/Processing" "/g -e s/Num\\t/Num" "/g -e s/Total\\t/Total" "/g tmp
sed -i -e s/GSGT\\t/GSGT" "/g -e s/2010\\t/2010" "/g -e s/54\\t/54" "/g tmp
sed -i -e s/bovinehd-manifest-b.bpm/bovinehd_manifest_b.bpm/g -e 's/\r$//' tmp
cat tmp | sed -e s/-/\\t/g -e s/\\t\\t/\\t/g > illumina_headers

## grep Illumina FinalReports for ids, normalize whitespace and create table of filenames and ids
# 1. files in GenomeMatrix format
matrixfiles=illumina54k_v2/collections/*" "illumina777k/FinalReport_777k_apr2015.txt" "illumina777k/FinalReport_777k_jun2015.txt" "illumina54k_v2/FinalReport_54kV2_nov2011_ed1.txt" "illumina777k/FinalReport_777k.txt
grep -A 1 -m 1 "\[Data" $matrixfiles | grep -v -e "\[Data" -e "--" > tmp 
sed -i -e s/FinalReport_777k.txt-2402/FinalReport_777k.txt-\\t2402/g tmp #FinalReport_777k.txt lacks tab before first ID
cat tmp | sed -e s/-//g -e s/[[:space:]]/\\t/g | awk '{for(i=2;i<=NF;i++) print $1,$i}' > illumina_ids

# 2. files in GenomeList format (~5 min)
listfiles=illumina54k_v1/Final*" "illumina54k_v2/FinalReport_54kV2_feb2011_ed1.txt" "illumina54k_v2/FinalReport_54kV2_genoskan.txt" "illumina54k_v2/FinalReport_54kV2_ed1.txt" "illumina777k/FinalReport_777k_jan2015.txt
time for file in $listfiles; do echo $file; time -p tail -n +11 $file | awk '{print $2}' | uniq | awk -v f=$file '{print f,$1}' >> illumina_ids ; done

#Affymetrix reports
grep -E "time-str|chip-type|cel-count" affymetrix54k/Batch* > tmp
sed -i -e s/:#%/\\t/g -e s/affymetrix-algorithm-param-apt-//g -e s/=/\\t/ tmp
sed -e s/time-str/Date/g -e s/opt-chip-type/Chip/g -e s/opt-cel-count/Nsamples/g tmp > affymetrix_headers

grep probeset affymetrix54k/Batch* | awk '{for (i=2; i<=NF; i++) print $1"\t"$i}' > tmp
sed -e s/:probeset//g -e s/_[A-Z][0-9]*.CEL// tmp > affymetrix_ids
```

## Prepare marker map files.  
ioSNP.py will create the plink map file, which is a better solution than doing it manually in R.

### Convert annotation file to map file accepted by ioSNP.py
Annotation files can be [downloaded from SNPchimp](http://bioinformatics.tecnoparco.org/SNPchimp/index.php/download/download-cow-data). After `gunzipping`, something like the following creates the .map annotation file needed. 

```sh
awk 'NR > 1 {print $4,$6,0,$5}' OFS='\t' illumina54k_v2_annotationfile.txt > illumina54k_v2_annotationfile.map
```
## Convert raw-data.
1. Describe convertion workflow and location of scripts.

### Affymetrix 55K
Use snptranslate-script from https://github.com/timknut/snptranslate/blob/master/seqreport_edit.py

usage: `seqreport.py -m genotype_rawdata/marker_mapfiles/affy50k_annotation_final_list_20160715.txt -r [dummy reportfilename] -o outfile_semi.ped [Affy .call file]`

2. Define file structure for converted data.

### Illumina
Use `scripts/Genome_2_plink.sh` : 

Script takes an illumina Finalreport in standard (GenomeList) or Matrix (Genomematrix) format and outputs
a plink *.ped and *.map file automatically named plink_format/[infile].ped/map
See the [Genomestudio documentation](http://support.illumina.com/content/dam/illumina-support/documents/documentation/software_documentation/genomestudio/genomestudio-2-0/genomestudio-genotyping-module-v2-user-guide-11319113-01.pdf) page 61. for details. 
Convertion is done by calling snptranslate present in this repo.

Usage: `sh scripts/Genome_2_plink.sh [FinalReport file] [input-format](Genomelist or Genomematrix) [markerfile]`

## Merge converted plink files
See the [plink documentation](https://www.cog-genomics.org/plink2/data#merge) for more information.
Given a file that list file prefixes that are to be merged with a plink binary file-set, the following command would work.
```sh
plink --cow --bfile inprefix --merge-list file_list.txt --out all_merged
```

## QC of converted raw data **before** imputation. 
### Suggestions for filtering:
* Missingess per animal. 90 % 
* Missingness per SNP 90 %
* HWE p < 1e-7
* MAF < 0.01
* Mendelian error filtering per SNP and animal. (Although AlphaImpute do a good job at this.)
* Heterozygosity per animal
Example plink command: `plink --bfile infile --cow --hwe 1e-7 --maf 0.01 --geno 0.90 --mind 0.90`

## Convert to alphaimpute format

See Paolos [script](https://github.com/timknut/geno_imputation/blob/master/scripts/plink2_alphaimpute.Rmd). In addition to this, do a chromsomoe loop in plink and do something like `for i in seq 1 29; do plink --recode A --chr $i --cow --bfile prefix --out prefix.$i.raw; done`

## Documentation and scripts for imputation.
Paolo: TODO
