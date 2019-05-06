"""
Runs visualization for mapped bam
"""

rule pileup:
    input:
        join(config["mapped_bam"], "{sample}.bam")
    output:
        join(config["workdir"], "pileup/{sample}.txt")
    params:
        sh = config["pileup"],
        pileup_mem = config["pileup_mem"]
    shell:
        "{params.sh} -Xmx{params.pileup_mem} in={input} out={output} -da"

rule remove_zero:
    input:
        join(config["workdir"], "pileup/{sample}.txt")
    output:
        join(config["workdir"], "results/alligned/{sample}"),
        join(config["tmp"], "{sample}.zero")

    script:
        config["exclude_py"]

rule get_total:
    input:
        join(config["mapped_bam"], "{sample}.bam")
    output:
        join(config["workdir"], "pileup/{sample}.tot")
    shell:
        "samtools view {input} -c -o {output}"

rule get_total_unidentified:
    input:
        join(config["workdir"], "pileup/{sample}_onlyCoverage.csv"),
        join(config["workdir"], "pileup/{sample}.tot")

    output:
        join(config["workdir"], "pileup/{sample}.csv")
    script:
        config["get_total"]

rule visualize:
    input:
        indir = join(config["workdir"], "results/alligned/"),
        touch = expand(join(config["tmp"], "{sample}.zero"), sample=config["basenames"])
    params:
        height = config["result_height"],
        width = config["result_width"]
    output:
        join(config["results"], "barplot.png")
    run:
        from snakemake.utils import R
        R("""
        library(ggplot2)
        png("{output}", width = {params.width}, height = {params.height}, units = 'px')
        li <- list.files('{input.indir}')
        vector <- c()
        for (file in li) {
        f <- read.csv(paste('Pipeline/Rtest/', file, sep = ""), sep = "\t")
  
        len <- f$Covered_bases
        len <- length(len)
        vector <- c(vector, len)
        }

        df <- data.frame(samples=li, alligned_pathogens=vector)

        p<-ggplot(data=df, aes(x=samples, y=alligned_pathogens, fill=samples))+
        geom_bar(stat = "identity") +
        xlab("Sample")+
        ylab("Amount of alligned pathogens")+
        geom_text(aes(label=alligned_pathogens), vjust=1.6, color="white",
            position = position_dodge(0.9), size=3.5)+
        theme_minimal()+
        theme(axis.text.x=element_blank())
        """)
    

