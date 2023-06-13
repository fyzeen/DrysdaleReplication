% These actually need to be read in when we have them...
data = rand(2000, 30);
correlates = rand(2000, 17);

split_ratio = 0.9;
num_samples = size(data, 1);

% Calculate the number of samples for training and testing
num_train = round(split_ratio * num_samples);
num_test = num_samples - num_train;

% Shuffle indices of the samples so that we can randomly choose 10% of the
% data for test and train
shuffled_indices = randperm(num_samples);

% Split the data
data_train = data(shuffled_indices(1:num_train), :);
correlates_train = correlates(shuffled_indices(1:num_train), :);
data_test = data(shuffled_indices(num_train+1:end), :);
correlates_test = correlates(shuffled_indices(num_train+1:end), :);

% Perform rcca on the entire dataset with optimized parameters via gridsearch
[rcc_fit] = rcc_gridsearch(data_train, correlates_train, data_test, correlates_test);
rcca = rcc_matlab(data, correlates, rcc_fit.lambda1, rcc_fit.lambda2);

% Perform normal CCA on the entire dataset
[A,B,r,U,V,stats] = canoncorr(data, correlates);

% Save outputs (the weights/canonical loadings for each CV):
%   In this format, each column contains the canonical weights for a given
%   CV. i.e., column 1 in CCA_A.csv gives the weights for all the variables
%   in `data` for the first CV (weights for `correlates` are in the first 
%   column of CCA_B.csv)
writematrix(A, 'CCA_A.csv')
writematrix(B, 'CCA_B.csv')
writematrix(rcca.coeff_A, 'RCCA_A.csv')
writematrix(rcca.coeff_B, 'RCCA_B.csv')






