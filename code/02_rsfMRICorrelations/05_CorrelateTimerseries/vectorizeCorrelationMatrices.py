# importing modules
import argparse
import pandas as pd
import numpy as np

def vectorizeCorrelationMatrix(corr_mat_path):
    """ 
    This function reads in a correlation matrix and vectorizes it using the np.triu_indices() convention.

    Inputs
    ----------
    corr_mat_path: str
        Path to subject's correlation matrix

    Outputs
    ----------
    vectorized_corr_mat: np.ndarray
        Vectorized UPPER TRIANGLE of correlation matrix
    """
    corr_mat = pd.read_csv(corr_mat_path, sep=",", index_col=0)
    vectorized_corr_mat = corr_mat.to_numpy()[np.triu_indices(corr_mat.shape[0], k=1)] # k=1 option ensures diagonal is ignored

    return vectorized_corr_mat


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Correlates timeseries from ROIs extracted using fslmeants.")
    parser.add_argument("corr_mat_path", type=str, help="Enter the path to the correlation matrix.")
    parser.add_argument("path_to_csv", type=str, help="Enter path to the csv file to which you want to append the vectorized correlation matrix")
    parser.add_argument("subject_ID", type=str, help="Enter the subject's EID. Should be in the form XXXXXXX")
    args = parser.parse_args()

    vectorized_corr_mat = vectorizeCorrelationMatrix(args.corr_mat_path)
    toAppend = pd.DataFrame(vectorized_corr_mat).T
    toAppend.index = [args.subject_ID]
    toAppend.to_csv(args.path_to_csv, mode='a', sep=",", header=None)