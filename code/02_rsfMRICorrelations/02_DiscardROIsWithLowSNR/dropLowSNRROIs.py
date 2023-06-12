# importing modules
import argparse
import os.path as op
import pandas as pd

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Drops ROIs from a subject's timeseries with low SNR")
    parser.add_argument("timeseries_path", type=str, help="Enter path to timeseries file.")
    parser.add_argument("path_to_ROI_indices", type=str, help="Path to csv file with indices of ROIs with low SNR")
    parser.add_argument("path_to_cleaned_timeseries", type=str, help="Path to the file in which you want to save your cleaned timeseries w/o low SNR ROIs.")
    args = parser.parse_args()

    timeseries = pd.read_csv(args.timeseries_path, sep="\s\s", engine="python", header=None)
    lowSNR_ROI_Indices = pd.read_csv(args.path_to_ROI_indices, sep=",", header=None)
    out = timeseries.drop(lowSNR_ROI_Indices[0] - 1, axis=1)
    out.columns = out.columns + 1

    out.to_csv(args.path_to_cleaned_timeseries, sep=",", index=False) # This will save the HEADER into the csv file

