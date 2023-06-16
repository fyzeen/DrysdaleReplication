% Read in data
correlates = readtable("/Users/fyzeen/FyzeenLocal/GitHub/DrysdaleReplication/data/local/clinical_correlates.csv", "ReadRowNames", true);
data = readtable("/Users/fyzeen/FyzeenLocal/GitHub/DrysdaleReplication/data/local/nuisance_regressed_vectorized_corr_mat.csv", "ReadRowNames",true);

% Clean correlates to be positive definite (full rank)
correlates = correlates(:, 1:13);

split_ratio = 0.9;
num_samples = size(data, 1);

% Calculate the number of samples for training and testing
num_train = round(split_ratio * num_samples);
num_test = num_samples - num_train;


for i=1:10
    % Shuffle indices of the samples so that we can randomly choose 10% of the
    % data for test and train
    shuffled_indices = randperm(num_samples);
    
    % Split the data
    data_train = data(shuffled_indices(1:num_train), :);
    correlates_train = correlates(shuffled_indices(1:num_train), :);
    %data_test = data(shuffled_indices(num_train+1:end), :);
    correlates_test = correlates(shuffled_indices(num_train+1:end), :);

    % Feature selection per iteration on the training set 
    corr_pvals = spearman_corr(data_train, correlates_train);
    [indices, indexed_data] = select_features(data, corr_pvals, false, NaN, "pval_thresh", NaN, 0.001);

    % Cleaning matrices
    data_train = indexed_data(shuffled_indices(1:num_train), :);
    data_test = indexed_data(shuffled_indices(num_train+1:end), :);

    % Compute normal CCA
    [A,B,r,U,V,stats]=canoncorr(data_train, correlates_train);
    canonical_correlations = diag(corr(data_test*A, correlates_test*B));

    % Perform gridsearch to find optimal hyperparameters for rCCA
    [rcc_fit] = rcc_gridsearch(data_train, correlates_train, data_test, correlates_test);

    combined_vector = horzcat(rcc_fit.testCCs', canonical_correlations');

    % IMPORTANT: BEFORE YOU RUN THIS MAKE SURE YOU SET UP COMBINED.CSV SO
    % THAT ITS HEADER IS ALRIGHT (I.E., IT HAS THE CORRECT NUMBER OF CCs
    % IN THE HEADER!!!
    dlmwrite('combined.csv', combined_vector, 'delimiter', ',', '-append')

end