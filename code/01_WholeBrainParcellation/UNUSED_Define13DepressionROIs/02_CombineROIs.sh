BIN_ROI_FILES="./data/rois/IndividualDepressionROIs/Binarized/*"
POWER_ATLAS="./data/rois/Masked264PowerAtlasROIs.nii.gz"
COMBINED_ROIs="./data/rois/CombinedROIs.nii.gz" # this file initialized as copy of $POWER_ATLAS

fslmaths "$POWER_ATLAS" -add 1 -thr 1 -uthr 1 -bin temp.nii.gz

for file in $BIN_ROI_FILES
do 
	fslmaths "$file" -mul temp.nii.gz -add "$COMBINED_ROIs" "$COMBINED_ROIs"
done

rm temp.nii.gz