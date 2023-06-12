# importing modules
import argparse
import numpy as np
import nibabel as nib

def createVoxelwiseSNRMasks(brain_path, thresh, out_path):
    '''
    This function creates a mask for an individual subject's brain based on the SNR value in each voxel AND the coverage of that voxel.
    If a voxel has sufficient SNR (as defined by the user defined threshold) and coverage, the mask labels that voxel with a 1. All 
    other voxels are labeled with 0.

    Inputs
    ----------
    brain_path: str
        Path to the 4D .nii.gz (nifti) file containing the brain you want to extract SNR/define a mask for.

    thresh: int
        The int threshold under which you want to define a voxel to have low SNR.

    out_path: str
        Path to the location in which you want to store the subject's mask.
    
    Outputs
    ----------
    Nothing is returned by this function.

    However, this function will write a brain mask to the specified location.
    '''
    img = nib.load(brain_path)
    affine = img.affine

    img_data = img.get_fdata()
    num_voxels = int(img_data.size / img_data.shape[-1])
    timepoints = img_data.shape[-1]

    reshaped_data = img_data.reshape(num_voxels, timepoints)

    coords_for_mask = []
    for voxel in range(num_voxels):
        timeseries = reshaped_data[voxel]
        if timeseries[0] == 0:
            pass
        else:
            mean = timeseries.mean()
            std = timeseries.std()
            snr = mean / std
            
            if snr < thresh:
                pass
            else:
                coords = np.unravel_index(voxel, img_data.shape[:-1])
                coords_for_mask.append(coords)

    mask = np.zeros(img_data.shape[:-1])
    for coords in coords_for_mask:
        x, y, z = coords
        mask[x, y, z] = 1

    mask_img = nib.nifti1.Nifti1Image(mask, affine=affine)
    nib.save(mask_img, out_path)

    return

    

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Computes the SNR of each voxels in a subject and outputs a NIFTI file with incuding only voxels with an SNR > threshold (defined by user)")
    parser.add_argument("subject_brain", type=str, help="Enter path to subject's brain (.nii.gz) in MNI152 2mm space")
    parser.add_argument("threshold", type=int, help="Enter the value below which you want to define 'low SNR' (e.g., 100, 75, etc.)")
    parser.add_argument("out_path", type=str, help="Enter path to the .nii.gz file to which you want ot sve your high SNR mask for this subject.")
    args = parser.parse_args()

    createVoxelwiseSNRMasks(args.subject_brain, args.threshold, args.out_path)

