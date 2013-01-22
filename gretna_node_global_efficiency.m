function [avergE gEi] = gretna_node_global_efficiency(A)

%==========================================================================
% This function is used to calculate nodal global efficiency for a binary 
% graph or network G.
%
%
% Syntax:  function [avergE gEi] = gretna_node_global_efficiency(A)
%
% Input:
%            A:
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

N = length(A);

D = gretna_distance(A);

D = D + diag(diag(1./zeros(N,N)));
D = 1./D;

gEi    = sum(D)/(N -1);
avergE = sum(sum(D))/(N*(N-1));

return 