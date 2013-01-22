function [N, K, sw] = gretna_sw_efficiency_weight(W, n, randtype)
% =========================================================================
% This function is used to calculate network efficiency (local and global
% efficiency) of a binarized graph or network G that is characterized by a
% adjacency matrix W. NOTE, W must be a SIMILARITY matrix.
%
%
% Syntax: function [N, K, sw] = gretna_efficiency_sw_weight(W, n, randtype)
%
% Inputs:
%                W:
%                   The weighted adjacency matrix (N*N, symmetric).
%                n:
%                   The number of generated random networks (default: n =
%                   100).
%         randtype:
%                   1: The random matrix was generated using a modified
%                   Maslov's wiring program (Maslov and Sneppen 2002).
%                   When the edges are randomly rewired, their weights are
%                   not changed (default).
%                   2: The random matrix was generated using a modified
%                   Maslov's wiring program (Maslov and Sneppen 2002).
%                   Weights are randomly redistributed on the network.
%
% Outputs:
%                N:
%                   The number of nodes in the graph G.
%                K:
%                   The number of edges in the graph G.
%     sw.nodallocE:
%                   Local efficiency of each node in network G. If a
%                   node i has only an edge or no edges, so E(i) = 0.
% sw.nodallocErand:
%                   Local efficiency of each node in random networks.
%          sw.locE:
%                   Local efficiency of network G (i.e. the average of
%                   local efficiency over all nodes in network G).
%      sw.locErand:
%                   Local efficiencies of comparable random networks.
%       sw.nodalgE:
%                   Global efficiency of each node in network G.
%   sw.nodalgErand:
%                   Global efficiency of each node in random networks.
%            sw.gE:
%                   Global efficiency of the network G (i.e. the average of
%                   global efficiency over all nodes in network G).
%        sw.gErand:
%                   Global efficiencies of comparable random networks.
%        sw.GammaE:
%                   The relative local efficiency
%                   [sw.GammaE = sw.locE/mean(sw.locErand)].
%       sw.LambdaE:
%                   The relative global efficiency
%                   [sw.LambdaE = sw.gE/mean(sw.gErand)].
%        sw.SigmaE:
%                   A scalar small-world parameter
%                   [sw.SigmaE = sw.GammaE/sw.LambdaE].
%
% References:
% 1. Latora V, Marchiori M (2001, 2003) Efficient behavior of small-world
%    networks. Phys Rev Lett 87: 198701.
% 2. Wang J, Wang L, Zang Y, Yang H, Tang H, et al. (2009)
%    Parcellation-dependent small-world brain functional networks: a
%    resting-state fMRI study. Hum Brain Mapp 30: 1511-1523.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

if nargin < 1
    error('No input parameters'); end

if nargin == 1
    n = 100; randtype = 1; end

if nargin == 2
    randtype = 1; end

if nargin > 3
    error('Too many input parameters, 1 <= the numer of parameters <= 3');end

W = abs(W);
W = W - diag(diag(W));

N = length(W);
K = length(find(triu(W)));

if n == 0
    sw.nodallocE = zeros(1,N);
    sw.locE      = [];
    sw.nodalgE   = zeros(1,N);
    sw.gE        = [];
else
    sw.nodallocE   = zeros(1,N);
    sw.nodallocErand = zeros(n,N);
    sw.locE        = [];
    sw.locErand    = zeros(n,1);
    
    sw.nodalgE     = zeros(1,N);
    sw.nodalgErand = zeros(n,N);
    sw.gE          = [];
    sw.gErand      = zeros(n,1);
    
    sw.Gamma      = [];
    sw.Lambda     = [];
    sw.Sigma      = [];
end

% Properites of real network G
% global efficiency
[sw.gE sw.nodalgE] = gretna_node_global_efficiency_weight(W);

% local efficiency
[sw.locE sw.nodallocE] = gretna_node_local_efficiency_weight(W);

% Properites of random network G
if n ~= 0
    for i = 1:n
        fprintf('.');
        if randtype == 1
            Wrand = gretna_gen_random_network1_weight(W);
        else
            Wrand = gretna_gen_random_network2_weight(W);
        end
        
        % global efficiency
        [sw.gErand(i), sw.nodalgErand(i,:)] = gretna_node_global_efficiency_weight(Wrand);
        
        % local efficiency
        [sw.locErand(i), sw.nodallocErand(i,:)] = gretna_node_local_efficiency_weight(Wrand);
    end
    
    sw.Gamma       = sw.locE/mean(sw.locErand);
    sw.Lambda      = sw.gE/mean(sw.gErand);
    sw.Sigma       = sw.Gamma/sw.Lambda;
end

fprintf('finished!\n');

return