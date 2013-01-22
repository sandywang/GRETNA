function [N, K, sw] = gretna_sw_efficiency(A, n, randtype)

%==========================================================================
% This function is used to calculate network efficiency (local and global
% efficiency) of a binarized graph/network G that is characterized by a
% adjacency matrix A.
%
%
% Syntax: function [N, K, sw] = gretna_sw_harmonic(A, n, randtype)
%
% Inputs:
%                 A:
%                   The binarized adjacency matrix (N*N, symmetric).
%                 n:
%                   The number of generated random matrix (default: n =
%                   100).
%          randtype:
%                   1: The random matrix was generated using Maslov's wiring
%                   program (Maslov and Sneppen 2002). This resulting
%                   matrix has the same number of nodes N, edges K and
%                   degree distribution as the real network G(default).
%                   2: The random matrix was generated using a general
%                   random algorithms. The resulting matrix has the same
%                   number of nodes N and edges K as the real network G.
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
%         sw.Gamma:
%                   The relative local efficiency
%                   [sw.GammaE = sw.locE/mean(sw.locErand)].
%        sw.Lambda:
%                   The relative global efficiency
%                   [sw.LambdaE = sw.gE/mean(sw.gErand)].
%         sw.Sigma:
%                   A scalar small-world parameter
%                   [sw.SigmaE = sw.GammaE/sw.LambdaE].
%
% References:
% 1. Watts DJ, Strogatz SH (1998) Collective dynamics of 'small-world'
%    networks. Nature 393:440-442.
% 2. Maslov S, Sneppen K (2002) Specificity and stability in topology of
%    protein networks. Science 296:910-913.
% 3. Latora V, Marchiori M (2001) Efficient behavior of small-world
%    networks. Phys Rev Lett 87: 198701.
% 4. Wang J, Wang L, Zang Y, Yang H, Tang H, et al. (2009)
%    Parcellation-dependent small-world brain functional networks: a
%    resting-state fMRI study. Hum Brain Mapp 30: 1511-1523.
%
% Yong   HE,   BIC,    MNI, McGill,  2007/05/01
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

if nargin < 1
    error('No input parameters'); end

if nargin == 1
    n = 100; randtype = 1; end

if nargin == 2
    randtype = 1; end

if nargin > 3
    error('The number of parameters:<3.'); end

A = A - diag(diag(A));
A = abs(A);
N = length(A);
K = sum(sum(A))/2;

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

% Properties of real network
% global efficiency
[sw.gE sw.nodalgE] = gretna_node_global_efficiency(A);

% local efficiency
[sw.locE sw.nodallocE] = gretna_node_local_efficiency(A);

% Properties of random networks
if n~=0
    for i = 1:n
        fprintf('.');
        if randtype == 1
            [Arand] =  gretna_gen_random_network1(A);
        else
            [Arand] =  gretna_gen_random_network2(N,K);
        end
        
        % global efficiency
        [sw.gErand(i), sw.nodalgErand(i,:)] = gretna_node_global_efficiency(Arand);
        
        % local efficiency
        [sw.locErand(i), sw.nodallocErand(i,:)] = gretna_node_local_efficiency(Arand);
    end

    sw.Gamma        = sw.locE/mean(sw.locErand);
    sw.Lambda       = sw.gE/mean(sw.gErand);
    sw.Sigma        = sw.Gamma/sw.Lambda;
end

fprintf ('Finished! \n')

return