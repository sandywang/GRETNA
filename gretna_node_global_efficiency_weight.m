function [avergE gEi] = gretna_node_global_efficiency_weight(W)

%==========================================================================
% This function is used to calculate nodal global efficiency for a weighted
% graph or network G. NOTE, W must be a SIMILARITY matrix.
%
%
% Syntax:  function [averGe Gei] = gretna_node_global_efficiency_weight(W)
%
% Input:
%            W:
%                The adjencent matrix of G.
%
% Outputs:
%       avergE:
%                Mean nodal global efficiency over all nodes of G (i.e. 
%                global efficiency of G).
%          gEi:
%                Nodal global efficiency of each node of G.  
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

N = length(W);

D = gretna_distance_weight(W);

D = D + diag(diag(1./zeros(N,N)));
D = 1./D;

gEi    = sum(D)/(N -1);
avergE = sum(sum(D))/(N*(N-1));

return