import argparse
import os
from pathlib import Path
import shutil

PROJECT_PATH = Path(Path.home(), 'lustre/projects/slurm-job-array-test')
SCRIPT_PATH = PROJECT_PATH / 'python-example.py'
TEMPORARY_PATH = Path(Path.home(), 'lustre/tmp')

# Where final data will be stored from the job array.
OUTPUT_PATH = PROJECT_PATH / 'output'
OUTPUT_PATH.mkdir(parents=True, exist_ok=True)

def run_iteration(iteration: list) -> None:

    iteration = iteration[0] # Only one element is passed.
    iteration_string = f'{iteration:05d}' # For simplifying names for large iterations

    # Look-up the process-id and create a new working directory in tmp for this run.
    working_directory = TEMPORARY_PATH / f'{SCRIPT_PATH.stem}-{os.getpid()}'

    working_directory.mkdir(parents=True, exist_ok=False)
    working_file = working_directory / f'{iteration}.txt'
    with open(working_file, 'w') as f:
        f.write(f'{iteration}\n')

    # Copy necessary files to project directories
    target_file = OUTPUT_PATH / f'{iteration_string}.txt'
    working_file.rename(target_file)

    # CASA only example
    # Possibly log arguments outside of the working directory
    tclean_file = OUTPUT_PATH / f'{iteration_string}-tclean.par'
    try:
        tput('tclean', tclean_file)
    except NameError:
        print('Skipping CASA example.')

    # Clean-up working directory if needed


def main():

    parser = argparse.ArgumentParser(prog=f'casa -c {SCRIPT_PATH} iteration',
                                     description='Run tclean using the proper arguments.')
    parser.add_argument('iteration', type=int, nargs=1, default=None,
                        help='Version of tclean to run.')

    try:
        args = parser.parse_args()
        run = True
    except Exception:
        run = False

    if run:
        run_iteration(**vars(args))


if __name__=='__main__':
    main()
