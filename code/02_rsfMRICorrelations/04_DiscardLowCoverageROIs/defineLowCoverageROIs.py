# importing modules
import argparse
import pandas as pd

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Determines which ROIs in a subject have low coverage.")
    parser.add_argument("timeseries_path", type=str, help="Enter path to SNR-CLEANED (low SNR ROIs thrown out) timeseries file.")
    parser.add_argument("path_to_csv", type=str, help="Enter the path to the EXISTING .csv file in which you want to store ROIs w/ low coverage for all subjects")
    parser.add_argument("header", type=bool, help="For the first subject pushed through this script, input True, for all other subjects, input False.")
    args = parser.parse_args()

    timeseries = pd.read_csv(args.timeseries_path, sep=",")

    coverage_vec = pd.DataFrame(timeseries[timeseries == 0].count())

    if args.header:
        coverage_vec.to_csv(args.path_to_csv, mode='a', sep=",", index=False)
    else:
        coverage_vec.to_csv(args.path_to_csv, mode='a', sep=",", index=False, header=None)
