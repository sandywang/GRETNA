
function [count,outliers_index] = gretna_remove_outlier(count);
%  [count,outliers] = gretna_remove_outlier(count);
% count: n*m: n is the number of subjects; m is the number of regions.








mu = mean(count);
sigma = std(count);
[n,p] = size(count);
% Create a matrix of mean values by
% replicating the mu vector for n rows
MeanMat = repmat(mu,n,1);
% Create a matrix of standard deviation values by
% replicating the sigma vector for n rows
SigmaMat = repmat(sigma,n,1);
% Create a matrix of zeros and ones, where ones indicate
% the location of outliers
outliers = abs(count - MeanMat) > 3*SigmaMat;
% Calculate the number of outliers in each column
nout = sum(outliers) ;
count(any(outliers,2),:) = [];
outliers_index = find(any(outliers,2)==1);