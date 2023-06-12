# importing modules
import argparse
import pandas as pd

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Finds ROIs with low coverage.")
    parser.add_argument("coverage_path", type=str, help="Enter path to subject/roi-wise coverage file.")
    parser.add_argument("path_to_save_lowCoverageROIs", type=str, help="Enter path to the directory in which you want to save a csv file with the indices of ROIs with low coverage.")
    args = parser.parse_args()

    coverages = pd.read_csv(args.coverage_path, sep=",")
    indices = coverages[coverages > 0].count() / coverages.shape[0] > 0.10
    lowCoverageROIs = pd.DataFrame(indices[indices].index).T


    lowCoverageROIs.to_csv(args.path_to_save_lowCoverageROIs, sep=",", index=False, header=False)