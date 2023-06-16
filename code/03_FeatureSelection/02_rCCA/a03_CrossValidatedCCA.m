% Read in data
correlates = readtable("/Users/fyzeen/FyzeenLocal/GitHub/DrysdaleReplication/data/local/clinical_correlates.csv", "ReadRowNames", true);
data = readtable("/Users/fyzeen/FyzeenLocal/GitHub/DrysdaleReplication/data/local/nuisance_regressed_vectorized_corr_mat.csv", "ReadRowNames",true);

% Clean correlates to be positive definite (full rank)
correlates = correlates(:, 1:13);

% Define the number of cross-validation folds
numFolds = 10;

% Initialize variables to store the canonical variates and fold assignments
canonicalLoadingsA = cell(numFolds, 1);
canonicalLoadingsB = cell(numFolds, 1);
canonicalCovariatesU = cell(numFolds, 1);
canonicalCovariatesV = cell(numFolds, 1);

% Perform cross-validated CCA
cv = cvpartition(size(correlates,1), 'KFold', numFolds);
for fold = 1:numFolds
    disp(fold)

    % Get the training and testing indices for the current fold
    trainIds = training(cv, fold);
    testIds = test(cv, fold);
    
    % Get the training and testing data and labels for the current fold
    trainData = data(trainIds, :);
    trainCorrelates = correlates(trainIds, :);
    %testData = data(testIds, :);
    testCorrelates = correlates(testIds, :);

    % Feature selection
    corr_pvals = spearman_corr(trainData, trainCorrelates);
    [indices, indexed_data] = select_features(data, corr_pvals, false, NaN, "pval_thresh", NaN, 0.001);

    % Cleaning matrices
    trainData = indexed_data(trainIds, :);
    testData = indexed_data(testIds, :);

    % Perform CCA on the training data
    [A, B, ~, ~, ~] = canoncorr(table2array(trainData), table2array(trainCorrelates));
    
    canonicalLoadingsA{fold} = A;
    canonicalLoadingsB{fold} = B;
    canonicalCovariatesU{fold} = table2array(indexed_data) * A;
    canonicalCovariatesV{fold} = table2array(correlates) * B;

end

fold1V = canonicalCovariatesV{1};
fold1training = training(cv, 1);

ORDERED_canonicalCovariatesU = cell(numFolds, 1);
ORDERED_canonicalCovariatesV = cell(numFolds, 1);
ORDERED_canonicalCovariatesU{1} = canonicalCovariatesU{1};
ORDERED_canonicalCovariatesV{1} = canonicalCovariatesV{1};


for fold = 2:numFolds
    foldNV = canonicalCovariatesV{fold};
    foldNtraining = training(cv, fold);

    sharedIndices = find(fold1training & foldNtraining);
    
    fold1Vshared = fold1V(sharedIndices, :);
    foldNVshared = foldNV(sharedIndices, :);

    corr_mat = corr(fold1Vshared, foldNVshared);
    diss_mat = 1 - corr_mat;

    [assignment, ~] = munkres(diss_mat);

    foldNcovariateU = canonicalCovariatesU{fold};
    foldNcovariateV = canonicalCovariatesV{fold};
    numCols = size(foldNcovariateU, 2);

    orderedCovariateU = zeros(size(foldNcovariateU));
    orderedCovariateV = zeros(size(foldNcovariateV));

    % Perform the reordering
    for col=1:numCols
        index_assignment = find(assignment(:,col));
        orderedCovariateU(:, index_assignment) = foldNcovariateU(:, col);
        orderedCovariateV(:, index_assignment) = foldNcovariateV(:, col);
    end

    ORDERED_canonicalCovariatesU{fold} = orderedCovariateU;
    ORDERED_canonicalCovariatesV{fold} = orderedCovariateV;

end

crossValidatedV = zeros(size(data, 1), size(correlates, 2));
crossValidatedU = zeros(size(data, 1), size(correlates, 2));

for fold=1:numFolds
    test_indices = test(cv, fold);
    
    crossValidatedV(test_indices, :) = ORDERED_canonicalCovariatesV{fold}(test_indices, :);
    crossValidatedU(test_indices, :) = ORDERED_canonicalCovariatesU{fold}(test_indices, :);

end

% You want to save those cross validate canonical covariates, U and V

