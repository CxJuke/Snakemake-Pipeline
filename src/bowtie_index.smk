"""
Rules for indexing genomes
"""


rule bowtie_to_human:
    input:
        human_index = config["human_index"],
        r1 = join(config["sample_dir"], "{sample}_R1.fastq"),
        r2 = join(config["sample_dir"], "{sample}_R2.fastq")
    params:
        unmapped = join(config["unmapped_dir"], "{sample}_%.fastq")
    output:
        unm_r1 = join(config["unmapped_dir"], "{sample}_1.fastq"),
        unm_r2 = join(config["unmapped_dir"], "{sample}_2.fastq"),
        sam = join(config["tmp"], "{sample}.sam")
    threads: config["threads_max"]
    log: join(config["log_dir"], "{sample}_human_run.log")
    message: "Running Bowtie2 for file {input.r1} against the human genome"
    shell:
        """
        (bowtie2 -p {threads} -x {input.human_index} -1 {input.r1} -2 {input.r2} --un-conc {params.unmapped} -S {output.sam} --no-unal --no-hd --no-sq) 2> {log}
        """

rule bowtie_to_pathogens:
    input:
        pathogen_index = config["pathogen_index"],
        unm_r1 = join(config["unmapped_dir"], "{sample}_1.fastq"),
        unm_r2 = join(config["unmapped_dir"], "{sample}_2.fastq")
    output:
        sam = join(config["sam_dir"], "{sample}.sam")
    threads: config["threads_max"]
    log: join(config["log_dir"], "{sample}_pathogen_run.log")
    message: "Running Bowtie2 for file {input.unm_r1} against the pathogens"
    shell:
        """
        (bowtie2 -p {threads} -x {input.pathogen_index} -1 {input.unm_r1} -2 {input.unm_r2} -S {output.sam}) 2> {log}
        """
