#!/bin/bash
#SBATCH --job-name=CreateSubjROIs
#SBATCH --output=/home/ahmadf/batch/sbatch.out%j
#SBATCH --error=/home/ahmadf/batch/sbatch.err%j
#SBATCH --time=23:55:00
#SBATCH --mem=30GB
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1

module load fsl

ROI_MASK="/home/ahmadf/DrysdaleReplication/data/rois/highSNRROIs.nii.gz"

for subj in  in `cat /home/ahmadf/DrysdaleReplication/data/subjects/UNFINISHED_ModerateOrSevere.csv` ;
do
    SUBJ_DIR="/scratch/ahmadf/DrysdaleReplication/subjects/sub_${subj}"

    echo ${subj}

    for thresh in 50 75 90 100 ;
    do
        SNR_MASK="${SUBJ_DIR}/SNR_gt_${thresh}.nii.gz"
        OUT_PATH="${SUBJ_DIR}/ROIs_SNR_gt_${thresh}.nii.gz"
        
        fslmaths ${ROI_MASK} -mul ${SNR_MASK} ${OUT_PATH}
    done
done


# after creating the mask, you probably want to quantify the amount ofvoxels that are lost form the entir mask after doing this.