% Read in data
correlates = readtable("/home/ahmadf/DrysdaleReplication/data/local/clinical_correlates.csv", "ReadRowNames", true);
data = readtable("/home/ahmadf/DrysdaleReplication/data/local/nuisance_regressed_vectorized_corr_mat.csv", "ReadRowNames",true);

% Clean correlates to make matrices full rank
correlates = correlates(:, 1:13);

num_permutations = 5000;

for i=1:num_permutations
    disp(i);

    % Permute rows of the correlates table
    shuffled_correlates = correlates;
    num_rows = size(shuffled_correlates, 1);
    permutedIndices = randperm(num_rows);
    shuffled_correlates = shuffled_correlates(permutedIndices, :);
    
    % Select your top 150 features
    corr_pvals = spearman_corr(data, shuffled_correlates);
    [indices, indexed_data] = select_features(data, corr_pvals, false, NaN, "other", 150, NaN);

    % Do a normal CCA on the entire dataset
    [A,B,r,U,V,stats] = canoncorr(table2array(indexed_data), table2array(shuffled_correlates));
    all_CCA_ccs = diag(corr(U, V));

    % Split the data into test and train
    split_ratio = 0.90; 
    
    % Calculate the number of samples for training and testing
    num_train = round(split_ratio * num_rows);
    num_test = num_rows - num_train;
    % Shuffle indices of the samples so that we can randomly choose 10% of the
    % data for test and 90% for train
    shuffled_indices = randperm(num_rows);
    % Split the data
    data_train = table2array(indexed_data(shuffled_indices(1:num_train), :));
    correlates_train = table2array(shuffled_correlates(shuffled_indices(1:num_train), :)); 
    data_test = table2array(indexed_data(shuffled_indices(num_train+1:end), :));
    correlates_test = table2array(shuffled_correlates(shuffled_indices(num_train+1:end), :));

    % Do a regularized CCA on all the data
    [rcc_fit] = rcc_gridsearch(data_train, correlates_train, data_test, correlates_test);

    [rCCA] = rcc_matlab(table2array(indexed_data), table2array(shuffled_correlates), rcc_fit.lambda1, rcc_fit.lambda1);
    all_rCCA_ccs = diag(corr(rCCA.variate_U, rCCA.variate_V));

    %%%%%%%%% NOW WE DO DO CCA ON TRAINING -> TEST DATA %%%%%%%%%%
    % We must first RESELECT our features using only the training data.
    shuffled_indices = randperm(num_rows);
    
    % Split the data
    data_train = data(shuffled_indices(1:num_train), :);
    correlates_train = shuffled_correlates(shuffled_indices(1:num_train), :);
    data_test = table2array(indexed_data(shuffled_indices(num_train+1:end), :));
    correlates_test = table2array(shuffled_correlates(shuffled_indices(num_train+1:end), :));

    % Feature selection per iteration on the training set 
    corr_pvals = spearman_corr(data_train, correlates_train);
    [indices, indexed_data] = select_features(data_train, corr_pvals, false, NaN, "other", 150, NaN);

    % Do CCA on the train data
    [training_A,training_B,training_r,training_U,training_V,training_stats]=canoncorr(table2array(indexed_data), table2array(correlates_train));
    training_CCA_ccs = diag(corr(training_U, training_V));
    % Apply that CCA to test data
    test_CCA_ccs = diag(corr(data_test*A, correlates_test*B));

    % Do rCCA on the train data
    [rcc_fit_train] = rcc_gridsearch(table2array(indexed_data), table2array(correlates_train), data_test, correlates_test);
    training_rCCA_ccs = diag(corr(rcc_fit_train.results.variate_U, rcc_fit_train.results.variate_V));
    test_rCCA_ccs = rcc_fit.testCCs;


    out = horzcat(all_CCA_ccs(1), all_rCCA_ccs(1), training_CCA_ccs(1), training_rCCA_ccs(1), test_CCA_ccs(1), test_rCCA_ccs(1), all_CCA_ccs(2), all_rCCA_ccs(2), training_CCA_ccs(2), training_rCCA_ccs(2), test_CCA_ccs(2), test_rCCA_ccs(2));
    
    dlmwrite('/home/ahmadf/DrysdaleReplication/code/03_FeatureSelection/02_rCCA/permutation_tests.csv', out, 'delimiter', ',', '-append')

end