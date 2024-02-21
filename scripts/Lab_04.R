# load packages----
library('tidyverse') # provides access to Hadley Wickham's collection of R packages for data science, which we will use throughout the course
library('tximport') # package for getting Kallisto results into R
library('ensembldb') #helps deal with ensembl
library('biomaRt') # an alternative for annotation

# Task 1----
# look at available marts
listMarts()
#choose the 'mart' you want to work with
myMart <- useMart(biomart='ENSEMBL_MART_ENSEMBL')
#take a look at all available datasets within the selected mart
available.datasets <- listDatasets(myMart)
# find ferret annotations ('mpfuro_gene_ensembl')
ferret.anno <- useMart(biomart='ENSEMBL_MART_ENSEMBL', dataset = 'mpfuro_gene_ensembl')
ferret.attributes <- listAttributes(ferret.anno)
# To find the desired attributes, look through attribute names:
View(ferret.anno@attributes[['name']])
Tx.ferret <- getBM(attributes=c('ensembl_transcript_id_version',
                                'chromosome_name',
                                'start_position',
                                'end_position',
                                'external_gene_name',
                                'description',
                                'entrezgene_id',
                                'pfam'),
                   mart = ferret.anno)

Tx.ferret <- as_tibble(Tx.ferret)

# Task 2----
# Learn how to use getSequence
?getSequence()
# Documentation: getSequence(chromosome, start, end, id, type, seqType, upstream, downstream, mart, useCache = TRUE, verbose = FALSE)
# Why does it only work the second time??
genesToFind <- c('IFIT2', 'OAS2', 'IRF1', 'IFNAR1', 'MX1')
promoterSequences <- getSequence(id=genesToFind, type='external_gene_name', seqType='gene_flank', upstream=1000, mart=ferret.anno)
