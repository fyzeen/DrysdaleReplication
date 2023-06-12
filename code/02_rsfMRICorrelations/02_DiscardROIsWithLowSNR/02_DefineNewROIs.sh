# DONE ON LOCAL MACHINE #

# save final ROI mask to */data/rois/highSNRROIs.nii.gz

HIGH_SNR="/Users/fyzeen/FyzeenLocal/GitHub/DrysdaleReplication/data/rois/highSNRROIs.nii.gz"
ALL_ROIS="/Users/fyzeen/FyzeenLocal/GitHub/DrysdaleReplication/data/rois/CleanedCombinedROIs.nii.gz"

for roi in `cat /Users/fyzeen/FyzeenLocal/GitHub/DrysdaleReplication/data/rois/lowSNRROIs.csv`
do
    fslmaths ${ALL_ROIS} -thr ${roi} -uthr ${roi} temp.nii.gz
    fslmaths ${HIGH_SNR} -sub temp.nii.gz ${HIGH_SNR}
    rm temp.nii.gz
done