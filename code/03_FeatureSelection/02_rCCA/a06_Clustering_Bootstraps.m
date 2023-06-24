% Read in data
correlates = readtable("/home/ahmadf/DrysdaleReplication/data/local/clinical_correlates.csv", "ReadRowNames", true);
data = readtable("/home/ahmadf/DrysdaleReplication/data/local/nuisance_regressed_vectorized_corr_mat.csv", "ReadRowNames",true);

% Clean correlates to make matrices full rank
correlates = correlates(:, 1:13);

num_bootstraps = 5000;
num_rows = size(correlates, 1);

for i=1:num_bootstraps
    disp(i);

    % Split the data into test and train
    split_ratio = 0.90; 
    
    % Calculate the number of samples for training and testing
    num_train = round(split_ratio * num_rows);
    num_test = num_rows - num_train; 
    % Shuffle indices of the samples so that we can randomly choose 10% of the
    % data for test and 90% for train
    shuffled_indices = randperm(num_rows);
    % Split the data
    data_train = data(shuffled_indices(1:num_train), :);
    correlates_train = correlates(shuffled_indices(1:num_train), :); 
    
    % Select your top 150 features
    corr_pvals = spearman_corr(data_train, correlates_train);
    [indices, indexed_data] = select_features(data_train, corr_pvals, false, NaN, "other", 150, NaN);


    % Perform normal CCA on the "train" data
    [A,B,r,U,V,stats] = canoncorr(table2array(indexed_data), table2array(correlates_train));
    CCA_U1 = U(:, 1);
    CCA_U2 = U(:, 2);

    % Perform rCCA gridsearch to find optimal parameters. To ensure that
    % the rCCA does not "learn" anything from the test data, we must split
    % the data again to gridsearch for the hyperparameters.
    shuffled_rcca_indices = randperm(num_train);
    num_rcca_train = round(split_ratio * num_train);
    num_rcca_test = num_train - num_rcca_train; 
    data_rcca_train = indexed_data(shuffled_rcca_indices(1:num_rcca_train), :);
    correlates_rcca_train = correlates_train(shuffled_rcca_indices(1:num_rcca_train), :);
    data_rcca_test = table2array(indexed_data(shuffled_rcca_indices(num_rcca_train+1:end), :));
    correlates_rcca_test = table2array(correlates_train(shuffled_rcca_indices(num_rcca_train+1:end), :));

    [gridsearch_out] = rcc_gridsearch(table2array(data_rcca_train), table2array(correlates_rcca_train), data_rcca_test, correlates_rcca_test);
    [out] = rcc_matlab(table2array(indexed_data), table2array(correlates_train), gridsearch_out.lambda1, gridsearch_out.lambda1);
    rCCA_U1 = out.variate_U(:,1);
    rCCA_U2 = out.variate_U(:,2);

    out = array2table(horzcat(CCA_U1, CCA_U2, rCCA_U1, rCCA_U2));
    out.Properties.RowNames = indexed_data.Properties.RowNames;
    out.Properties.VariableNames = ["CCA_U1","CCA_U2","rCCA_U1","rCCA_U2"];
    
    out_path = sprintf('/scratch/ahmadf/DrysdaleReplication/clusteringBootstraps/bootstrap%i.csv', i);
  
    writetable(out, out_path, 'WriteRowNames',true)

end