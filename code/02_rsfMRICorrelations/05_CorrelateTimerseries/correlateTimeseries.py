# importing modules
import argparse
import pandas as pd
import numpy as np

def correlateTimeseries(timeseries_path, out_path):
    """ 
    This function correlates the ROI timeseries passed into the function and writes the Fisher z-transfomed correlation matrix 
    as a .csv file

    Inputs
    ----------
    timeseries_path: str
        Path to subject's CLEANED timeseries file (i.e., without ROIs with low SNR)
    
    out_path: str
        Path to the file in which you want to save the correlation matrix

    Outputs
    ----------
    Returns None
    
    Writes the Fisher z-transformed correlation matrix to the specified location.
    """
    timeseries = pd.read_csv(timeseries_path, sep=",")
    corr_mat = timeseries.corr()
    z_corr_mat = np.arctanh(corr_mat) # Does Fisher z-transform on correlation coefficients
    
    z_corr_mat.to_csv(out_path, sep=",") # this will save the INDEX and the HEADER into the csv

    return


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Correlates timeseries from ROIs extracted using fslmeants.")
    parser.add_argument("timeseries_path", type=str, help="Enter path to timeseries file.")
    parser.add_argument("out_path", type=str, help="Enter path to directory in which to save the correlation matrix.")
    args = parser.parse_args()

    correlateTimeseries(args.timeseries_path, args.out_path)