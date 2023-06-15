# importing modules
import numpy as np
import nibabel as nib
import argparse
import sys

def countVoxels(roi_mask):
    '''
    This function takes an ROI mask and determines the number voxels covered by the mask.

    Inputs
    ----------
    roi_mask: str
        Path to the ROI mask (in .nii.gz (NIFTI) format)

    Ouputs
    ----------
    num_voxels: int
        Number of voxesl covered by the ROI mask
    '''
    # Load the ROI mask data
    roi_mask = nib.load(roi_mask)
    mask_data = roi_mask.get_fdata()

    # Binarize the mask
    binary_mask = np.where(mask_data != 0, 1, 0)

    # Count the number of voxels covered by the ROI
    num_voxels = int(np.sum(binary_mask))

    return num_voxels

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Computes the number of voxels in an ROI mask")
    parser.add_argument("roi_mask", type=str, help="Enter path to the ROI mask (in .nii.gz (NIFTI) format)")
    args = parser.parse_args()

    num_voxels = countVoxels(args.roi_mask)
    print(num_voxels)

