function [averlocE locEi] = gretna_node_local_efficiency_weight(W)

%==========================================================================
% This function is used to calculate nodal local efficiency for a weighted
% graph or network G. NOTE, W must be a SIMILARITY matrix.
%
%
% Syntax:  function [averlocE locEi] = gretna_node_local_efficiency_weight(W)
%
% Input:
%        W:
%                The adjencent matrix of G.
%
% Outputs:
%     averlocE:
%                Mean nodal local efficiency over all nodes of G (i.e.
%                local efficiency of G).
%        locEi:
%                Nodal local efficiency of each node of G.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2012/08/19, Jinhui.Wang.1982@gmail.com
%==========================================================================

N = length(W);
locEi = zeros(1,N);

for i=1:N
    NV =  find(W(i,:));
    if length(NV) > 1
        B = W(NV,NV);
        [locEi(i), tmp] = gretna_node_global_efficiency_weight(B);
    end
end

averlocE = mean(locEi);

return