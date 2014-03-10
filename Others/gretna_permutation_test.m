function [Delta, P] = gretna_permutation_test(Para, Index_group1, Index_group2, M, Cov)

%==========================================================================
%   This function is used to perform nonparametric permutation test.
%
%
% Syntax: function [Delta P] = gretna_permutation_test(Para, Index_group1, Index_group2, M, Cov)
%
% Inputs:
%       Para:
%               N*1 array. Note, N = N1 + N2.
%       Index_group1:
%               The index of one group (N1*1 array).
%       Index_group2:
%               The index of the other group (N2*1 array).
%       M:
%               The number of permutations.
%       Cov:
%               The covariates (a N*M array).
%
% Outputs:
%       Delta:
%               The between-group differences in mean values.
%       P:
%               The significance level.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

N1 = length(Index_group1);
N2 = length(Index_group2);

Para = [Para(Index_group1); Para(Index_group2)];

if nargin == 5
    Cov  = [Cov(Index_group1,:); Cov(Index_group2,:)];
    stat = gretna_glm(Para, Cov, 'r');
    Para = stat.r;
end

Para_group1 = Para(1:N1);
Para_group2 = Para(N1+1:N1+N2);

Delta.real = mean(Para_group1) - mean(Para_group2); % group1 - group2

% Permutation
for num = 1:M
    randnum = randperm(N1+N2);
    rand_index1 = randnum(1:N1);
    rand_index2 = randnum(N1+1:N1+N2);
    
    rand_Para1 = Para(rand_index1);
    rand_Para2 = Para(rand_index2);
    
    Delta.rand(num) = mean(rand_Para1) - mean(rand_Para2);
end

if Delta.real > 0
    P = (1+length(find(Delta.rand > Delta.real)))/(M+1);
else
    P = (1+length(find(Delta.rand < Delta.real)))/(M+1);
end

return