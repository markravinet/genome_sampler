### R script to generate random coordinates in genome ###
## Mark Ravinet, National Institute of Genetics, Japan ##
## 5th September 2014 ##

rm(list = ls())
library(plyr)
source("genom_coord_gen_source.R")

# read in stickleback fai file
args <- commandArgs(TRUE)
infai <- args[1]
anno_tab <- args[2]
loc_size <- as.integer(args[3])
int <- as.integer(args[4])
outbed <- args[5]

sprintf("Sample genome for %s bp random loci at %s bp intervals", loc_size, int)

fai <- read.delim(infai, header = F)
names(fai) <- c("ref_seq", "seq_length", "base_offset", "fasta_base", "fasta_byte")

# read in annotations data
annotate <- read.delim(anno_tab, header = T)
ann <- data.frame(annotate$Chromosome.Name, annotate$Gene.Start..bp., annotate$Gene.End..bp.)
names(ann) <- c("chr", "gene_start", "gene_stop")

# filter out samples under the ref size
sprintf("Removing all scaffolds below %s bp", int)
chr_size <- fai[fai$seq_length > int, 1:2]

# sample reference coordinates
sample_loc <- apply(chr_size, 1, function(x) random_loci(x, locus_size = loc_size, interval = int, ann))
sample_loc <- do.call(rbind, sample_loc)
rownames(sample_loc) <- NULL
# # loci per chromosome
# ddply(sample_loc, "ref_seq", summarise, freq = length(ref_seq))
# total loci
sprintf("A total of %s loci sampled", nrow(sample_loc))

write.table(sample_loc, outbed, quote = FALSE, sep = "\t",
            row.names = FALSE, col.names = FALSE)






