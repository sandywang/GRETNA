function [r] = gretna_assortativity(A, NumofRandom)

%==========================================================================
% This function is used to calculate the assortative coefficient for a 
% binary graph or network G.
%
%
% Syntax: functiona [r] = gretna_assortativity(A, NumofRandom)
%
% Inputs:
%          A:
%                  The adjencent matrix of G.
%          NumofRandom:
%                  The number of random networks.
% Output:
%          r.real:
%                  The assortative coefficient of the real network G
%                  (>0 for assortative and <0 for disassortative network).
%          r.rand:
%                  The assortative coefficient of comparable random networks.
%          r.zscore:
%                  The zscore of real network relative to random networks.
%
% Reference:
% 1. M. E. J. Newman (2002): Assortative Mixing in Networks. Equation (4).
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

A = abs(A);
A = A - diag(diag(A));


[deg] = sum(A);
K = sum(deg)/2;
[i,j] = find(triu(A,1));

for k = 1:K
    degi(k) = deg(i(k));
    degj(k) = deg(j(k));
end;

% compute assortativity
r.real = (sum(degi.*degj)/K - (sum(0.5*(degi+degj))/K)^2)/(sum(0.5*(degi.^2+degj.^2))/K - (sum(0.5*(degi+degj))/K)^2); % [M. E. J. Newman (2002): Assortative Mixing in Networks in equation (4)]

if NumofRandom ~= 0
    
    r.rand = zeros(1,NumofRandom);
    
    for n = 1:NumofRandom

        [A_rand] = gretna_gen_random_network1(A);
        [deg_rand] = sum(A_rand);
        K_rand = sum(deg_rand)/2;
        [i_rand,j_rand] = find(triu(A_rand,1));
        
        for k_rand = 1:K_rand
            degi_rand(k_rand) = deg_rand(i_rand(k_rand));
            degj_rand(k_rand) = deg_rand(j_rand(k_rand));
        end;
        
        % compute assortativity
        r.rand(1,n) = (sum(degi_rand.*degj_rand)/K_rand - (sum(0.5*(degi_rand+degj_rand))/K_rand)^2)/(sum(0.5*(degi_rand.^2+degj_rand.^2))/K_rand - (sum(0.5*(degi_rand+degj_rand))/K_rand)^2);
    end
    
    r.zscore = (r.real - mean(r.rand))/(std(r.rand));
    
end

return