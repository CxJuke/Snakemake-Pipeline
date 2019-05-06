def create_done(out_file):
    f = open(out_file, "w")
    f.close()


def remove_zero(f, out_file, dummy):
    """
    This function removes the lines that have 0% coverage.
    When the fifth element is 0.0000, it means the coverage is 0%.
    """
    #open the inputfile and read the lines
    openf = open(f, "r")
    lines = openf.readlines()

    openf.close()
	
    #open the inputfile as write
    open_out_file = open(out_file, "w")
    for line in lines:
        #file is tab seperated, get all elements
        splitted = line.split("\t")
        #if the fifth element is 0.0000, coverage is 0%
        if splitted[4] == "0.0000":
            #dont write it back to the file
            pass
        else:
			#if the fifth element something else, write the line back
            open_out_file.write(line)
    create_done(dummy)
    

remove_zero(snakemake.input[0], snakemake.output[0], snakemake.output[1])