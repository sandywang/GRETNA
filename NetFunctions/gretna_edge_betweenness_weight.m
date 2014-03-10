function [averb bi] = gretna_edge_betweenness_weight(W)

%==========================================================================
% This function is used to calculate edge betweenness for a weighted graph
% or network G. This function is based on the matlab toolbox of Matlab-bgl.
% NOTE, W must be a SIMILARITY matrix.
%
%
% Syntax: function [averb bi] = gretna_node_betweenness_weight(W)
%
% Input:
%        W:
%                   The adjencent matrix of G (N*N, symmetric).
%
% Outputs:
%        averb:
%                Mean edge betweenness of G.
%        bi:
%                Edge betweenness of each node in G.  
%
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

W = abs(W);
W = W - diag(diag(W));
W(logical(W)) = 1./W(logical(W));

[~, tmp] = betweenness_centrality(sparse(W));

bi = full(tmp);
averb = mean(bi(logical(W)));

return