
INPUT_COMBINED_ROIs="/Users/fyzeen/FyzeenLocal/GitHub/DrysdaleReplication/data/rois/CombinedROIs_UNCLEANED.nii"
FINAL_OUTPUT="/Users/fyzeen/FyzeenLocal/GitHub/DrysdaleReplication/data/rois/CleanedCombinedROIs.nii.gz"

# We will first create temporary masks that will be used to subtract from the combined mask such that the brainstem masks
# become one mask.
fslmaths $INPUT_COMBINED_ROIs -thr 276 -uthr 276 -bin -mul 1 temp1.nii.gz
fslmaths $INPUT_COMBINED_ROIs -thr 277 -uthr 277 -bin -mul 1 temp2.nii.gz
fslmaths $INPUT_COMBINED_ROIs -thr 278 -uthr 278 -bin -mul 2 temp3.nii.gz
fslmaths $INPUT_COMBINED_ROIs -thr 279 -uthr 279 -bin -mul 2 temp4.nii.gz
fslmaths $INPUT_COMBINED_ROIs -thr 280 -uthr 280 -bin -mul 3 temp5.nii.gz

# We now subtract those masks to create the ROIs that we actually want
fslmaths $INPUT_COMBINED_ROIs -sub temp1.nii.gz -sub temp2.nii.gz -sub temp3.nii.gz -sub temp4.nii.gz -sub temp5.nii.gz temp6.nii.gz

# Now we apply the brain mask and get our final output
fslmaths temp6.nii.gz -mul ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz ${FINAL_OUTPUT}

# Clean up the temp files
rm temp*.nii.gz