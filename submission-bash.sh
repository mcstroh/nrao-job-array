#!/usr/bin/bash

#SBATCH -N 1
#SBATCH -n 8
#SBATCH --array=0-9%5
#SBATCH --mem=2G
#SBATCH --time=01-00:00:00
#SBATCH --job-name="job-array-test"
#SBATCH --output=/users/mstroh/lustre/slurm/sbatch-job.%A_%a.txt

# Move to the directory where this file lives.
PROJECT_DIRECTORY="${HOME}/lustre/projects/slurm-job-array"
cd ${PROJECT_DIRECTORY}

# Read the file containing arguments.
# One set of arguments per line in the file.
read -d '' -r -a lines < "${PROJECT_DIRECTORY}/array-list.txt"

# Submit the bash script with the arguments.
${PROJECT_DIRECTORY}/bash-batch.sh "${lines[$SLURM_ARRAY_TASK_ID]}"
