#!/usr/bin/env Rscript
library(ggplot2)
args = commandArgs(trailingOnly=TRUE)

out_params <- tail(args, n=3)
png(out_params[1], height = as.numeric(out_params[2]), width = as.numeric(out_params[3]), units = 'px')
vector <- c()
basenames <- c()
x <- 1
while (!x > (length(args) - 3)) {
  f <- read.csv(args[x], sep = "\t")
  
  len <- f$Covered_bases
  len <- length(len)
  vector <- c(vector, len)
  basenames <- c(basenames, basename(args[x]))
  x <- x + 1
}

df <- data.frame(samples=basenames, alligned_pathogens=vector)

p<-ggplot(data=df, aes(x=samples, y=alligned_pathogens, fill=samples))+
  geom_bar(stat = "identity") +
  xlab("Processed Sample")+
  ylab("Amount of alligned pathogens")+
  ggtitle("Alligned pathogens within pipeline")+
  geom_text(aes(label=alligned_pathogens), vjust=1.6, color="white",
            position = position_dodge(0.9), size=3.5)+
  theme_minimal()

p

dev.off()