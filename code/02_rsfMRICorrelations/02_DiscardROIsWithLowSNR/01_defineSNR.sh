#!/bin/bash
#SBATCH --job-name=DefineSNR
#SBATCH --output=/home/ahmadf/batch/sbatch.out%j
#SBATCH --error=/home/ahmadf/batch/sbatch.err%j
#SBATCH --time=23:55:00
#SBATCH --mem=20GB
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1

module load python
source activate drysdale_replication

ALL_SUBJ_SNR_BY_ROI="/scratch/ahmadf/DrysdaleReplication/all/allSubjectSNRsByROI.csv"

for subj in `cat /home/ahmadf/DrysdaleReplication/data/subjects/ModerateOrSevere.csv` ;
do
    echo ${subj}

    TIMESERIES_PATH="/scratch/ahmadf/DrysdaleReplication/subjects/sub_${subj}/mean_timeseries.txt"

    python3 /home/ahmadf/DrysdaleReplication/code/02_rsfMRICorrelations/02_DiscardROIsWithLowSNR/defineSNR.py ${TIMESERIES_PATH} ${ALL_SUBJ_SNR_BY_ROI}

done

LOW_SNR_ROIs="/scratch/ahmadf/DrysdaleReplication/all/lowSNRROIs.csv"

python3 /home/ahmadf/DrysdaleReplication/code/02_rsfMRICorrelations/02_DiscardROIsWithLowSNR/findLowSNRROIs.py ${ALL_SUBJ_SNR_BY_ROI} ${LOW_SNR_ROIs}

conda deactivate






