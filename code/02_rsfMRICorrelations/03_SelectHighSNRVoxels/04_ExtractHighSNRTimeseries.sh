#!/bin/bash
#SBATCH --job-name=ExtractTimeseries
#SBATCH --output=/home/ahmadf/batch/sbatch.out%j
#SBATCH --error=/home/ahmadf/batch/sbatch.err%j
#SBATCH --time=23:55:00
#SBATCH --mem=20GB
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1

module load fsl

thresh="100"

for subj in `cat /home/ahmadf/DrysdaleReplication/data/subjects/ModerateOrSevere.csv` ;
do
	echo ${subj}
	func_data="/ceph/biobank/derivatives/melodic/sub-${subj}/ses-01/sub-${subj}_ses-01_melodic.ica/filtered_func_data_clean_MNI152.nii.gz"
	SUBJ_DIR="/scratch/ahmadf/DrysdaleReplication/subjects/sub_${subj}"
    label="${SUBJ_DIR}/ROIs_SNR_gt_${thresh}.nii.gz"
	out_file="${SUBJ_DIR}/high_SNR_mean_timeseries_thresh${thresh}.txt"

	fslmeants -i ${func_data} -o ${out_file} --label=${label}

done