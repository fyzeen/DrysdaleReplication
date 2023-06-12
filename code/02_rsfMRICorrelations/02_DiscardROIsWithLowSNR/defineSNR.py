# importing modules
import argparse
import os.path as op
import pandas as pd

def computeSNR(timeseries_path):
    '''
    This function computes the SNR of ROI timeseries extracted by fslmeants.

    We define signal-to-noise ("SNR") ratio as mean MR signal divided by the standard deviation of the MR signal during the timeseries.

    Inputs
    ----------
    timeseries_path: str
        Path to subject's timeseries file by ROI, as outputted by fslmeants
    
    Outputs
    ----------
    roi_SNRs: pd.DataFrame
        A pandas df with the SNR of each ROI (each column of the timeseries)
    '''
    timeseries = pd.read_csv(timeseries_path, sep="\s\s", engine="python", header=None)
    roi_SNRs = pd.DataFrame(timeseries.mean() / timeseries.std())

    return roi_SNRs.T

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Computes SNR of ROI timeseries extracted by fslmeants.")
    parser.add_argument("timeseries_path", type=str, help="Enter path to timeseries file.")
    parser.add_argument("path_to_csv", type=str, help="Enter the path to the EXISTING .csv file in which you want to store ROI SNRs for all subjects")
    args = parser.parse_args()

    snr = computeSNR(args.timeseries_path)
    snr.to_csv(args.path_to_csv, mode='a', sep=",", index=False, header=None)