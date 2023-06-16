% Read in data
correlates = readtable("/Users/fyzeen/FyzeenLocal/GitHub/DrysdaleReplication/data/local/clinical_correlates.csv", "ReadRowNames", true);
data = readtable("/Users/fyzeen/FyzeenLocal/GitHub/DrysdaleReplication/data/local/nuisance_regressed_vectorized_corr_mat.csv", "ReadRowNames",true);

% Feature Selection
corr_pvals = spearman_corr(data, correlates);
[indices, indexed_data] = select_features(data, corr_pvals, false, NaN, "pval_thresh", NaN, 0.001);

% Perform CCA on entire dataset
[A,B,r,U,V,stats] = canoncorr(table2array(indexed_data), table2array(correlates(:, 1:13)));

% Save ouput (probably just save U and V (canonical covariates), A and B (loadings))
