#!/usr/bin/env Rscript
## ---------------------------
##
## Script name: pep2geneID.R
##
## Purpose of script: Convert peptide ID's from amino acid FASTA file to gene ID's
##
## Author: Dr. Harry Chown
##
## Date Created: 11-04-2025
##
## Copyright (c) Harry Chown, 2025
## Email: h.chown@imperial.ac.uk
##
## ---------------------------
##
## Notes: Requires the following installed packages. 
##        Tested using the appropriate version numbers in R 4.1.2.
##        Script is in dev mode only.
##        Defaults will investigate peptide/gene ID's from Aspergillus fumigatus
##        strain A1163, using Ensembl Fungi.
##        To alter the database used check the following:
##        https://bioconductor.org/packages/release/bioc/vignettes/biomaRt/inst/doc/accessing_ensembl.html
##   
##
## ---------------------------

# Load required packages
library("biomaRt") # v2.50.3
library("seqinr") # v4.2-36
library("optparse") # v1.7.5

# Establish inputs
option_list = list(
  make_option(c("-f", "--faa"), type="character", default=NULL, 
              help="Input amino acid file in FASTA format", metavar="character"),
  make_option(c("-o", "--out"), type="character", default="out.faa", 
              help="Output amino acid file", metavar="character"),
  make_option(c("--ensembl_host"), type="character", default="https://fungi.ensembl.org", 
              help="ENSEMBL Web Host", metavar="character"),
  make_option(c("--ensembl_biomart"), type="character", default="fungi_mart", 
              help="ENSEMBL Biomart", metavar="character"),
  make_option(c("--ensembl_dataset"), type="character", default="afumigatusa1163_eg_gene", 
              help="ENSEMBL Dataset", metavar="character")
); 
opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

if (is.null(opt$faa)){
  print_help(opt_parser)
  stop("An input amino acid file is required", call.=FALSE)
}


# Read amino acid file
faa_data <- read.fasta(file=opt$faa, seqtype = "AA")
# Set up an ENSEMBL dataset
ensembl <- useEnsembl(host=opt$ensembl_host, 
                        biomart=opt$ensembl_biomart, 
                        dataset= opt$ensembl_dataset)
# Query the dataset to return a dataframe of peptide ID's and matching gene ID's
pep2gene_key <- getBM(attributes = c('ensembl_peptide_id', 'ensembl_gene_id'),
      filters = 'ensembl_peptide_id',
      values = names(faa_data), 
      mart = ensembl)
# Rename amino acid file
renamed_names <- unname(setNames(pep2gene_key$ensembl_gene_id, pep2gene_key$ensembl_peptide_id)[names(faa_data)])
names(faa_data) <- renamed_names
# Save renamed file
write.fasta(sequences = faa_data, names = names(faa_data), nbchar = 80, file.out = opt$out)
