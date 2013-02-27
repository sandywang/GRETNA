function [averb bi] = gretna_node_betweenness(A)

%==========================================================================
% This function is used to calculate nodal betweenness for a binary
% graph or network G. Note that this function is based on the matlab
% toolbox of Matlab-bgl.
%
%
% Syntax: function [averb bi] = gretna_node_betweenness(A)
%
% Input:
%        A:
%                The adjencent matrix of G.
% Outputs:
%        averb:
%                Mean nodal betweenness over all nodes of G.
%        bi:
%                Nodal betweenness of each node of G.  
%
%
% Yong HE,     BIC,    MNI, McGill
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

A = abs(A);
A = A - diag(diag(A));

bc = gretna_betweenness_centrality(A);

bi = bc'/2;
averb = mean(bi);

return