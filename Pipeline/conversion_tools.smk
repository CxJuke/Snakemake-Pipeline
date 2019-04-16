"""
Contains rules for conversion tools
"""
rule sam_to_bam:
    input:
        join(config["sam_dir"], "{sample}.sam")
    output:
        join(config["bam_dir"], "{sample}.bam")
    log: join(config["log_dir"], "samtobam_{sample}.log")
    message: "Converting {input} to {output}"
    shell:
        "(samtools view -b -S -o {output} {input}) 2> {log}"

rule remove_failed_to_allign:
    input:
        join(config["bam_dir"], "{sample}.bam")
    output:
        join(config["mapped_bam"], "{sample}.bam")
    message: "removing failed to allign for file {input}"
    log: join(config["log_dir"], "failed_allignment_{sample}.log")
    shell:
        "(samtools view -b -F 4 {input} > {output}) 2> {log}"
        
rule create_accession_numbers:
    input:
        join(config["mapped_bam"], "{sample}.bam")
    output:
        join(config["accession"], "{sample}.txt")
    log: join(config["log_dir"], "{sample}_bamtobed.log")
    message: "converting mapped bam {input} to bed {output}"
    shell:
        "(bedtools bamtobed -i {input} > {output}) 2> {log}"
