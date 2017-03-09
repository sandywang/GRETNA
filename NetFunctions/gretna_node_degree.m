function [averk ki] = gretna_node_degree(A)

%==========================================================================
% This function is used to calculate nodal degree for a binary graph or
% network G.
%
%
% Syntax:  function [averk ki] = gretna_node_degree(A)
%
% Input:
%        A:
%                The adjencent matrix of G.
%
% Outputs:
%        avere:
%                Mean nodal degree over all nodes of G.
%        ei:
%                Nodal degree of each node of G.    
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

A = abs(A);
A = A - diag(diag(A));
A = logical(A);

ki = sum(A);
averk = mean(ki);

return