#!/bin/bash
#SBATCH --job-name=ExtractSubjPhenotypes
#SBATCH --output=/mnt/beegfs/home/ahmadf/batch.out%j
#SBATCH --error=/mnt/beegfs/home/ahmadf/batch.err%j
#SBATCH --time=25:00:00
#SBATCH --mem=20GB
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1

module load python
source activate drysdale_replication

fmrib_unpack -ow -s /home/ahmadf/DrysdaleReplication/data/subjects/ModerateOrSevere.csv -v /home/ahmadf/DrysdaleReplication/data/UKB_Variable_IDs.txt /scratch/ahmadf/DrysdaleReplication/phenotypes/phenotypes.tsv /ceph/biobank/phenotypes/ukb670383.csv

conda deactivate