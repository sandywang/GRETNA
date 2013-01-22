function [averb bi] = gretna_edge_betweenness(A)

%==========================================================================
% This function is used to calculate edge betweenness for a binary graph or
% network G. This function is based on the matlab toolbox of Matlab-bgl.
%
%
% Syntax: function [averb bi] = gretna_edge_betweenness(A)
%
% Input:
%        A:
%                The adjencent matrix of G (N*N, symmetric).
% Outputs:
%        averb:
%                Nodal betweenness of G.
%        bi:
%                Nodal betweenness of each node in G.  
%
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

A = abs(A);
A = A - diag(diag(A));

[tmp, ~] = betweenness_centrality(sparse(A));

bi = full(tmp);
averb = mean(bi(logical(A)));

return