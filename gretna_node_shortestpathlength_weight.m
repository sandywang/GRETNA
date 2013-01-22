function [averLp, Lpi] = gretna_node_shortestpathlength_weight(W)

%==========================================================================
% This function is used to calculated nodal shortest path length of a
% weighted graph or network G. Harmonic mean is used to address possible
% condition of multiple components. NOTE, W must be a SIMILARITY matrix.
%
%
% Syntax: function [averlp, lpi] = gretna_node_shortestpathlength_weight(D)
%
% Input: 
%            W:
%                The adjencent matrix of G.
%
% Outputs:
%       averLp:
%                The average shortest path length of all nodes in graph G.
%       Lpi:
%                The shortest path length of each node in graph G.
% 
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
% =========================================================================

N = length(W);

D = gretna_distance_weight(W);

D = D + diag(diag(1./zeros(N,N)));
D = 1./D;

Lpi = 1./(sum(D)/(N-1));
averLp = 1/(sum(sum(D))/(N*(N-1)));

return