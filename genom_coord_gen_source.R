### Custom functions for generating random loci from a reference genome ###

#### random_loci ####

# takes a dataframe of one row - with sequence name and
# sequence length - also requires user to specify locus
# size and sampling interval interval; also must provide
# an annotation table too

random_loci <- function(chr_size, locus_size, interval, ann){
 
  ref_seq <- chr_size[['ref_seq']]
  seq_length <- as.numeric(chr_size[['seq_length']])
  # first sample is completely random
  # note repeat loop here will keep sampling 
  # until an initial bp is found that is NOT in a gene
  repeat{
    initial_start <- sample(1:interval, 1)
    #initial_start <- sample(1:(seq_length-locus_size), 1)
    # stop is locus size bp from this point
    initial_stop <- initial_start + locus_size
    # start a dataframe with these coordinates
    coords <- data.frame(ref_seq, start_bp = initial_start, stop_bp = initial_stop)
    # check whether coords occur in a gene (returns TRUE if a hit is present )
    if(gene_hit_check(coords, ann) == FALSE) break
  }
  # next sample range is set at least interval size from
  # initial stop point
  sample_start <- (initial_stop + interval)
  # sample repeatedly from the chromosome until the sample start
  # position exceeds seq_length
  while(sample_start < seq_length){
    # as above, nested repeat loop ensures that proposed loci do not occur in regions
    # with gene annotations
    repeat{
      sample_start <- sample(sample_start:(sample_start+interval), 1)
      #sample_start <- sample(sample_start:seq_length, 1)
      sample_stop <- sample_start + locus_size
      new_coords <- data.frame(ref_seq, start_bp = sample_start, stop_bp = sample_stop)
      if(gene_hit_check(coords, ann) == FALSE) break
    }
    coords <- rbind(coords, new_coords)
    sample_start <- sample_stop + interval
  }
  # return a list of coordinates
  return(coords)
  
}

#### gene_hit_check ####

# function that takes loci coords, checking whether any gene hits occur
# returns TRUE if hits occur

gene_hit_check <- function(coords, ann){

  # first subset the annotation table for the chromosome being examine
  chr_ann <- ann[ann$chr %in% coords$chr, ]
  # then test whether coords overlap
  gene_hits <- sum(apply(chr_ann, 1, function(chr_ann) coords[2] >= chr_ann[2] && coords[2] <= chr_ann[3]))
  # return TRUE if gene hits occur
  return(gene_hits != 0)
  
}
