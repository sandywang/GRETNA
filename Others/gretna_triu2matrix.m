function [A] = gretna_triu2matrix (Value, N)

%==========================================================================
% This function is used to return Upper triangular part to a N*N matrix or
% network G. NOTE, the elements in Val are entered in in the order of 
% A(1,2), A(1,3), ... A(1,N), A(2,3), ... A(2,N), A(N-1,N)].
%
%
% Syntax: function [A] = gretna_triu2matrix (Value, N)
%
% Inputs: 
%        Value:
%                The values to be embedded in Upper triangular of a matrix.
%        N:
%                The size (i.e., # of rows/columns) of the resultant matrix.
%
% Output:
%        A:
%                The resultant N*N matrix.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

a = ones(N);
a = tril(a,-1);

A = zeros(N);
A(logical(a)) = Value;
A = A + A';

return