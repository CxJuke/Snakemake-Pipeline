from os.path import basename
from os.path import join
from glob import glob

configfile: "config.yaml"

basenames = [basename(x).split("_R1")[0] for x in glob(config["sample_dir"] + "*R1.fastq")]
unmapped_dir = config["unmapped_dir"]
rule all:
    input:
        expand(join(config["single_names"], "{sample}"), sample = basenames)

rule bowtie_index_human:
    input:
        human_fa = config["human_fasta"]
    output:
        human_index = directory(config["human_index"])
    threads: config["threads_max"]
    message: "indexing genome with bowtie2"
    log: 
        join(config["log_dir"], "bowtie_index_human.log")
    shell:
        """
        (bowtie2-build --threads {threads} {input.human_fa} {output.human_index} ) 2> {log}
        """
rule bowtie_index_pathogen:
    input:
        pathogen_fa = config["pathogen_fasta"]
    output:
        pathogen_index = directory(config["pathogen_index"])
    threads: config["threads_max"]
    message: "indexing pathogen with bowtie2"
    log: 
       join(config["log_dir"], "bowtie_index_pathogen.log")
    shell:
        """
        (bowtie2-build --threads {threads} {input.pathogen_fa} {output.pathogen_index} ) 2> {log} 
        """

rule bowtie_to_human:
    input:
        human_index = config["human_index"],
        r1 = join(config["sample_dir"], "{sample}_R1.fastq"),
        r2 = join(config["sample_dir"], "{sample}_R2.fastq")
    params:
        unmapped = join(unmapped_dir, "{sample}_%.fastq")
    output:
        unm_r1 = join(unmapped_dir, "{sample}_1.fastq"),
        unm_r2 = join(unmapped_dir, "{sample}_2.fastq"),
        sam = join(config["tmp"], "{sample}.sam")
    threads: config["threads_max"]
    log: join(config["log_dir"], "{sample}_human_run.log")
    message: "Running Bowtie2 for file {input.r1} against the human genome"
    shell:
        """
        (bowtie2 -p {threads} -x {input.human_index} -1 {input.r1} -2 {input.r2} --un-conc {params.unmapped} -S {output.sam} --no-unal --no-hd --no-sq -p 32) 2> {log}
        """

rule bowtie_to_pathogens:
    input:
        pathogen_index = config["pathogen_index"],
        unm_r1 = join(unmapped_dir, "{sample}_1.fastq"),
        unm_r2 = join(unmapped_dir, "{sample}_2.fastq")
    output:
        sam = join(config["sam_dir"], "{sample}.sam")
    threads: config["threads_max"]
    log: join(config["log_dir"], "{sample}_pathogen_run.log")
    message: "Running Bowtie2 for file {input.unm_r1} against the pathogens"
    shell:
        """
        (bowtie2 -p {threads} -x {input.pathogen_index} -1 {input.unm_r1} -2 {input.unm_r2} -S {output.sam} -p 32) 2> {log}
        """

rule sam_to_bam:
    input:
        join(config["sam_dir"], "{sample}.sam")
    output:
        join(config["bam_dir"], "{sample}.bam")
    message: "Converting {input} to {output}"
    shell:
        "samtools view -b -S -o {output} {input}"

rule remove_failed_to_allign:
    input:
        join(config["bam_dir"], "{sample}.bam")
    output:
        join(config["mapped_bam"], "{sample}.bam")
    message: "removing failed to allign for file {input}"
    shell:
        "samtools view -b -F 4 {input} > {output}"

rule create_accession_numbers:
    input:
        join(config["mapped_bam"], "{sample}.bam")
    output:
        join(config["accession"], "{sample}.txt")
    log: join(config["log_dir"], "{sample}_bamtobed.log")
    message: "converting mapped bam {input} to bed {output}"
    shell:
        "(bedtools bamtobed -i {input} > {output}) 2> {log}"

rule make_genome_dictionary:
    input:
        config["pathogen_fasta"]
    output:
        config["genome_dict_obj"]
    message: "creating {output}"
    script:
        'scripts/get_genomes.py'


rule accesson_to_name:
    input:
        asc = join(config["accession"], "{sample}.txt"),
        dict = config["genome_dict_obj"]
    output:
        sci = join(config["science_names"], "{sample}"),
        sgl = join(config["single_names"], "{sample}")
    message: "Converting accession numbers in {input.asc} with dict {input.dict}, to science names in {output.sci} and single names as {output.sgl}"
    script:
        'scripts/accession_to_name.py'

