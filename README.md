# Pathogen pipline

Identifying pathogens in human post mortem brain. 

Using a existing pipline converted to snakemake.

![DAG of Pathogen Pipeline](Pipline/dag1.png)

## Getting Started

You will need some data to run the pipeline, testdata is included but will not give any good results.

### Prerequisites


required tools: 

* [samtools](https://github.com/samtools/samtools)
* [bowtie2](https://github.com/BenLangmead/bowtie2)
* [bedtools](https://github.com/arq5x/bedtools)

your system needs python3

### Installing

clone project
```
git clone https://JoukeProfijt@bitbucket.org/JoukeProfijt/snakemake-pipeline.git
cd snakemake-pipeline
```

create virtual enviroment with snakemake installed
```
virtualenv -p /usr/bin/python3 venv_location
source venv_location/bin/activate

pip3 install snakemake
```

run pipline
```
cd Pipline
snakemake --snakefile pathogen_run.smk
```

## Configuration

Configuration is split up in 4 sections
1. Run config
2. Data locations
3. Script locations
4. Constants

### Run config
only one option:

amound of threads to be used. make sure to define --cores in snakemake command if you want to use maxumum threads

```
thread_max: thread_count
```
### Data Locations

defines where all data is located your run is based on

```
sample_dir: directory where samples are located
pathogen_fasta: pathogen_fasta file
human_fasta: human fasta file location
```
### Script locations

defines script locations
```
get_genomes: path to get_genomes.py, default in scripts
genome_dict_obj: location where generated genome dict is stored
accession_to_name: path to accession_to_name.py, default in scripts
```
### Constants

configures output paths.

```
workdir: main workdirectory, default output_dir/
human_index: where the human index is stored, default output_dir/index/human/
pathogen_index: where the pathogen index is stored, default output_dir/index/pathogen/
sam_dir: where sam files will be generated, default output_dir/sam_output/
tmp: temporary directory, default output_dir/tmp/
unmapped_dir: unmapped sample file location, default output_dir/Unmapped/
log_dir: run log location, default output_dir/log/
bam_dir: location for bam files, default output_dir/bam_output/
mapped_bam: location for mapped bam files, default output_dir/bam_output/mapped_bam/
results: location for results, default output_dir/results/
accession: part of results, accession numbers, default output_dir/results/accession_numbers/
science_names: part of resultsm scientific names, default output_dir/results/scientific_names/
single_names: part of results, single names, default output_dir/results/scientific_names/single_names/
```


## Built With

* [Snakemake](https://snakemake.readthedocs.io/en/stable/#) - Workflow manager

## Authors

* **Jouke Profijt** - [Jouke Profijt - bitbucket](https://bitbucket.org/JoukeProfijt/) - [CxJuke - github](https://github.com/CxJuke)

## License

This project is licensed under the GNU General Public Licencse v3.0 - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Original Pipeline by Iris Gorter
*  project was a assignment in my Bio-informatics Dataprocessing course.

