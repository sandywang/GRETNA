function [averlocE locEi] = gretna_node_local_efficiency(A)

%==========================================================================
% This function is used to calculate nodal local efficiency for a binary
% graph or network G.
%
%
% Syntax:  function [averlocE locEi] = gretna_node_local_efficiency(A)
%
% Input:
%        A:
%                The adjencent matrix of G.
%
% Outputs:
%     averlocE:
%                Mean nodal local efficiency over all nodes of G (i.e. 
%                local efficiency of G).
%        LocEi:
%                Nodal local efficiency of each node of G.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2012/08/19, Jinhui.Wang.1982@gmail.com
%==========================================================================

N = length(A);
locEi = zeros(1,N);

for i=1:N
    NV =  find(A(i,:));
    if length(NV) > 1
        B = A(NV,NV);
        [locEi(i), tmp] = gretna_node_global_efficiency(B);
    end
end

averlocE = mean(locEi);

return