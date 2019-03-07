#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args)==0) {
       	stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
	# default output file
	args[2] = "out.txt"
}
createHeatmap <- function(input, output){
	d <- as.matrix(read.csv(input, header=FALSE, sep=",")[-1,-1])
       rownames(d) <- read.csv(input, header=FALSE, sep=",")[-1,1]
        colnames(d) <- read.csv(input,  header=FALSE, sep=",")[1,-1]       

	png(filename=output)
        heatmap(d)
}

createHeatmap(args[1], args[2])
