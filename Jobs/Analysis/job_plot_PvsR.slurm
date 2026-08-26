#!/bin/bash
#SBATCH --job-name=plot_Phen_vs_Regions
#SBATCH --output=plot_Regions.out
#SBATCH --error=plot_Regions.err
#SBATCH --time=01:00:00
#SBATCH --mem=4G

module load r/4.4.1

Rscript /mnt/data/dortega/vcabrera/scripts/PLOT_Phen_vs_Regions.R

