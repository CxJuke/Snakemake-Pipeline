#!/usr/bin/env python3

import pickle
"""
Create a genome dictionary for accession conversion
"""

def save_dict(dictionary, output):
	with open(output, "wb+") as f:
		pickle.dump(dictionary, f, pickle.HIGHEST_PROTOCOL)
		
def get_Genomes(pathogen_fasta):
	genomedict = {}
	with open(pathogen_fasta) as AllGenomes:
		for line in AllGenomes:
			if line.startswith(">gi"):
				genome = line.split(">")[1].split(",")[0]
				refname = genome.split("| ")[0]
				organism = genome.split("| ")[1]
				genomedict[refname] = organism
			
			elif line.startswith(">JPKZ") or line.startswith(">MIEF") or line.startswith(">LL") or line.startswith(">AWXF") or line.startswith("EQ") or line.startswith(">NW_") or line.startswith(">LWMK") or line.startswith(">NZ_") or line.startswith(">NC_") or line.startswith(">KT"):
				genome = line.split(">")[1].split(",")[0]
				refname = genome.split(" ")[0]
				organismName = genome.split(" ")[1:]
				organism = ' '.join(organismName)
				genomedict[refname] = organism	

	return genomedict

save_dict(get_Genomes(snakemake.input[0]), snakemake.output[0])
