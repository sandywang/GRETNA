function [averb bi] = gretna_node_betweenness_weight(W)

%==========================================================================
% This function is used to calculate nodal betweenness for a weighted 
% graph or network G. This function is based on the matlab toolbox of
% Matlab-bgl. NOTE, W must be a SIMILARITY matrix.
%
%
% Syntax: function [averb bi] = gretna_node_betweenness_weight(W)
%
% Input:
%        W:
%                The adjencent matrix of G.
% Outputs:
%        averb:
%                Mean nodal betweenness over all nodes G.
%        bi:
%                Nodal betweenness of each node of G.  
%
%
% Yong HE,     BIC,    MNI, McGill
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

W = abs(W);
W = W - diag(diag(W));
W(logical(W)) = 1./W(logical(W));

x = sparse(W);

[tmp, ~] = betweenness_centrality(x);

bi = tmp'/2;
averb = mean(bi);

return