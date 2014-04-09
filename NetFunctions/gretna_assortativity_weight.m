function [r] = gretna_assortativity_weight(W, NumofRandom)

%==========================================================================
% This function is used to calculate the assortative coefficient for a 
% weighted graph or network G.
%
%
% Syntax: functiona [r] = gretna_assortativity(W, NumofRandom)
%
% Inputs:
%          W:
%                  The adjencent matrix of G.
%          NumofRandom:
%                  The number of random networks;
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
% 1. Leung and Chau (2007):  Weighted assortative and disassortative networks
%                            model. Equation (15).
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

W = abs(W);
W = W - diag(diag(W));

H = sum(sum(W))/2;
Mat = W;
Mat(Mat ~= 0) = 1;
[deg] = sum(Mat);
K = sum(deg)/2;
[i,j,v] = find(triu(W,1));

for k = 1:K
    degi(k,1) = deg(i(k));
    degj(k,1) = deg(j(k));
end

% compute assortativity
r.real = (sum(v.*degi.*degj)/H - (sum(0.5*(v.*(degi+degj)))/H)^2)/(sum(0.5*(v.*(degi.^2+degj.^2)))/H - (sum(0.5*(v.*(degi+degj)))/H)^2); % [Leung and Chau (2007): Weighted assortative and disassortative networks model. Equation (15)].

if NumofRandom ~= 0
    
    r.rand = zeros(1,NumofRandom);
    
    for n = 1:NumofRandom

        [W_rand] = gretna_gen_random_network1_weight(W);
        H_rand = sum(sum(W_rand))/2;
        Mat_rand = W_rand;
        Mat_rand(Mat_rand ~= 0) = 1;
        [deg_rand] = sum(Mat_rand);
        K_rand = sum(deg_rand)/2;
        [i_rand,j_rand,v_rand] = find(triu(W_rand,1));
        
        for k_rand = 1:K_rand
            degi_rand(k_rand,1) = deg_rand(i_rand(k_rand));
            degj_rand(k_rand,1) = deg_rand(j_rand(k_rand));
        end
        
        % compute assortativity
        r.rand(1,n) = (sum(v_rand.*degi_rand.*degj_rand)/H_rand - (sum(0.5*(v_rand.*(degi_rand+degj_rand)))/H_rand)^2)/(sum(0.5*(v_rand.*(degi_rand.^2+degj_rand.^2)))/H_rand - (sum(0.5*(v_rand.*(degi_rand+degj_rand)))/H_rand)^2);
    end
    
    r.zscore = (r.real - mean(r.rand))/(std(r.rand));
    
end

return