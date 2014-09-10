genome_sampler
==============
The genome_sampler scripts allow you to sample a set of loci at random from resequenced genomes. These scripts will select random coordinates across the genome at a specified interval and return a BED file with a list of loci for sampling with downstream tools - i.e. using samtools/bcftools.

The script reads in the two files - a reference genome fai file (i.e. fasta index) and an annotation table with the chromosome, gene start position and gene stop position as separate columns. Two example files are provided here (from the Gasterosteus aculeatus reference genome) in order to help you test the scripts.

How does the script work? First it looks at the fai file and filters out any scaffolds which are smaller than the required interval. It then calls the function random_loci. This basically takes a random position between the start of chromosome and the interval and then extracts the coordinates for locus of the length specified. 

The script also tests whether there is any overlap between these extracted coordinates and an annotated gene. If so, it will try again. If not, it will look for the next loci. Once the whole genome is sampled, it will then write out a BED file - i.e. a file with a chromosome name, start coordinates and stop coordinates with a line for each loci. One can run the script from the command line using the following command:

[code language="bash"]
R --slave --args ref.fai annotate_table.txt 2000 500000 out.BED<cmd_generate_random_coords_050914.R
[/code]

Where 2000 and 500000 in this case tell the script to look for 2000 bp loci spaced at least 500 Kbp apart. 

