# Create rtiger environment
conda create -n test_rtiger
conda activate test_rtiger

# Install R and its dependencies
mamba install -c conda-forge -c bioconda r r-base r-knitr r-rcpp
mamba install -c conda-forge -c bioconda bioconductor-genomicranges bioconductor-genomeinfodb bioconductor-iranges bioconductor-gviz
mamba install -c conda-forge -c conda-forge -c bioconda r-e1071 r-extradistr r-reshape2 r-qpdf
mamba install -c conda-forge -c dnachun r-tailrank

Install julia 1.0.5 from https://julialang.org/downloads/oldreleases/ and ensure that it is in the PATH
#mamba install -c conda-forge julia=1.0.3
# Delete any old julia packages. NOTE: this may break any other installed julia program
cd ~
rm -r .julia
## start julia
#julia
## Install julia dependencies in the julia terminal
using Pkg
Pkg.add("RCall")
Pkg.build("RCall")
#Pkg.add.(["Optim", "Distributions", "LinearAlgebra", "CSV", "DelimitedFiles", "DataFrames"])

# Open R and install juliacall
install.packages("JuliaCall")

# Download and install RTIGER
cd /folder/to/download/rtiger
git clone https://github.com/schneebergerlab/RTIGER.git
cd RTIGER
R CMD build .
R CMD INSTALL RTIGER_2.1.0.tar.gz

## Get Julia path
#$ which julia
#PATH/TO/JULIA

# Open R and run
library(RTIGER)
setupJulia('PATH/TO/JULIA/BINARY')      # Required only once. Not required if julia packages are installed from within Julia
#setupJulia(JULIA_HOME='/srv/netscratch/dep_mercier/grp_schneeberger/software/julia-1.0.5/bin/')      # Required only once. Not required if julia packages are installed from within Julia
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