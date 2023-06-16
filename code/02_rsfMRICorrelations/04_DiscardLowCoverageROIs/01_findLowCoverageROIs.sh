#!/bin/bash
#SBATCH --job-name=FindLowCoverage
#SBATCH --output=/home/ahmadf/batch/sbatch.out%j
#SBATCH --error=/home/ahmadf/batch/sbatch.err%j
#SBATCH --time=23:55:00
#SBATCH --mem=20GB
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1

module load python
source activate drysdale_replication

ALL_SUBJ_COVERAGE_BY_ROI="/scratch/ahmadf/DrysdaleReplication/all/allSubjectCoverageByROI.csv"

VAR=1
for subj in `cat /home/ahmadf/DrysdaleReplication/data/subjects/ModerateOrSevere.csv` ;
do
    echo ${subj}

    TIMESERIES_PATH="/scratch/ahmadf/DrysdaleReplication/subjects/sub_${subj}/highSNR_mean_timeseries.csv"


    if [ ${VAR} -gt 0 ] ; 
    then
        python3 /home/ahmadf/DrysdaleReplication/code/02_rsfMRICorrelations/04_DiscardLowCoverageROIs/defineLowCoverageROIs.py ${TIMESERIES_PATH} ${ALL_SUBJ_COVERAGE_BY_ROI} True
        ((VAR=${VAR}-50))
    else 
        python3 /home/ahmadf/DrysdaleReplication/code/02_rsfMRICorrelations/04_DiscardLowCoverageROIs/defineLowCoverageROIs.py ${TIMESERIES_PATH} ${ALL_SUBJ_COVERAGE_BY_ROI} False
    fi

done

LOW_COVERAGE_ROIs="/scratch/ahmadf/DrysdaleReplication/all/lowCoverageROIs.csv"

python3 /home/ahmadf/DrysdaleReplication/code/02_rsfMRICorrelations/04_DiscardLowCoverageROIs/findLowCoverageROIs.py ${ALL_SUBJ_COVERAGE_BY_ROI} ${LOW_COVERAGE_ROIs}