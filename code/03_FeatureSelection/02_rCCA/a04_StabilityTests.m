% Read in data
correlates = readtable("/Users/fyzeen/FyzeenLocal/GitHub/DrysdaleReplication/data/local/clinical_correlates.csv", "ReadRowNames", true);
data = readtable("/Users/fyzeen/FyzeenLocal/GitHub/DrysdaleReplication/data/local/nuisance_regressed_vectorized_corr_mat.csv", "ReadRowNames",true);

% Clean correlates to be positive definite (full rank)
correlates = correlates(:, 1:13);

split_ratio = 0.90;
num_samples = size(data, 1);

% Calculate the number of samples for training and testing
num_train = round(split_ratio * num_samples);
num_test = num_samples - num_train;


for i=1:1000
    disp(i);

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
    
    %%%%% SELECTING FEATURES num_features 1839 THRESHOLD %%%%%%
    [indices, indexed_data] = select_features(data, corr_pvals, false, NaN, "other", 1839, NaN); % Selecting top N (250??) features

    % Cleaning matrices
    data_train = indexed_data(shuffled_indices(1:num_train), :);
    data_test = indexed_data(shuffled_indices(num_train+1:end), :);

    % Compute normal CCA
    [A,B,r,U,V,stats]=canoncorr(table2array(data_train), table2array(correlates_train));
    canonical_correlations = diag(corr(table2array(data_test)*A, table2array(correlates_test)*B));

    % Perform gridsearch to find optimal hyperparameters for rCCA
    [rcc_fit] = rcc_gridsearch(table2array(data_train), table2array(correlates_train), table2array(data_test), table2array(correlates_test));

    test_vector = horzcat(rcc_fit.testCCs', canonical_correlations');

    training_vector = horzcat(diag(corr(rcc_fit.results.variate_U, rcc_fit.results.variate_V))', diag(corr(U, V))');

    % IMPORTANT: make sure columns are labeled before you run this!
    dlmwrite('1839features_testCC_stability.csv', test_vector, 'delimiter', ',', '-append')
    dlmwrite('1839features_trainCC_stability.csv', training_vector, 'delimiter', ',', '-append')



    %{
    %%%%% SELECTING FEATURES num_features 150 THRESHOLD %%%%%%
    [indices, indexed_data] = select_features(data, corr_pvals, false, NaN, "other", 150, NaN); % Selecting top N (250??) features

    % Cleaning matrices
    data_train = indexed_data(shuffled_indices(1:num_train), :);
    data_test = indexed_data(shuffled_indices(num_train+1:end), :);

    % Compute normal CCA
    [A,B,r,U,V,stats]=canoncorr(table2array(data_train), table2array(correlates_train));
    canonical_correlations = diag(corr(table2array(data_test)*A, table2array(correlates_test)*B));

    % Perform gridsearch to find optimal hyperparameters for rCCA
    [rcc_fit] = rcc_gridsearch(table2array(data_train), table2array(correlates_train), table2array(data_test), table2array(correlates_test));

    test_vector = horzcat(rcc_fit.testCCs', canonical_correlations');

    training_vector = horzcat(diag(corr(rcc_fit.results.variate_U, rcc_fit.results.variate_V))', diag(corr(U, V))');

    % IMPORTANT: make sure columns are labeled before you run this!
    dlmwrite('150features_testCC_stability.csv', test_vector, 'delimiter', ',', '-append')
    dlmwrite('150features_trainCC_stability.csv', training_vector, 'delimiter', ',', '-append')
    %}

end
