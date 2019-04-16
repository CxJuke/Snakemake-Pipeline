#!/usr/bin/env python3

import pickle

"""
Getting the accession names using snakemake as caller.
"""

def load_dict(dict_location):
	with open(dict_location, 'rb') as f:
		return pickle.load(f)

accession_nrs = []

for line in open(snakemake.input[0]):
	accession_nrs.append(line.split("\t")[0])
	

pathogenNames = []
genomedict = load_dict(snakemake.input[1])
	
for number in accession_nrs:
	if number in genomedict:
		pathogenNames.append(genomedict[number])
			
open_output = open(snakemake.output[0], "w")
	
for i in pathogenNames:
	open_output.write(i, "\n")
	
open_output.close()
open_final = open(snakemake.output[1], "w")
output_file = open(snakemake.output[0], "r")
	
	
pathogens = []
	
for line in output_file:
	newline = line.split(" ")[:2]
	if newline in pathogens:
		pass
	else:
		pathogens.append(newline)
		
for pathogen in pathogens:
	open_final.write(' '.join(pathogen) + "\n")

open_final.close()
