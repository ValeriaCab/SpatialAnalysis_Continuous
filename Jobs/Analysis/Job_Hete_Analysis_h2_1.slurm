#!/bin/bash
#SBATCH --job-name=Analysis
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=2G
#SBATCH --time=1:00:00
#SBATCH --array=1
#SBATCH --output=plot_freq.out
#SBATCH --error=plot_freq.err

module load r/4.4.1

BASE_DIR="/mnt/data/dortega/vcabrera/output/2_Heterogeneo_output/h2_1"

cd "${BASE_DIR}/${SLURM_ARRAY_TASK_ID}"

# Ejecutas el script:
Rscript /mnt/data/dortega/vcabrera/scripts/Analysis/Hete_Analysis_h2_1.R