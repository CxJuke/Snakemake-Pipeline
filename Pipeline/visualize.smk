"""
Runs visualization for mapped bam
"""

rule pileup:
    input:
        join(config["mapped_bam"], "{sample}.bam")
    output:
        join(config["workdir"], "pileup/{sample}.txt")
    params:
        sh = config["pileup"]
        pileup_mem = config["pileup_mem"]
    shell:
        "{params.sh} -Xmx{pileup_mem} in={input} out={output} -da"

