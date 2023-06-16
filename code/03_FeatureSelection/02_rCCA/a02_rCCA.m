% Read in data
correlates = readtable("/Users/fyzeen/FyzeenLocal/GitHub/DrysdaleReplication/data/local/clinical_correlates.csv", "ReadRowNames", true);
data = readtable("/Users/fyzeen/FyzeenLocal/GitHub/DrysdaleReplication/data/local/nuisance_regressed_vectorized_corr_mat.csv", "ReadRowNames",true);
correlates = correlates(:, 1:13);

% Feature Selection
corr_pvals = spearman_corr(data, correlates);
[indices, indexed_data] = select_features(data, corr_pvals, false, NaN, "pval_thresh", NaN, 0.001);

% We now split the data into train and test for gridsearch
split_ratio = 0.99; %%% Making this larger typically leads to larger CCs

num_samples = size(indexed_data, 1);
% Calculate the number of samples for training and testing
num_train = round(split_ratio * num_samples);
num_test = num_samples - num_train;
% Shuffle indices of the samples so that we can randomly choose 10% of the
% data for test and 90% for train
shuffled_indices = randperm(num_samples);
% Split the data
data_train = table2array(indexed_data(shuffled_indices(1:num_train), :));
correlates_train = table2array(correlates(shuffled_indices(1:num_train), :)); 
data_test = table2array(indexed_data(shuffled_indices(num_train+1:end), :));
correlates_test = table2array(correlates(shuffled_indices(num_train+1:end), :));


% Perform rCCA gridsearch to find optimal parameters
[gridsearch_out] = rcc_gridsearch(data_train,correlates_train, data_test, correlates_test);
[out] = rcc_matlab(table2array(indexed_data), table2array(correlates), gridsearch_out.lambda1, gridsearch_out.lambda1);


% Save output (probably just save U and V (canonical covariates), A and B (loadings))
