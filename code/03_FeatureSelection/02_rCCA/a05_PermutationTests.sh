#!/bin/bash
#SBATCH --job-name=Permute
#SBATCH --output=/home/ahmadf/batch/sbatch.out%j
#SBATCH --error=/home/ahmadf/batch/sbatch.err%j
#SBATCH --time=48:00:00
#SBATCH --mem=30GB
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1

module load matlab

matlab -nodisplay -r "a05_PermutationTests ; exit"