#!/bin/bash
#SBATCH --job-name=multiqc
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --time=00:10:00

module load multiqc

multiqc 02_fastqc_raw/
