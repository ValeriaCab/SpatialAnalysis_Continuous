#!/bin/bash
#SBATCH --job-name=Analysis
#SBATCH --output=analysis_%A_%a.log
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=8G
#SBATCH --time=48:00:00
#SBATCH --array=1                 # <-- Define de 1 a N réplicas aquí

module load r/4.4.1

BASE_DIR="/mnt/data/dortega/vcabrera/output/2_Heterogeneo/h2_1/"

# $SLURM_ARRAY_TASK_ID contendrá el número de la carpeta actual (1, 2, ..., N)
Rscript run_analysis.R "${BASE_DIR}" "${SLURM_ARRAY_TASK_ID}"