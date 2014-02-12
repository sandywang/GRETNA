function [S] = gretna_synchronization(A, NumofRandom)

%==========================================================================
% This function is used to calculate the synchronization for a binary graph
% or network G. Synchronization is quantified by the ratio of S =
% lambda(2)/lambda(N), with lambda(2) and lambda(N) indicating the second
% smallest eigenvalue and the largest eigenvalue of the coupling matrix of
% A, respectively.

% Syntax: functiona [S] = gretna_synchronization(A, NumofRandom)
%
% Inputs:
%          A:
%                  The adjencent matrix of G.
%          NumofRandom:
%                  The number of random networks.
% Output:
%          S.real:
%                  The synchronization of the real network G.
%          S.rand:
%                  The synchronization of comparable random networks.
%          S.zscore:
%                  The zscore of real network relative to random networks.
%
% References:
% 1. Barahona et al. (2002): Synchronization in Small-World Systems.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

A = abs(A);
A = A - diag(diag(A));

Deg = sum(A);

D = diag(Deg,0);
G = D - A;
Eigenvalue = eig(G);

S.real = Eigenvalue(2)/Eigenvalue(end);

if NumofRandom ~= 0
    for n = 1:NumofRandom
        
        [A_rand] = gretna_gen_random_network1(A);
        
        Deg_rand = sum(A_rand);
        
        D_rand = diag(Deg_rand,0);
        G_rand = D_rand - A_rand;
        Eigenvalue_rand = eig(G_rand);
        
        S.rand(n,1) = Eigenvalue_rand(2)/Eigenvalue_rand(end);
    end
    
    S.zscore = (S.real - mean(S.rand(~isnan(S.rand))))/std(S.rand(~isnan(S.rand)));
end

return