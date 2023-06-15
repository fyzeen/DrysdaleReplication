#!/bin/bash
#SBATCH --job-name=CorrTS
#SBATCH --output=/home/ahmadf/batch/sbatch.out%j
#SBATCH --error=/home/ahmadf/batch/sbatch.err%j
#SBATCH --time=23:55:00
#SBATCH --mem=20GB
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1

module load python
source activate drysdale_replication

for subj in  in `cat /home/ahmadf/DrysdaleReplication/data/subjects/ModerateOrSevere.csv` ;
do
    SUBJ_DIR="/scratch/ahmadf/DrysdaleReplication/subjects/sub_${subj}"
    timeseries="${SUBJ_DIR}/high_SNR_mean_timeseries.txt"
    corr_mat_path="${SUBJ_DIR}/corr_mat.csv"

    python3 /home/ahmadf/DrysdaleReplication/code/02_rsfMRICorrelations/04_CorrelateTimerseries/correlateTimeseries.py ${timeseries} ${corr_mat_path}

    vectorized_corr_mat="/scratch/ahmadf/DrysdaleReplication/all/vectorized_corr_mat.csv"

    python3 /home/ahmadf/DrysdaleReplication/code/02_rsfMRICorrelations/04_CorrelateTimerseries/vectorizeCorrelationMatrices.py ${corr_mat_path} ${vectorized_corr_mat} ${subj}
done

conda deactivate