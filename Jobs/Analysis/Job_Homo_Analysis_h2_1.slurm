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

BASE_DIR="/mnt/data/dortega/vcabrera/output/1_Homogeneo_output/h2_1"

# Entras a la carpeta de la réplica actual (ej: .../resultados/1)
cd "${BASE_DIR}/${SLURM_ARRAY_TASK_ID}"

# Ejecutas el script apuntando a su ruta absoluta
Rscript /mnt/data/dortega/vcabrera/scripts/Analysis/Homo_Analysis_h2_1.R