#!/bin/bash
#SBATCH --job-name=Burnin_coales.slim
#SBATCH --cpus-per-task=10
#SBATCH --array=1
#SBATCH --chdir=/mnt/data/dortega/vcabrera/scripts/
#SBATCH --output=/mnt/data/dortega/vcabrera/output/logs_out/BLS.%j.out
#SBATCH --error=/mnt/data/dortega/vcabrera/output/logs_err/BLS.%j.err
#SBATCH --time=02:00:00
#SBATCH --mem=4G

# Cargar módulos
. /etc/profile.d/modules.sh
module load slim/4.3

# Crear carpeta específica por RUNID
RUNDIR=/mnt/data/dortega/vcabrera/output/${SLURM_ARRAY_TASK_ID}
mkdir -p $RUNDIR

# Ejecutar SLiM y guardar salida dentro de la carpeta
slim -d RUNID=${SLURM_ARRAY_TASK_ID} burnin_coales.slim 
              > $RUNDIR/slim_output.txt 
              2> $RUNDIR/slim_error.txt 
             
