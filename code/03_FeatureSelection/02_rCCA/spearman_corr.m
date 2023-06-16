function [pvals] = spearman_corr(A, B)
%SPEARMAN_CORR Computes pairwise spearman correlations of columns in
%   matrices A and B. PVALUES go into correlations matrix

numColumnsA = size(A, 2);
numColumnsB = size(B, 2);

pvals = zeros(numColumnsA, numColumnsB);

for i=1:numColumnsA
    for j=1:numColumnsB

        [~, pval] = corr(A.(i), B.(j), 'Type', 'Spearman');
        
        pvals(i, j) = pval;
    end
end

end

