HO_ROI_FILES="./data/rois/IndividualDepressionROIs/Probabilistic/HarvardOxford/*.nii.gz"

i=265
for file in $HO_ROI_FILES
do 
	echo "Binarizing $file"

	roi_num=$(($i - 264))
	out="./data/rois/IndividualDepressionROIs/Binarized/roi$roi_num.nii"

	#Binarize the probabilistic ROI mask
	fslmaths "$file" -thr 50 -bin "$out"
	fslmaths "$out" -mul "$i" "$out"

	((i=i+1))

done

 
:'
### UNUSED STUFF ###

BN_ATLAS="./data/rois/IndividualDepressionROIs/Probabilistic/BN_Atlas/BN_Atlas_Fan2016.nii.gz"
for BNA_roi_num in 215 216 187 188 219 220
do
	echo "Extracting ROI $BNA_roi_num"

	roi_num=$(($i - 264))
	out="./data/rois/IndividualDepressionROIs/Binarized/roi$roi_num.nii"

	#Extract ROI:
	fslmaths "$BN_ATLAS" -thr "$BNA_roi_num" -uthr "$BNA_roi_num" -bin "$out"
	fslmaths "$out" -mul "$i" "$out"

	((i=i+1))

done


OTHER_ROI_FILES="./data/rois/IndividualDepressionROIs/Probabilistic/other/*"
for file in $OTHER_ROI_FILES
do 
	echo "Binarizing $file"

	roi_num=$(($i - 264))
	out="./data/rois/IndividualDepressionROIs/Binarized/roi$roi_num.nii"

	#Binarize the probabilistic ROI mask
	fslmaths "$file" -thr 0.10 -bin "$out"

	fslmaths "$out" -mul "$i" out

	((i=i+1))

done
'

