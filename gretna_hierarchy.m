function [beta] = gretna_hierarchy(A, NumofRandom)

%==========================================================================
% This function is used to calculate the hierarchical coefficient for a
% binary graph or network G.
%
%
% Syntax: function [beta] = gretna_hierarchy(A, NumofRandom)
%
% Inputs:
%        A:
%            The adjencent matrix of G.
%        NumofRandom:
%            The number of random networks used as benchmark.
%
% Outputs:
%        beta.real:
%            The fitted beta value between nodal degree and clustering
%            coefficicent of the real network G.
%        beta.rand:
%            The fitted beta values between nodal degree and clustering
%            coefficicent for random networks.
%        beta.zscore:
%            The zscore of real network relative to random networks.
%
% Reference:
% 1. Ravasz E, Barabasi AL (2003) Hierarchical organization in complex networks.
%    Phys Rev E Stat Nonlin Soft Matter Phys 67: 026112.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

[~, ki] = gretna_node_degree(A);
[~, cci] = gretna_node_clustcoeff(A);

if all(cci == 0) || all(ki == 0)
    beta.real = nan;
else
    index1 = find(ki == 0);
    index2 = find(cci == 0);
    ki([index1 index2]) = [];
    cci ([index1 index2]) = [];
    
    % compute fitted beta
    stats = regstats(log(cci),log(ki),'linear','beta');
    beta.real = -stats.beta(2);
end

if NumofRandom ~= 0
    
    for n = 1:NumofRandom
        [Arand] = gretna_gen_random_network1(A);
        
        [~, ki_rand] = gretna_node_degree(Arand);
        [~, cci_rand] = gretna_node_clustcoeff(Arand);
                
        if all(cci_rand == 0) || all(ki_rand == 0)
            beta.rand(n) = nan;
        else
            index_rand1 = find(ki_rand == 0);
            index_rand2 = find(cci_rand == 0);
            ki_rand([index_rand1 index_rand2]) = [];
            cci_rand ([index_rand1 index_rand2])  = [];
            
            stats_rand = regstats(log(cci_rand),log(ki_rand),'linear','beta');
            beta.rand(n,1) = -stats_rand.beta(2);
        end
    end
    
    beta.zscore = (beta.real - mean(beta.rand(~isnan(beta.rand))))/std(beta.rand(~isnan(beta.rand)));
end

return