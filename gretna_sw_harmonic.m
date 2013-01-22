function [N, K, sw] = gretna_sw_harmonic(A, n, randtype)

%==========================================================================
% This function is used to calculate the small-world properties (clustering
% coefficient and shortest path length) of a binary graph or network G. Of
% note, all the measures are calcualted based on the WHOLE graph.
%
%
% Syntax: function [N, K, sw] = gretna_sw_harmonic(A, n, randtype)
%
% Inputs:
%                A:
%                   The binarized adjacency matrix (N*N, symmetric).
%                n:
%                   The number of generated random matrix (default: n =
%                   100).
%         randtype:
%                   1: The random matrix was generated using Maslov's wiring
%                   program (Maslov and Sneppen 2002). This resulting
%                   matrix has the same number of nodes N, edges K and
%                   degree distribution as the real network G (default).
%                   2: The random matrix was generated using a general
%                   random algorithms. The resulting matrix has the same
%                   number of nodes N and edges K as the real network G.
%
% Outputs:
%                N:
%                   The number of nodes in the graph G.
%                K:
%                   The number of edges in the graph G.
%       sw.nodalCp:
%                   Clustering coefficient of each node in network G. If a
%                   node i has only an edge or no edges, so C(i) = 0.
%   sw.nodalCprand:
%                   Clustering coefficient of each node in random networks.
%            sw.Cp:
%                   Clustering coefficient of the network G (i.e.
%                   the average of the clustering coefficients over all
%                   nodes in network G.
%        sw.Cprand:
%                   Clustering coefficients of comparable random networks.
%       sw.nodalLp:
%                   Shortest path length of each node in network G. Of
%                   note, "harmonic mean" is used to calcuate shortest path
%                   length which has advantages in dealing with networks
%                   with multiple components.
%   sw.nodalLprand:
%                   Shortest path length of each node in random networks.
%            sw.Lp:
%                   Shortest path length of the network G (i.e. the average
%                   of shortest path lengths over all nodes in network G.
%        sw.Lprand:
%                   Shortest path length of comparable random networks.
%         sw.Gamma:
%                   The relative clustering coefficient
%                   [Gamma = sw.Cp/mean(sw.Cprand)].
%        sw.Lambda:
%                   The relative shortest path length
%                   [Lambda = sw.Lp/mean(sw.Lprand)].
%         sw.Sigma:
%                   A scalar small-world parameter
%                   [Sigma = sw.Gamma/sw.Lambda].
%
% References:
% 1. Watts DJ, Strogatz SH (1998) Collective dynamics of 'small-world'
%    networks. Nature 393:440-442.
% 2. Maslov S, Sneppen K (2002) Specificity and stability in topology of
%    protein networks. Science 296:910-913.
% 3. Humphries MD, Gurney K, Prescott TJ (2005) The brainstem reticular
%    formation is a small world, not scale-free, network. Proc R Soc Lond B
%    Biol Sci, 273:503-511.
% 4.Newman MEJ. The structure and function of complex networks. Siam
%    Rev 2003;45(2):167¨C256.
% 5. He Y, Chen ZJ, Evans AC (2007) Small-word anatomical networks in the
%    human brain revealed by cortical thickness from MRI. Cerebral Cortex.
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
    sw.nodalCp   = zeros(1,N);
    sw.Cp        = [];
    sw.nodalLp   = zeros(1,N);
    sw.Lp        = [];
else
    sw.nodalCp     = zeros(1,N);
    sw.nodalCprand = zeros(n,N);
    sw.Cp          = [];
    sw.Cprand      = zeros(n,1);
    
    sw.nodalLp     = zeros(1,N);
    sw.nodalLprand = zeros(n,N);
    sw.Lp          = [];
    sw.Lprand      = zeros(n,1);

    sw.Gamma       = [];
    sw.Lambda      = [];
    sw.Sigma       = [];
end

% Properites of real network G
% clustering coefficient
[sw.Cp, sw.nodalCp] = gretna_node_clustcoeff(A);

% shortest path length
D = gretna_distance(A);
[sw.Lp, sw.nodalLp] = gretna_node_shortestpathlength(D);

% properties of random networks
if n~=0
    for i = 1:n
        fprintf('.');
        if randtype == 1
            [Arand] =  gretna_gen_random_network1(A);
        else
            [Arand] =  gretna_gen_random_network2(N,K);
        end
        [sw.Cprand(i), sw.nodalCprand(i,:)] = gretna_node_clustcoeff(Arand);
        
        D = gretna_distance(Arand);
        [sw.Lprand(i), sw.nodalLprand(i,:)] = gretna_node_shortestpathlength(D);
    end
    
    sw.Gamma     = sw.Cp/mean(sw.Cprand);
    sw.Lambda    = sw.Lp/mean(sw.Lprand);
    sw.Sigma     = sw.Gamma/sw.Lambda;
end

fprintf('finished!\n');

return