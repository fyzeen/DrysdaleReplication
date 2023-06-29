% Read in data
correlates = readtable("/Users/fyzeen/FyzeenLocal/GitHub/DrysdaleReplication/data/local/clinical_correlates.csv", "ReadRowNames", true);
data = readtable("/Users/fyzeen/FyzeenLocal/GitHub/DrysdaleReplication/data/local/nuisance_regressed_vectorized_corr_mat.csv", "ReadRowNames",true);

% Clean correlates to make matrices full rank
correlates = correlates(:, 1:13);

% Feature Selection
corr_pvals = spearman_corr(data, correlates);
[indices, indexed_data] = select_features(data, corr_pvals, false, NaN, "other", 150, NaN);

% Perform CCA on entire dataset
[A,B,r,U,V,stats] = canoncorr(table2array(indexed_data), table2array(correlates));

% Save ouput (probably just save U and V (canonical covariates), A and B (loadings))
tableU = array2table(U);
tableU.Properties.RowNames = correlates.Properties.RowNames;
tableV = array2table(V);
tableV.Properties.RowNames = correlates.Properties.RowNames;