#!/bin/bash
#SBATCH --job-name=VoxelsLost
#SBATCH --output=/home/ahmadf/batch/sbatch.out%j
#SBATCH --error=/home/ahmadf/batch/sbatch.err%j
#SBATCH --time=23:55:00
#SBATCH --mem=30GB
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1

module load python
source activate drysdale_replication

compute_voxels="/home/ahmadf/DrysdaleReplication/code/02_rsfMRICorrelations/03_SelectHighSNRVoxels/computeVoxelsInROIMask.py"
writeVoxelsCoveredToCSV="/home/ahmadf/DrysdaleReplication/code/02_rsfMRICorrelations/03_SelectHighSNRVoxels/writeVoxelsCoveredToCSV.py"
out_path="/scratch/ahmadf/DrysdaleReplication/all/ROI_voxel_loss_by_subj.csv"


FULL_ROI_MASK="/home/ahmadf/DrysdaleReplication/data/rois/highSNRROIs.nii.gz"
FULL_ROI_VOXEL_COUNT=$(python3 ${compute_voxels} ${FULL_ROI_MASK})
echo ${FULL_ROI_VOXEL_COUNT}

for subj in `cat /home/ahmadf/DrysdaleReplication/data/subjects/ModerateOrSevere.csv` ;
do 
    SUBJ_DIR="/scratch/ahmadf/DrysdaleReplication/subjects/sub_${subj}"

    echo ${subj}

    ROIs_THRESH_50="${SUBJ_DIR}/ROIs_SNR_gt_50.nii.gz"
    ROIs_THRESH_75="${SUBJ_DIR}/ROIs_SNR_gt_75.nii.gz"
    ROIs_THRESH_90="${SUBJ_DIR}/ROIs_SNR_gt_90.nii.gz"
    ROIs_THRESH_100="${SUBJ_DIR}/ROIs_SNR_gt_100.nii.gz"

    num_voxels50=$(python3 ${compute_voxels} ${ROIs_THRESH_50})
    echo ${num_voxels50}

    num_voxels75=$(python3 ${compute_voxels} ${ROIs_THRESH_75})
    echo ${num_voxels75}
    
    num_voxels90=$(python3 ${compute_voxels} ${ROIs_THRESH_90})
    echo ${num_voxels90}

    num_voxels100=$(python3 ${compute_voxels} ${ROIs_THRESH_100})
    echo ${num_voxels100}

    python3 ${writeVoxelsCoveredToCSV} ${out_path} ${FULL_ROI_VOXEL_COUNT} ${num_voxels50} ${num_voxels75} ${num_voxels90} ${num_voxels100}

done

conda deactivate