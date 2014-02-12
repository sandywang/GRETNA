function [M] = gretna_modularity_weight(W, Algorithm, NumofRandom)

%==========================================================================
% This function is used to calculate the modularity for a weighted graph or
% network G.
%
%
% Syntax:  function [M] = gretna_modularity (W, Algorithm, NumofRandom)
%
% Inputs:
%        W:
%                The adjencent matrix of G.
%        Algorithm:
%                '1' for a modified greedy optimization algorithm
%                   (Clauset et al., 2004; Danon et al., 2006).
%                '2' for a spectral optimization algorithm
%                   (Newman,2006).
%        NumofRandom:
%                The number of random networks used as benchmark.
%
% Outputs:
%        M.modularity_real:
%                The modualrity of the real graph or network G.
%        M.numberofmodule_real:
%                The number of modules of the real graph or network G.
%        M.modularity_rand:
%                The modualrity of random networks.
%        M.numberofmodule_rand:
%                The number of modules of random networks.
%        M.modularity_zscore:
%                The zscore of real network relative to random networks.
%        M.numberofmodule_zscore:
%                The zscore of real network relative to random networks.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

W = W - diag(diag(W));
W = abs(W);

if Algorithm == '1'
    [Ci Q] = gretna_modularity_Danon(W);
    M.Ci=Ci;
    
    M.numberofmodule_real = max(Ci);
    M.modularity_real = Q;
    
    if NumofRandom ~= 0
        
        for n = 1:NumofRandom
            [Wrand] = gretna_gen_random_network1_weight(W);
            [Ci_rand Q_rand] = gretna_modularity_Danon(Wrand);
            M.numberofmodule_rand(n,1) = max(Ci_rand);
            M.modularity_rand(n,1) = Q_rand;
        end
        
        M.modularity_zscore = (M.modularity_real - mean(M.modularity_rand))/std(M.modularity_rand);
        M.numberofmodule_zscore = (M.numberofmodule_real - mean(M.numberofmodule_rand))/std(M.numberofmodule_rand);
    end
    
elseif Algorithm == '2'
    [Ci Q] = gretna_modularity_Newman(W);
    M.Ci=Ci;
    
    M.numberofmodule_real = max(Ci);
    M.modularity_real = Q;
    
    if NumofRandom ~= 0
        
        for n = 1:NumofRandom
            [Wrand] = gretna_gen_random_network1_weight(W);
            [Ci_rand Q_rand] = gretna_modularity_Newman(Wrand);
            M.numberofmodule_rand(n,1) = max(Ci_rand);
            M.modularity_rand(n,1) = Q_rand;
        end
        
        M.modularity_zscore = (M.modularity_real - mean(M.modularity_rand))/std(M.modularity_rand);
        M.numberofmodule_zscore = (M.numberofmodule_real - mean(M.numberofmodule_rand))/std(M.numberofmodule_rand);
    end
    
else
    error('Wrong input for the second argument')
end

return