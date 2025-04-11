# pep2geneID

pep2geneID is a simple Rscript to convert the FASTA headers of an amino acid file from the peptide ID to gene ID, using ENSEMBL.
The script was built to convert the peptide ID's of *Aspergillus fumigatus* strain A1163 to their corresponding gene ID's.

## Requirements

### Software

- R (≥ 4.0)
- Internet connection

### R Packages

The following R packages are required:

- `biomaRt`
- `seqinr`
- `optparse`

You can install them using the following commands in R:

```r
install.packages("optparse")
install.packages("seqinr")
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("biomaRt")
```

## Installation

pep2geneID can be "installed" by simply downloading the script ```pep2geneID.R``` .


## Usage

pep2geneID can be used on the command line like so:

```bash
Rscript /your/path/pep2geneID.R -f your-peptides.faa -o your-output.faa
```

If you are using this for a different species/strain you can supply the appropriate dataset using the following options (in full transparency I have not extensively tested this):

```bash
# Aspergillus fumigatus Af293
Rscript /your/path/pep2geneID.R -f your-peptides.faa -o your-output.faa --ensembl_host https://fungi.ensembl.org --ensembl_biomart fungi_mart --ensembl_dataset afumigatus_eg_gene
# Candida albicans
Rscript /your/path/pep2geneID.R -f your-peptides.faa -o your-output.faa --ensembl_host https://fungi.ensembl.org --ensembl_biomart fungi_mart --ensembl_dataset calbicans_eg_gene
# Candida auris
Rscript /your/path/pep2geneID.R -f your-peptides.faa -o your-output.faa --ensembl_host https://fungi.ensembl.org --ensembl_biomart fungi_mart --ensembl_dataset cauris_eg_gene
# Cryptococcus neoformans
Rscript /your/path/pep2geneID.R -f your-peptides.faa -o your-output.faa --ensembl_host https://fungi.ensembl.org --ensembl_biomart fungi_mart --ensembl_dataset cneoformans_eg_gene
# Homo sapiens
Rscript /your/path/pep2geneID.R -f your-peptides.faa -o your-output.faa --ensembl_host https://www.ensembl.org --ensembl_biomart genes --ensembl_dataset hsapiens_gene_ensembl
```

Some peptide ID's may end in ".1". In the human example above, FASTA headers like "ENSP00000452345.1" need to be converted to "ENSP00000452345".
A simple way to do this is to cut the file:
```bash
cut -d'.' -f1 your-peptides.faa > your-peptides.trimmed.faa
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.


## Acknowledgements

This project was inspired by examples from the Bioconductor `biomaRt` vignette, available at:  
https://bioconductor.org/packages/release/bioc/vignettes/biomaRt/inst/doc/accessing_ensembl.html

For full details on which datasets to use, see the vignette above. A selection of human fungal pathogens have been shown in the examples above.


## License

[MIT](https://choosealicense.com/licenses/mit/)

