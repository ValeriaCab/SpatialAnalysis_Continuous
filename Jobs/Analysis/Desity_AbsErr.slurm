#!/bin/bash
#SBATCH --job-name=plot_freq
#SBATCH --output=plot_freq.out
#SBATCH --error=plot_freq.err
#SBATCH --time=01:00:00
#SBATCH --mem=4G

module load r/4.4.1

Rscript /mnt/data/dortega/vcabrera/scripts/Analysis/Density_AbsErr.R


