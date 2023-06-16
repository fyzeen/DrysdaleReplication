import numpy as np
import pandas as pd
from sklearn import linear_model

if __name__ == "__main__":
    phenotypes_path = "/Users/fyzeen/FyzeenLocal/GitHub/DrysdaleReplication/data/local/clean_phenotypes.txt"
    phenotypes = pd.read_csv(phenotypes_path, sep="\t", index_col="eid")

    # selecting columns to nuisance regress out (age and site, NOT SEX!!)
    site_dummy_variables = pd.get_dummies(phenotypes["54-2.0"], prefix='dummy') # Creating a dummy variable for site
    nuisance_regress_vars = pd.concat([phenotypes["21003-2.0"], site_dummy_variables], axis=1)

    # Read in data (n_subj x n_connectivityFeatures matrix)
    data = pd.read_csv("/Users/fyzeen/FyzeenLocal/GitHub/DrysdaleReplication/data/local/vectorized_corr_mat.csv", sep=',', index_col="subjID")
    
    # Mean impute NaN values
    data_mean_imputed = data.fillna(data.mean())
    
    # Save the mean-imputed corr_mat
    mean_imputed_out_path = "/Users/fyzeen/FyzeenLocal/GitHub/DrysdaleReplication/data/local/mean_imputed_vectorized_corr_mat.csv"
    data_mean_imputed.to_csv(mean_imputed_out_path, sep=",")

    data = None # Memory management

    # Fit leinear model
    data_mat = data_mean_imputed.to_numpy()
    model = linear_model.LinearRegression()
    model.fit(nuisance_regress_vars, data)

    # Define residuals
    predictions = model.predict(nuisance_regress_vars)
    residuals = data_mean_imputed - predictions

    residuals.to_csv("/Users/fyzeen/FyzeenLocal/GitHub/DrysdaleReplication/data/local/nuisance_regressed_vectorized_corr_mat.csv")