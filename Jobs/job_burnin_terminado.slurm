#!/bin/bash
#SBATCH --job-name=Burnin_coales
#SBATCH --cpus-per-task=10
#SBATCH --array=1   # <-- aquí defines cuántas corridas (1 a n)
#SBATCH --chdir=/mnt/data/dortega/vcabrera/scripts/
#SBATCH --output=/mnt/data/dortega/vcabrera/output/logs_out/BLS.%A_%a.out
#SBATCH --error=/mnt/data/dortega/vcabrera/output/logs_err/BLS.%A_%a.err
#SBATCH --time=06:00:00
#SBATCH --mem=4G

# Cargar módulos
. /etc/profile.d/modules.sh
module load slim/4.3

# Definir RUNID = número de réplica (SLURM_ARRAY_TASK_ID)
RUNID=${SLURM_ARRAY_TASK_ID}

# Crear carpeta específica por RUNID
RUNDIR=/mnt/data/dortega/vcabrera/output/${RUNID}
mkdir -p "$RUNDIR"

echo "Ejecutando RUNID=$RUNID en carpeta $RUNDIR"

# Ejecutar SLiM y guardar salida dentro de la carpeta
slim -d RUNID=${RUNID} -d RUNDIR="\"$RUNDIR\"" Burnin_Three_Regions.slim \
    > "$RUNDIR/slim_output.txt" \
    2> "$RUNDIR/slim_error.txt"


