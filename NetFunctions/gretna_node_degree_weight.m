function [averk ki] = gretna_node_degree_weight(W)

%==========================================================================
% This function is used to calculate nodal degree/strength for a weighted 
% graph or network G.
%
%
% Syntax:  function [averk ki] = gretna_node_degree_weight(W)
%
% Input:
%        W:
%                The adjencent matrix of G.
%
% Outputs:
%        averk:
%                Mean nodal degree over all nodes of G.
%        ki:
%                Nodal degree of each node of G.    
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

W = abs(W);
W = W - diag(diag(W));

ki = sum(W);
averk = mean(ki);

return