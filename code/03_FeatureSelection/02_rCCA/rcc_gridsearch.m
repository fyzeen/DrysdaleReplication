function [out] = rcc_gridsearch(X_train,Y_train, X_test, Y_test)
%RCC_GRIDSEARCH: This function performs gridsearch on a number of
%   predefined hyperparameters for regularized CCA (as implemented by Buch
%   et al.). This gridsearch optimizes the first canonical correlation
%   in the test data.
%
%   This function will output the two optimal hyperparameters (lambda1 and
%   lambda2) as well as the results of the rCCA performed on teh training
%   data (results) and the canonical correlation coefficients in the test
%   data (test_CCs)
    
% The range of lambdas (hyperparameters) as described in Grosenick et al.
lambda_range = [0, 0.1, 1, 10, 100, 1000, 1e6, 1e9];

max_r = 0;

for i=1:length(lambda_range)
    for j=1:length(lambda_range)

        % Set hyperparameters
        templambda1 = lambda_range(i);
        templambda2 = lambda_range(j);

        % Perform Regularized CCA
        tempresults = rcc_matlab(X_train, Y_train, templambda1, templambda2);
        temp_test_CCs = diag(corr(X_test*tempresults.coeff_A, Y_test*tempresults.coeff_B));

        if abs(temp_test_CCs(1)) > abs(max_r)
            max_r = temp_test_CCs(1);
            results = tempresults;
            lambda1 = templambda1;
            lambda2 = templambda2;
            test_CCs = temp_test_CCs;
        end
            
    end
end

out = struct('results',results,'lambda1', lambda1, 'lambda2', lambda2, 'testCCs', test_CCs);

end

