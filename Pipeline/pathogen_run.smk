'''
Main script for pathogen pipeline
Includes all Snakefiles and the config
'''
from os.path import basename
from os.path import join
from glob import glob


configfile: "config.yaml"
include: "bowtie2-build.smk"
include: "bowtie_index.smk"
include: "conversion_tools.smk"
include: "accession_conversion.smk"
	
basenames = [basename(x).split("_R1")[0] for x in glob(config["sample_dir"] + "*R1.fastq")]
	
rule all:
	input:
		expand(join(config["single_names"], "{sample}"), sample = basenames)
