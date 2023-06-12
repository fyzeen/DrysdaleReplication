# importing modules
import argparse
import os.path as op
import pandas as pd

def findLowSNRROIs(snr_path, thresh=100):
    '''
    This function finds ROIs with low SNR from a csv SNR of each ROI in each subject. We define an ROI to have low SNR if the SNR (voxelwise mean of the 
    magnetic resonance signal over time divided by the standard deviation over time) was less than 100 in >5% of subjects.

    Inputs
    ----------
    snr_path: str
        Path to a .csv file with all subjects' SNR by ROI (i.e., columns are ROIs, rows are subjects)
    
    Outputs
    ----------
    lowSNRROIs: pd.DataFrame
        A pandas series with the indices of the ROIs with low SNR
    '''
    
    SNRs = pd.read_csv(snr_path, sep=",", header=None)
    indices = SNRs[SNRs < 100].count() / SNRs.shape[0] > 0.05

    lowSNRROIs = indices[indices].index + 1

    return pd.DataFrame(lowSNRROIs)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Finds ROIs with low SNR.")
    parser.add_argument("snr_path", type=str, help="Enter path to subject/roi-wise SNR file.")
    parser.add_argument("path_to_save_lowSNRROIs", type=str, help="Enter path to the csv file in which you want to save the indices of ROIs with low SNR.")
    args = parser.parse_args()

    lowSNRROIs = findLowSNRROIs(args.snr_path)
    lowSNRROIs.to_csv(args.path_to_save_lowSNRROIs, sep=",", index=False, header=None)