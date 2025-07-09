#!/usr/bin/bash

#SBATCH -N 1
#SBATCH -n 8
#SBATCH --array=0-9%5
#SBATCH --mem=50G
#SBATCH --time=01-00:00:00
#SBATCH --job-name="job-array-test"
#SBATCH --output=/users/mstroh/lustre/slurm/sbatch_job.%A_%a.txt

PROJECT_DIRECTORY="$HOME/lustre/projects/slurm-job-array-test"

. $HOME/.profile

conda activate py313

read -d '' -r -a lines < "$PROJECT_DIRECTORY/array-list.txt"

echo "${lines[$SLURM_ARRAY_TASK_ID]}"

cd $PROJECT_DIRECTORY

# For a Python script
#python python-example.py "${lines[$SLURM_ARRAY_TASK_ID]}"

# For running within CASA
xvfb-run -d mpicasa -n 8 casa --nogui -c python-example.py "${lines[$SLURM_ARRAY_TASK_ID]}"
