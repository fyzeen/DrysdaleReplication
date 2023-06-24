#!/bin/bash
#SBATCH --job-name=Bootstraps
#SBATCH --output=/home/ahmadf/batch/sbatch.out%j
#SBATCH --error=/home/ahmadf/batch/sbatch.err%j
#SBATCH --time=48:00:00
#SBATCH --mem=30GB
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1

module load matlab

matlab -nodisplay -r "a06_Clustering_Bootstraps ; exit"