function [net node] = gretna_sw_batch_networkanalysis(As, s1, s2, deltas, n, Thres_type)

%==========================================================================
% This function is used to calculate multiple network metrics (small-world
% parameters, network efficiency, modularity, hierarchy and assortativity,
% degree, betweenness) for binary networks of single or multiple subjects
% over single or continuous threshold range.
%
%
% Syntax: function [net node] = gretna_sw_batch_networkanalysis(As, s1, s2, deltas, n, Thres_type)
%
% Inputs:
%                As:
%                   The m*1 cell array with each cell containting a
%                   connectivity matrix (N*N, symmetric).
%                s1:
%                   The lower bound of the threshold.
%                s2:
%                   The upper bound of the threhsold.
%            deltas:
%                   The interval of the threshold.
%                 n:
%                   The number of random networks.
%        Thres_type:
%                   'r' for correlation coefficient threshold;
%                   's' for sparsity threshold.
%              Para:
%
%
% Outputs:
%            net.Cp:
%                   Clustering coefficients of real networks.
%            net.Lp:
%                   Shortest path lengths of real networks.
%          net.locE:
%                   Local efficiencies of real networks.
%            net.gE:
%                   Global efficiencies of real networks.
%           net.deg:
%                   Degrees of real networks.
%            net.bw:
%                   Betweennesses of real networks.
%           net.mod:
%                   The modularities of real networks.
%
%        net.Cprand:
%                   Clustering coefficients of comparable random networks.
%        net.Lprand:
%                   Shortest path lengths of comparable random networks.
%      net.locErand:
%                   Local efficiencies of comparable random networks.
%        net.gErand:
%                   Global efficiencies of comparable random networks.
%       net.degrand:
%                   Degrees of comparable random networks.
%        net.bwrand:
%                   Betweennesses of comparable random networks.
%       net.modrand:
%                   The modularities of comparable random networks.
%
%       net.Cpratio:
%                   The ratio of clustering coefficients between real
%                   networks and comparable random networks (i.e., gamma).
%       net.Lpratio:
%                   The ratio of shortest path lengths between real
%                   networks and comparable random networks (i.e., lambda).
%     net.locEratio:
%                   The ratio of local efficiencies between real
%                   networks and comparable random networks (i.e., gamma).
%       net.gEratio:
%                   The ratio of global efficiencies between real
%                   networks and comparable random networks (i.e., lambda).
%      net.degratio:
%                   The ratio of degrees between real networks and comparable
%                   random networks.
%       net.bwratio:
%                   The ratio of Betweennesses between real networks and
%                   comparable random networks.
%      net.modratio:
%                   The ratio of modularities between real networks and
%                   comparable random networks.
%
%           net.aCp:
%                   The area under curve of clustering coefficients.
%           net.aLp:
%                   The area under curve of shortest path lengths.
%         net.alocE:
%                   The area under curve of local efficiencies.
%           net.agE:
%                   The area under curve of global efficiencies.
%          net.adeg:
%                   The area under curve of degrees.
%           net.abw:
%                   The area under curve of betweennesses.
%          net.amod:
%                   The area under curve of modularities.
%
%      net.aCpratio:
%                   The area under curve of ratios of clustering coefficients.
%      net.aLpratio:
%                   The area under curve of ratios of shortest path lengths.
%    net.alocEratio:
%                   The area under curve of ratios of local efficiencies.
%      net.agEratio:
%                   The area under curve of ratios of global efficiencies.
%     net.adegratio:
%                   The area under curve of ratios of degrees.
%      net.abwratio:
%                   The area under curve of ratios of betweennesses.
%     net.amodratio:
%                   The area under curve of ratios of modularities.
%
%
%           node.Cp:
%                   Clustering coefficients of each node in real networks.
%           node.Lp:
%                   Shortest path lengths of each node in real networks.
%         node.locE:
%                   Local efficiencies of each node in real networks.
%           node.gE:
%                   Global efficiencies of each node in real networks.
%          node.deg:
%                   Degrees of each node in real networks.
%           node.bw:
%                   Betweennesses of each node in real networks.
%
%       node.Cprand:
%                   Clustering coefficients of each node in random networks.
%       node.Lprand:
%                   Shortest path lengths of each node in random networks.
%     node.locErand:
%                   Local efficiencies of each node in random networks.
%       node.gErand:
%                   Global efficiencies of each node in random networks.
%      node.degrand:
%                   Degrees of each node in random networks.
%       node.bwrand:
%                   Betweennesses of each node in random networks.
%
%      node.Cpratio:
%                   The ratio of nodal clustering coefficients between real
%                   and comparable random networks.
%      node.Lpratio:
%                   The ratio of nodal shortest path lengths between real
%                   and comparable random networks.
%    node.locEratio:
%                   The ratio of nodal local efficiencies between real and
%                   comparable random networks.
%      node.gEratio:
%                   The ratio of nodal global efficiencies between real and
%                   comparable random networks.
%     node.degratio:
%                   The ratio of nodal degrees between real and comparable
%                   random networks.
%      node.bwratio:
%                   The ratio of nodal betweennesses between real and
%                   comparable random networks.
%
%          node.aCp:
%                   The area under curve of clustering coefficients.
%          node.aLp:
%                   The area under curve of shortest path lengths.
%        node.alocE:
%                   The area under curve of local efficiencies.
%          node.agE:
%                   The area under curve of global efficiencies.
%         node.adeg:
%                   The area under curve of degrees.
%          node.abw:
%                   The area under curve of betweennesses.
%
%     node.aCpratio:
%                   The area under curve of ratios of clustering coefficients.
%     node.aLpratio:
%                   The area under curve of ratios of shortest path lengths.
%   node.alocEratio:
%                   The area under curve of ratios of local efficiencies.
%     node.agEratio:
%                   The area under curve of ratios of global efficiencies.
%    node.adegratio:
%                   The area under curve of ratios of degrees.
%     node.abwratio:
%                   The area under curve of ratios of betweennesses.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

Nsubs = size(As,1);

Thres = s1:deltas:s2;

if Thres_type == 's'
    
    for sub = 1:Nsubs % subjects
        
        fprintf('----------------------------------------------------------\n')
        fprintf('Calculating network parameters of subject %d \n', sub);
        fprintf('----------------------------------------------------------\n')
        
        for thres_j = 1:length(Thres) % threshold
            
            fprintf ('Sparsity threshold = %.2f\n', Thres(thres_j));
            
            % binarize
            bin = gretna_R2b(As{sub},'s',Thres(thres_j));
            
            % clustering coefficient
            [net.Cp(thres_j,sub), node.Cp(thres_j,sub,:)] = gretna_node_clustcoeff(bin);
            
            % shortest path length
            [net.Lp(thres_j,sub), node.Lp(thres_j,sub,:)] = gretna_node_shortestpathlength(bin);
            
            % local efficiency
            [net.locE(thres_j,sub), node.locE(thres_j,sub,:)] = gretna_node_local_efficiency(bin);
            
            % global efficiency
            [net.gE(thres_j,sub), node.gE(thres_j,sub,:)]   = gretna_node_global_efficiency(bin);
            
            % degree
            [net.deg(thres_j,sub), node.deg(thres_j,sub,:)] = gretna_node_degree(bin);
            
            % betweenness
            [net.bw(thres_j,sub), node.bw(thres_j,sub,:)]  = gretna_node_betweenness(bin);
            
            % modularity
            [M] = gretna_modularity(bin, '2', 0);
            net.mod(thres_j,sub) = M.modularity_real;
            
            if n > 0
                for nrand = 1:n % random network
                    
                    fprintf('.');
                    
                    Arand = gretna_gen_random_network1(bin);
                    
                    % clustering coefficient
                    [net.Cprand(thres_j,sub,nrand), node.Cprand(thres_j,sub,:,nrand)] = gretna_node_clustcoeff(Arand);
                    
                    % shortest path length
                    [net.Lprand(thres_j,sub,nrand), node.Lprand(thres_j,sub,:,nrand)] = gretna_node_shortestpathlength(Arand);
                    
                    % local efficiency
                    [net.locErand(thres_j,sub,nrand), node.locErand(thres_j,sub,:,nrand)] = gretna_node_local_efficiency(Arand);
                    
                    % global efficiency
                    [net.gErand(thres_j,sub,nrand), node.gErand(thres_j,sub,:,nrand)] = gretna_node_global_efficiency(Arand);
                    
                    % degree
                    [net.degrand(thres_j,sub,nrand), node.degrand(thres_j,sub,:,nrand)] = gretna_node_degree(Arand);
                    
                    % betweenness
                    [net.bwrand(thres_j,sub,nrand), node.bwrand(thres_j,sub,:,nrand)]  = gretna_node_betweenness(Arand);
                    
                    % modularity
                    [M] = gretna_modularity(Arand, '2', 0);
                    net.modrand(thres_j,sub,nrand) = M.modularity_real;
                    
                end % for random network
                fprintf('\n')
            end
            
        end % for threshold
        
        if n>0%Add by Sandy 20130809
            node.Cpratio = node.Cp     ./ mean(node.Cprand,4);
            node.Lpratio = node.Lp     ./ mean(node.Lprand,4);
            node.locEratio = node.locE ./ mean(node.locErand,4);
            node.gEratio = node.gE     ./ mean(node.gErand,4);
            node.degratio = node.deg   ./ mean(node.degrand,4);
            node.bwratio = node.bw     ./ mean(node.bwrand,4);
        
            net.Cpratio = net.Cp     ./ mean(net.Cprand,3);
            net.Lpratio = net.Lp     ./ mean(net.Lprand,3);
            net.locEratio = net.locE ./ mean(net.locErand,3);
            net.gEratio   = net.gE   ./ mean(net.gErand,3);
            net.degratio = net.deg   ./ mean(net.degrand,3);
            net.bwratio = net.bw     ./ mean(net.bwrand,3);
            net.modratio = net.mod   ./ mean(net.modrand,3);
        end
    end % for subjects
    
    % generate the area under curve (auc) to provide threshold insensitive
    % measure
    
    node.aCp   = squeeze((sum(node.Cp)   -  sum(node.Cp([1 end],:,:))/2)   * deltas);
    node.aLp   = squeeze((sum(node.Lp)   -  sum(node.Lp([1 end],:,:))/2)   * deltas);
    node.alocE = squeeze((sum(node.locE) -  sum(node.locE([1 end],:,:))/2) * deltas);
    node.agE   = squeeze((sum(node.gE)   -  sum(node.gE([1 end],:,:))/2)   * deltas);
    node.adeg  = squeeze((sum(node.deg)  -  sum(node.deg([1 end],:,:))/2)  * deltas);
    node.abw   = squeeze((sum(node.bw)   -  sum(node.bw([1 end],:,:))/2)   * deltas);
    
    node.aCpratio   = squeeze((sum(node.Cpratio)   -  sum(node.Cpratio([1 end],:,:))/2)   * deltas);
    node.aLpratio   = squeeze((sum(node.Lpratio)   -  sum(node.Lpratio([1 end],:,:))/2)   * deltas);
    node.alocEratio = squeeze((sum(node.locEratio) -  sum(node.locEratio([1 end],:,:))/2) * deltas);
    node.agEratio   = squeeze((sum(node.gEratio)   -  sum(node.gEratio([1 end],:,:))/2)   * deltas);
    node.adegratio  = squeeze((sum(node.degratio)  -  sum(node.degratio([1 end],:,:))/2)  * deltas);
    node.abwratio   = squeeze((sum(node.bwratio)   -  sum(node.bwratio([1 end],:,:))/2)   * deltas);
    
    
    net.aCp   = (sum(net.Cp)   -  sum(net.Cp([1 end],:))/2)   * deltas;
    net.aLp   = (sum(net.Lp)   -  sum(net.Lp([1 end],:))/2)   * deltas;
    net.alocE = (sum(net.locE) -  sum(net.locE([1 end],:))/2) * deltas;
    net.agE   = (sum(net.gE)   -  sum(net.gE([1 end],:))/2)   * deltas;
    net.adeg  = (sum(net.deg)  -  sum(net.deg([1 end],:))/2)  * deltas;
    net.abw   = (sum(net.bw)   -  sum(net.bw([1 end],:))/2)   * deltas;
    net.amod  = (sum(net.mod)  -  sum(net.mod([1 end],:))/2)  * deltas;
    
    net.aCpratio   = (sum(net.Cpratio)   -  sum(net.Cpratio([1 end],:))/2)   * deltas;
    net.aLpratio   = (sum(net.Lpratio)   -  sum(net.Lpratio([1 end],:))/2)   * deltas;
    net.alocEratio = (sum(net.locEratio) -  sum(net.locEratio([1 end],:))/2) * deltas;
    net.agEratio   = (sum(net.gEratio)   -  sum(net.gEratio([1 end],:))/2)   * deltas;
    net.adegratio  = (sum(net.degratio)  -  sum(net.degratio([1 end],:))/2)  * deltas;
    net.abwratio   = (sum(net.bwratio)   -  sum(net.bwratio([1 end],:))/2)   * deltas;
    net.amodratio  = (sum(net.modratio)  -  sum(net.modratio([1 end],:))/2)  * deltas;
    
else
    for sub = 1:Nsubs % subjects
        
        fprintf('----------------------------------------------------------\n')
        fprintf('Calculating network parameters of subject %d \n', sub);
        fprintf('----------------------------------------------------------\n')
        
        for thres_j = 1:length(Thres) % threshold
            
            fprintf ('Correlation threshold = %.2f \n', Thres(thres_j));
            
            % binarize
            bin = gretna_R2b(As{sub},'r',Thres(thres_j));
            
            % clustering coefficient
            [net.Cp(thres_j,sub), node.Cp(thres_j,sub,:)] = gretna_node_clustcoeff(bin);
            
            % shortest path length
            [net.Lp(thres_j,sub), node.Lp(thres_j,sub,:)] = gretna_node_shortestpathlength(bin);
            
            % local efficiency
            [net.locE(thres_j,sub), node.locE(thres_j,sub,:)] = gretna_node_local_efficiency(bin);
            
            % global efficiency
            [net.gE(thres_j,sub), node.gE(thres_j,sub,:)]   = gretna_node_global_efficiency(bin);
            
            % degree
            [net.deg(thres_j,sub), node.deg(thres_j,sub,:)] = gretna_node_degree(bin);
            
            % betweenness
            [net.bw(thres_j,sub), node.bw(thres_j,sub,:)]  = gretna_node_betweenness(bin);
            
            % modularity
            [M] = gretna_modularity(bin, '2', 0);
            net.mod(thres_j,sub) = M.modularity_real;
            
            if n > 0
                for nrand = 1:n % random network
                    
                    fprintf('.');
                    
                    Arand = gretna_gen_random_network1(bin);
                    
                    % clustering coefficient
                    [net.Cprand(thres_j,sub,nrand), node.Cprand(thres_j,sub,:,nrand)] = gretna_node_clustcoeff(Arand);
                    
                    % shortest path length
                    [net.Lprand(thres_j,sub,nrand), node.Lprand(thres_j,sub,:,nrand)] = gretna_node_shortestpathlength(Arand);
                    
                    % local efficiency
                    [net.locErand(thres_j,sub,nrand), node.locErand(thres_j,sub,:,nrand)] = gretna_node_local_efficiency(Arand);
                    
                    % global efficiency
                    [net.gErand(thres_j,sub,nrand), node.gErand(thres_j,sub,:,nrand)] = gretna_node_global_efficiency(Arand);
                    
                    % degree
                    [net.degrand(thres_j,sub,nrand), node.degrand(thres_j,sub,:,nrand)] = gretna_node_degree(Arand);
                    
                    % betweenness
                    [net.bwrand(thres_j,sub,nrand), node.bwrand(thres_j,sub,:,nrand)]  = gretna_node_betweenness(Arand);
                    
                    % modularity
                    [M] = gretna_modularity(Arand, '2', 0);
                    net.modrand(thres_j,sub,nrand) = M.modularity_real;
                    
                end % for random network 
                fprintf('\n')
            end
            
        end % for threshold
        
        node.Cpratio = node.Cp     ./ mean(node.Cprand,4);
        node.Lpratio = node.Lp     ./ mean(node.Lprand,4);
        node.locEratio = node.locE ./ mean(node.locErand,4);
        node.gEratio = node.gE     ./ mean(node.gErand,4);
        node.degratio = node.deg   ./ mean(node.degrand,4);
        node.bwratio = node.bw     ./ mean(node.bwrand,4);
        
        net.Cpratio = net.Cp     ./ mean(net.Cprand,3);
        net.Lpratio = net.Lp     ./ mean(net.Lprand,3);
        net.locEratio = net.locE ./ mean(net.locErand,3);
        net.gEratio   = net.gE   ./ mean(net.gErand,3);
        net.degratio = net.deg   ./ mean(net.degrand,3);
        net.bwratio = net.bw     ./ mean(net.bwrand,3);
        net.modratio = net.mod   ./ mean(net.modrand,3);
        
    end % for subjects
    
    % generate the area under curve (auc) to provide threshold insensitive
    % measure
    
    node.aCp   = squeeze((sum(node.Cp)   -  sum(node.Cp([1 end],:,:))/2)   * deltas);
    node.aLp   = squeeze((sum(node.Lp)   -  sum(node.Lp([1 end],:,:))/2)   * deltas);
    node.alocE = squeeze((sum(node.locE) -  sum(node.locE([1 end],:,:))/2) * deltas);
    node.agE   = squeeze((sum(node.gE)   -  sum(node.gE([1 end],:,:))/2)   * deltas);
    node.adeg  = squeeze((sum(node.deg)  -  sum(node.deg([1 end],:,:))/2)  * deltas);
    node.abw   = squeeze((sum(node.bw)   -  sum(node.bw([1 end],:,:))/2)   * deltas);
    
    node.aCpratio   = squeeze((sum(node.Cpratio)   -  sum(node.Cpratio([1 end],:,:))/2)   * deltas);
    node.aLpratio   = squeeze((sum(node.Lpratio)   -  sum(node.Lpratio([1 end],:,:))/2)   * deltas);
    node.alocEratio = squeeze((sum(node.locEratio) -  sum(node.locEratio([1 end],:,:))/2) * deltas);
    node.agEratio   = squeeze((sum(node.gEratio)   -  sum(node.gEratio([1 end],:,:))/2)   * deltas);
    node.adegratio  = squeeze((sum(node.degratio)  -  sum(node.degratio([1 end],:,:))/2)  * deltas);
    node.abwratio   = squeeze((sum(node.bwratio)   -  sum(node.bwratio([1 end],:,:))/2)   * deltas);
    
    
    net.aCp   = (sum(net.Cp)   -  sum(net.Cp([1 end],:))/2)   * deltas;
    net.aLp   = (sum(net.Lp)   -  sum(net.Lp([1 end],:))/2)   * deltas;
    net.alocE = (sum(net.locE) -  sum(net.locE([1 end],:))/2) * deltas;
    net.agE   = (sum(net.gE)   -  sum(net.gE([1 end],:))/2)   * deltas;
    net.adeg  = (sum(net.deg)  -  sum(net.deg([1 end],:))/2)  * deltas;
    net.abw   = (sum(net.bw)   -  sum(net.bw([1 end],:))/2)   * deltas;
    net.amod  = (sum(net.mod)  -  sum(net.mod([1 end],:))/2)  * deltas;
    
    net.aCpratio   = (sum(net.Cpratio)   -  sum(net.Cpratio([1 end],:))/2)   * deltas;
    net.aLpratio   = (sum(net.Lpratio)   -  sum(net.Lpratio([1 end],:))/2)   * deltas;
    net.alocEratio = (sum(net.locEratio) -  sum(net.locEratio([1 end],:))/2) * deltas;
    net.agEratio   = (sum(net.gEratio)   -  sum(net.gEratio([1 end],:))/2)   * deltas;
    net.adegratio  = (sum(net.degratio)  -  sum(net.degratio([1 end],:))/2)  * deltas;
    net.abwratio   = (sum(net.bwratio)   -  sum(net.bwratio([1 end],:))/2)   * deltas;
    net.amodratio  = (sum(net.modratio)  -  sum(net.modratio([1 end],:))/2)  * deltas;
    
end

return