git clone https://github.com/rfael0cm/RTIGER.git
cd RTIGER
#cd /srv/biodata/dep_mercier/grp_schneeberger/projects/RTIGER           # my test directory
conda create -n test_rtiger
conda activate test_rtiger
mamba install -c conda-forge r r-base r-knitr r-rcpp
mamba install -c conda-forge -c bioconda bioconductor-genomicranges
mamba install -c conda-forge -c bioconda bioconductor-genomeinfodb
mamba install -c conda-forge -c bioconda bioconductor-iranges
mamba install -c conda-forge -c bioconda bioconductor-gviz
mamba install -c conda-forge -c bioconda r-e1071 r-extradistr r-reshape2 r-juliacall r-qpdf
mamba install -c conda-forge -c dnachun r-tailrank

R CMD build .
R CMD INSTALL RTIGER_2.1.0.tar.gz

# Get Julia path
$ which julia
PATH/TO/JULIA

# Open R and run
library(RTIGER)
setupJulia('PATH/TO/JULIA/BINARY')      # Required only once
sourceJulia()
# Run test example
# Get paths to example allele count files originating from a
# cross between Col-0 and Ler accession of the A.thaliana
file_paths = list.files(system.file("extdata",  package = "RTIGER"), full.names = TRUE)
# Get sample names
sampleIDs <- basename(file_paths)

# Create the expDesign object
expDesign = data.frame(files=file_paths, name=sampleIDs)

# Get chromosome lengths for the example data included in the package
chr_len <- RTIGER::ATseqlengths
names(chr_len) <- c('Chr1' , 'Chr2', 'Chr3', 'Chr4', 'Chr5')

myres = RTIGER(expDesign = expDesign,
               outputdir = "/PATH/TO/OUPUT/DIRECTORY",
               seqlengths = chr_len,
               rigidity = 20,
               save.results = TRUE)
