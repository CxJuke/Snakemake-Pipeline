"""
Rules for converting accession numbers to accession name
"""

rule make_genome_dictionary:
    input:
        config["pathogen_fasta"]
    output:
        config["genome_dict_obj"]
    message: "creating {output}"
    script:
        config["get_genomes"]


rule accesson_to_name:
    input:
        asc = join(config["accession"], "{sample}.txt"),
        dict = config["genome_dict_obj"]
    output:
        sci = join(config["science_names"], "{sample}"),
        sgl = join(config["single_names"], "{sample}")
    message: "Converting accession numbers in {input.asc} with dict {input.dict}, to science names in {output.sci} and single names as {output.sgl}"
    script:
        config["accession_to_name"]
