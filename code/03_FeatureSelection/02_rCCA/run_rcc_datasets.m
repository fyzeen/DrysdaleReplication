%%%%%%%%%%%%%%%%
% Run RCC for Matlab using synthetic datasets
%%%%%%%%%%%%%%%%

% LOAD DATA: Two clusters with generated from distributions with different means
% Clusters each have 50 samples; data1 has 300 variables and data2 has 3 variables
load('data1.mat')
figure; gscatter(data1_cl(:,1), data2_cl(:,1), clusterLabels)

% Compare to canoncorr to RCC script without regularization using first 50 variables for data1
[A,B,r,U,V,stats]=canoncorr(data1_cl(:,1:50),data2_cl);
[results] = rcc_matlab(data1_cl(:,1:50),data2_cl, 0, 0);
diag(corr(A,results.coeff_A))'
diag(corr(B,results.coeff_B))'

% Randomly split each dataset into two halves: training set and test set
nSamples = 50;
nClusters = 2;
randP=randperm(nSamples*nClusters);
train1 = data1_cl(randP(1:nSamples*nClusters/2),:);
train2 = data2_cl(randP(1:nSamples*nClusters/2),:);
test1 = data1_cl(randP(nSamples*nClusters/2+1:end),:);
test2 = data2_cl(randP(nSamples*nClusters/2+1:end),:);

% Compare to rcc script with regularization
[A,B,r,U,V,stats]=canoncorr(train1,train2);
diag(corr(U,V))'
diag(corr(test1*A,test2*B))'

% Initialize lambdas
lambda1 = 1;
lambda2 = 0.01;
[results] = rcc_matlab(train1,train2, lambda1, lambda2);
results.r
diag(corr(test1*results.coeff_A,test2*results.coeff_B))'

% Visualize cluster separation for Variate 1 U vs V
figure(Color='white');gscatter(results.variate_U(:,1), results.variate_V(:,1), clusterLabels(randP(1:nSamples*nClusters/2)))
% Visualize cluster separation in 3D using U variates
figure(Color='white');scatter3(results.variate_U(:,1),results.variate_U(:,2), results.variate_U(:,3), 500, clusterLabels(randP(1:nSamples*nClusters/2)), '.')
% Add test canonical variates
hold on;scatter3(test1*results.coeff_A(:,1),test1*results.coeff_A(:,2), test1*results.coeff_A(:,3), 500, clusterLabels(randP(nSamples*nClusters/2+1:end)), '.')



% LOAD DATA: Four clusters with generated from distributions with different means
% Clusters each have 50 samples; data1 has 300 variables and data2 has 3 variables
load('data2.mat')
figure; gscatter(data1_cl(:,1), data2_cl(:,1), clusterLabels)

% Compare to canoncorr to RCC script without regularization using first 50 variables for data1
[A,B,r,U,V,stats]=canoncorr(data1_cl(:,1:50),data2_cl);
[results] = rcc_matlab(data1_cl(:,1:50),data2_cl, 0, 0);
diag(corr(A,results.coeff_A))'
diag(corr(B,results.coeff_B))'

% Randomly Split each dataset into two halves: training set and test set
randP=randperm(nSamples*nClusters);
train1 = data1_cl(randP(1:nSamples*nClusters/2),:);
train2 = data2_cl(randP(1:nSamples*nClusters/2),:);
test1 = data1_cl(randP(nSamples*nClusters/2+1:end),:);
test2 = data2_cl(randP(nSamples*nClusters/2+1:end),:);

% Compare to rcc script with regularization
[A,B,r,U,V,stats]=canoncorr(train1,train2);
diag(corr(U,V))'
diag(corr(test1*A,test2*B))'

% Initialize lambdas for regularization
lambda1 = 1;
lambda2 = 0.01;
[results] = rcc_matlab(train1,train2, lambda1, lambda2);
results.r
diag(corr(test1*results.coeff_A,test2*results.coeff_B))'

% Visualize cluster separation for Variate 1 U vs V
figure(Color='white');gscatter(results.variate_U(:,1), results.variate_V(:,1), clusterLabels(randP(1:nSamples*nClusters/2)))
% Visualize cluster separation in 3D using U variates
figure(Color='white');scatter3(results.variate_U(:,1),results.variate_U(:,2), results.variate_U(:,3), 500, clusterLabels(randP(1:nSamples*nClusters/2)), '.')
% Add test canonical variates
hold on;scatter3(test1*results.coeff_A(:,1),test1*results.coeff_A(:,2), test1*results.coeff_A(:,3), 500, clusterLabels(randP(nSamples*nClusters/2+1:end)), '.')
