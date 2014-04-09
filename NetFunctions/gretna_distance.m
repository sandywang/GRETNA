function [D] = gretna_distance(A)

%==========================================================================
% This function is used to calculated the distance matrix of shortest path
% length between all pairs of nodes in a binary graph or network G. 
% Currently, the calculation is based on a MatlabBGL function.
%
%
% Syntax: function [D] = gretna_distance(A)
%
% Input: 
%       A:
%          The adjacency matrix of G (N*N, symmetric).
%
% Output:
%       D:
%          The resultant distance matrix.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

A = abs(A);
A = A - diag(diag(A));

[D] = all_shortest_paths(sparse(double(A)),struct('algname','auto'));

% A = abs(A);
% A = A - diag(diag(A));
% A(A==0) = inf;
% 
% N = length(A);
% 
% D = A - diag(diag(A));
% 
% % Floyd-Warshall algorithm
% for i = 1:N
%     k = setdiff((1:N),i);
%     D(k,k) = min(D(k,k),repmat(D(k,i),1,N-1) + repmat(D(i,k),N-1,1));
% end
% 
% D = triu(D,1) + tril(D,-1);

return