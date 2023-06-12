#!/bin/bash
#SBATCH --job-name=DropLowSNRROIs
#SBATCH --output=/home/ahmadf/batch/sbatch.out%j
#SBATCH --error=/home/ahmadf/batch/sbatch.err%j
#SBATCH --time=23:55:00
#SBATCH --mem=20GB
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1

module load python
source activate drysdale_replication

LOW_SNR_ROIs="/scratch/ahmadf/DrysdaleReplication/all/lowSNRROIs.csv"

for subj in `cat /home/ahmadf/DrysdaleReplication/data/subjects/ModerateOrSevere.csv` ;
do
    echo ${subj}

    TIMESERIES_PATH="/scratch/ahmadf/DrysdaleReplication/subjects/sub_${subj}/mean_timeseries.txt"
    OUT_PATH="/scratch/ahmadf/DrysdaleReplication/subjects/sub_${subj}/highSNR_mean_timeseries.csv"

    python3 /home/ahmadf/DrysdaleReplication/code/02_rsfMRICorrelations/02_DiscardROIsWithLowSNR/dropLowSNRROIs.py ${TIMESERIES_PATH} ${LOW_SNR_ROIs} ${OUT_PATH}

done

conda deactivate