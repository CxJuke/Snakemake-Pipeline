#!/usr/bin/env python3

def get_total(infile, outfile):
    with open(infile, "r") as f:
        lines = 0
        for line in f:
            if line.strip():
                lines += 1
        
        lines -= 1
        f.close()

    f = open(outfile, "w")
    f.write(str(lines))
    f.close()

get_total(snakemake.input[0], snakemake.output[0])
    

