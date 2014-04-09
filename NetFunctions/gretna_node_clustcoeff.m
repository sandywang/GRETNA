function [avercc, cci] = gretna_node_clustcoeff(A)

%==========================================================================
% This function is used to nodal clustering coefficient of a binary graph G.
%
%
% Syntax: [avercc, cci] = gretna_clustcoeff(A)
%
% Input:
%       A:
%          The binary adjacency matrix of G (N*N, symmetric).
% Outputs:
%       avercc:
%          The average clustering coefficient of all nodes in graph G.
%       cci:
%          The clustering coefficiency of each node in graph G.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

N = size(A,1);
cci = zeros(1,N);

for i = 1:N
    NV = find(A(i,:));
    if length(NV) == 1 || isempty(NV)
        cci(i) = 0;
    else
        cci(i) = ((sum(sum(A(NV,NV))))/2)/((length(NV)^2-length(NV))/2);
    end
end

avercc = mean(cci);

return