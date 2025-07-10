#!/usr/bin/bash

# Set up default environment per user configurations.
. ${HOME}/.profile

# Move to the directory where this file lives.
PROJECT_DIRECTORY="$HOME/lustre/projects/slurm-job-array"
cd ${PROJECT_DIRECTORY}

# Load conda environment (if needed)
#conda activate py313

TEMP_DIRECTORY="${HOME}/lustre/tmp/$(date '+%Y%m%d%H%M%S')-$(hostname)-${$}"
mkdir -p ${TEMP_DIRECTORY}
cd ${TEMP_DIRECTORY}

# For running a Python script
#python python-example.py "${1}"

# For running within CASA
CASAPATH="/home/casa/packages/RHEL8/release/current"
# This next line is for debugging to see the full command being run, and can be commented out.
echo "xvfb-run -d ${CASAPATH}/bin/mpicasa ${CASAPATH}/bin/casa --nogui -c ${PROJECT_DIRECTORY}/python-example.py ${1}"
xvfb-run -d ${CASAPATH}/bin/mpicasa ${CASAPATH}/bin/casa --nogui -c "${PROJECT_DIRECTORY}/python-example.py" "${1}"
