#!/bin/bash
#SBATCH --job-name=DefineHighSNRVoxels
#SBATCH --output=/home/ahmadf/batch/sbatch.out%j
#SBATCH --error=/home/ahmadf/batch/sbatch.err%j
#SBATCH --time=50:00:00
#SBATCH --mem=30GB
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1

module load python
source activate drysdale_replication

for subj in `cat /home/ahmadf/DrysdaleReplication/data/subjects/UNFINISHED_ModerateOrSevere.csv` ;
do 
    SUBJ_DIR="/scratch/ahmadf/DrysdaleReplication/subjects/sub_${subj}"
    SUBJ_BRAIN="/ceph/biobank/derivatives/melodic/sub-${subj}/ses-01/sub-${subj}_ses-01_melodic.ica/filtered_func_data_clean_MNI152.nii.gz"

    echo ${subj}
    
    for thresh in 50 75 90 100 ;
    do 
        OUT_PATH="${SUBJ_DIR}/SNR_gt_${thresh}.nii.gz"
        python3 /home/ahmadf/DrysdaleReplication/code/02_rsfMRICorrelations/03_SelectHighSNRVoxels/createVoxelwiseSNRMasks.py ${SUBJ_BRAIN} ${thresh} ${OUT_PATH}
    done
done

conda deactivate
