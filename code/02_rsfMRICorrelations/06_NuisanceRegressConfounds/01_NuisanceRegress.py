import numpy as np
import pandas as pd
from sklearn import linear_model

if __name__ == "__main__":
    phenotypes_path = "/Users/fyzeen/FyzeenLocal/GitHub/DrysdaleReplication/data/local/clean_phenotypes.txt"
    phenotypes = pd.read_csv(phenotypes_path, sep="\t")

    # selecting columns to nuisance regress out (age and site, NOT SEX!!)
    site_dummy_variables = pd.get_dummies(phenotypes["54-2.0"], prefix='dummy') # Creating a dummy variable for site
    nuisance_regress_vars = pd.concat([phenotypes["21003-2.0"], site_dummy_variables], axis=1)

    # Read in data (n_subj x n_connectivityFeatures matrix)
    data = pd.read_csv("filepath", sep=',')
    data_mat = data.to_numpy()

    model = linear_model.LinearRegression()
    model.fit(nuisance_regress_vars, data)

    predictions = model.predict(nuisance_regress_vars)
    residuals = data_mat - predictions

    residuals_df = pd.DataFrame(residuals)

    residuals_df.to_csv("filepath", sep=",", header=None) 