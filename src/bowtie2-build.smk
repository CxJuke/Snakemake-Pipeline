"""
rules for bowtie2-build tool
"""

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
