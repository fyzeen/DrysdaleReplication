import numpy as np
import pandas as pd

if __name__ == "__main__":
    phenotypes_path = "/Users/fyzeen/FyzeenLocal/GitHub/DrysdaleReplication/data/local/clean_phenotypes.txt"
    phenotypes = pd.read_csv(phenotypes_path, sep="\t", index_col = "eid")

    columns = ["2050-2.0","2030-2.0","20513-0.0","20533-0.0","20517-0.0","20535-0.0","2060-2.0","20518-0.0","2070-2.0","1980-2.0","20511-0.0","2080-2.0","20536-0.0","2090and2100"]
    correlates_df = phenotypes[columns]

    correlates_df.to_csv("/Users/fyzeen/FyzeenLocal/GitHub/DrysdaleReplication/data/local/clinical_correlates.csv", sep=",")
