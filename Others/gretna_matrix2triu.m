function [Index, Value] = gretna_matrix2triu(A)

%==========================================================================
% This function is used to extract Upper triangular non-zero values of a 
% matrix or network G.
%
%
% Syntax: function [Index, Value] = gretna_matrixtotriu(A)
%
% Input: 
%        A:
%                The adjencent matrix of G.
%
% Outputs:
%        Index:
%                The subscript of elements in Upper triangular of G.
%        Value:
%                The values of elements corresponding to Index.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

a = ones(size(A));
a = tril(a,-1);

ind = find(a);

[Row Col] = ind2sub(size(A),ind);
Index = [Col Row];

Value = A(ind).*a(ind);

return