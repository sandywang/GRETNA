function [averLp Lpi] = gretna_node_shortestpathlength(A)

%==========================================================================
% This function is used to calculated nodal shortest path length of a binary
% graph or network G. Harmonic mean is used to address possible condition
% of multiple components.
%
%
% Syntax: function [averLp Lpi] = gretna_node_shortestpathlength(A)
%
% Input: 
%            A:
%              The adjencent matrix of G.
%
% Outputs:
%       averLp:
%              Mean nodal shortest path length overall all nodes of G (i.e. 
%              characteristic path length of G).
%       Lpi:
%              Nodal shortest path length of each node of G.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

N = length(A);

D = gretna_distance(A);

D = D + diag(diag(1./zeros(N,N)));
D = 1./D;

Lpi = 1./(sum(D)/(N-1));
averLp = 1/(sum(sum(D))/(N*(N-1)));

return




