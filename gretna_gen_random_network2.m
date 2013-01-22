function [Arand] = gretna_gen_random_network2(A)

%==========================================================================
% This function is used to generate a random matrix with N nodes and K edges
% as a real binary network G. The edges are randomly connected.
%
%
% Syntax: functiona [Arand] = gretna_gen_random_network2(A)
%
% Input: 
%      A:
%            The adjacency matrix of G (N*N, symmetric).
%
% Output:
%       Arand:
%            The generated random network.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2012/08/15, Jinhui.Wang.1982@gmail.com
%==========================================================================

N = length(A);
K = sum(A(:))/2;

randp = randperm(N*(N-1)/2);
Value = zeros(length(randp),1);
Value(randp(1:K)) = 1;

Arand = gretna_triu2matrix(Value, N);

return