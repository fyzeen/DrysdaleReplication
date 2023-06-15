function [pvals] = shuffled_spearman_corrs(A, B, numShuffles)
%SHUFFLED_SPEARMAN_CORRS Computes the pairwise spearmn correlations between 
%   columns in A and B but shuffles the rows a number of times (specified
%   by user)

numColumnsA = size(A, 2);
numColumnsB = size(B, 2);
numRowsA = size(A, 1);
numRowsB = size(B, 1);

pvals = zeros(numColumnsA, numColumnsB, numShuffles);

for shuffle=1:numShuffles
    shuffledA = A;
    shuffledB = B;

    for i=1:numColumnsA
        shuffledIndices = randperm(numRowsA);
        shuffledA(:, i) = shuffledA(shuffledIndices, i);
    end

    for i=1:numColumnsB
        shuffledIndices = randperm(numRowsB);
        shuffledB(:, i) = shuffledA(shuffledIndices, i);
    end

    pvals(:, :, shuffle) = spearman_corr(shuffledA, shuffledB);
end

end

