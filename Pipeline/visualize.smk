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
    message: "runnin BBmap pileup for {input}"
    log: join(config["log_dir"], "pileup_{sample}.log")
    shell:
        "({params.sh} -Xmx{params.pileup_mem} in={input} out={output} -da) 2> {log}"

rule remove_zero:
    input:
        join(config["workdir"], "pileup/{sample}.txt")
    output:
        join(config["workdir"], "results/alligned/{sample}")

    script:
        config["exclude_py"]


rule visualize:
    input:
        expand(join(config["workdir"], "results/alligned/{sample}"), sample=config["basenames"]),
    params:
        script = config["R_script"],
        height = config["result_height"],
        width = config["result_width"]
    output:
        join(config["results"], "barplot.png")
    message: "Creating final result in {output}"
    log: join(config["log_dir"], "barplot_R.log")
    shell:
        "(Rscript {params.script} {input} {output} {params.height} {params.width}) 2> {log}"
    

