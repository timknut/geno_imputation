# Introduction
This repo will document and serve as code base for testing imputation accuracy of alternative imputation software like mimimac 3, Beagle etc.
This repo will also showcase the simple workflow one need to implement to impute with mentioned software and data formats.

## Links
### Imputation/Phasing
[minimac3](http://genome.sph.umich.edu/wiki/Minimac3)j

[Beagle4.1](https://faculty.washington.edu/browning/beagle/beagle.html)

[findhap](https://aipl.arsusda.gov/software/findhap/) from this [paper](https://www.ncbi.nlm.nih.gov/pubmed/26168789)

[Alphaimpute](http://www.alphagenes.roslin.ed.ac.uk/alphasuite-softwares/alphaimpute/)

### Phasing
[Shapeit](https://mathgen.stats.ox.ac.uk/genetics_software/shapeit/shapeit.html)

[WhatsHap](https://whatshap.readthedocs.io/en/latest/)

### Accuracy
Better measure of imputation accuracy, see [this paper](https://www.ncbi.nlm.nih.gov/pubmed/25045914)

## 2do
* Link to relevant raw data for testing. Tim suggests Affy 50k, Illumina HD 777k and the 153 full sequence data set.
* Implement: basic QC and cleaning pipeline. 
* Implement: plink --> ConformGT strand flip --> exclude common animals --> Impute
* Implement: N-fold cross validation code for Beagle and alternative. 
* Develop R-scrips to calculate correlation R^2 between true and imputed genotypes. 

## Further thougts
@argju Get some sleep, and please fill in.
