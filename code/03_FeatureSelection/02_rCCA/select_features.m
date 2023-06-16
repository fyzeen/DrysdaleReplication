function [indices, indexed_data] = select_features(data,corr_pvals, write_indices, path, method, topn, pval_thresh)
%SELECT_FEATURES 


numRows = size(corr_pvals, 1);
minValues = zeros(numRows, 1);

for i=1:numRows
    minValues(i) = min(corr_pvals(i,:));
end

if strcmp(method, "pval_thresh")
    indices = find(minValues < pval_thresh);
else 
    [~, indices] = mink(minValues(:), topn);
end

if write_indices
    % THIS WILL WRITE THE MATLAB INDICES, NOT PYTHON!!!!!!
    writematrix(indices, path);
end

indexed_data = data(:, indices);

end

