function [pvals] = spearman_corr(A, B)
%SPEARMAN_CORR Computes pairwise spearman correlations of columns in
%   matrices A and B. PVALUES go into correlations matrix

numColumnsA = size(A, 2);
numColumnsB = size(B, 2);

pvals = zeros(numColumnsA, numColumnsB);

for i=1:numColumnsA
    columnA = A(:, i);

    for j=1:numColumnsB
        columnB = B(:, j);

        [~, pval] = corr(columnA, columnB, 'Type', 'Spearman');
        
        pvals(i, j) = pval;
    end
end

end

