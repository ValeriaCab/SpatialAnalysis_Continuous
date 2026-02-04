#!/bin/bash
#SBATCH --job-name=Burnin_coales
#SBATCH --cpus-per-task=10
#SBATCH --array=1-20
#SBATCH --chdir=/mnt/data/dortega/vcabrera/scripts/
#SBATCH --output=/mnt/data/dortega/vcabrera/output/logs_out/BLS.%A_%a.out
#SBATCH --error=/mnt/data/dortega/vcabrera/output/logs_err/BLS.%A_%a.err
#SBATCH --time=06:00:00
#SBATCH --mem=4G

# Cargar módulos
. /etc/profile.d/modules.sh
module load slim/4.3

# RUNID = réplica
RUNID=${SLURM_ARRAY_TASK_ID}

# Directorio base de salida
BASEOUT=/mnt/data/dortega/vcabrera/output/${RUNID}
mkdir -p "$BASEOUT"

echo "RUNID=$RUNID"

########################
# 3 REGIONES
########################
OUT3=${BASEOUT}/three_regions
mkdir -p "$OUT3"

slim -d RUNID=${RUNID} \
     -d RUNDIR="\"$OUT3\"" \
     Burnin_Three_Regions.slim \
     > "$OUT3/slim_output.txt" \
     2> "$OUT3/slim_error.txt"

########################
# 5 REGIONES
########################
OUT5=${BASEOUT}/five_regions
mkdir -p "$OUT5"

slim -d RUNID=${RUNID} \
     -d RUNDIR="\"$OUT5\"" \
     Burnin_Five_Regions.slim \
     > "$OUT5/slim_output.txt" \
     2> "$OUT5/slim_error.txt"

########################
# 10 REGIONES
########################
OUT10=${BASEOUT}/ten_regions
mkdir -p "$OUT10"

slim -d RUNID=${RUNID} \
     -d RUNDIR="\"$OUT10\"" \
     Burnin_Ten_Regions.slim \
     > "$OUT10/slim_output.txt" \
     2> "$OUT10/slim_error.txt"

echo "RUNID=$RUNID terminado"
