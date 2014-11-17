function [N, K, sw] = gretna_sw_harmonic_weight(W, wCptype, n, randtype)

%==========================================================================
% This function is used to calculate the small-world properties (clustering
% coefficient and shortest path length) of a weighted graph or network G 
% that is characterized by a adjacency matrix W. NOTE, W must be a 
% SIMILARITY matrix.
%
%
% function [N, K, sw] = gretna_sw_harmonic_weight(W, wCptype, n, randtype)
%
% Inputs:
%                W:
%                   The weighted adjacency matrix (N*N, symmetric).
%
%           wCptype:
%                   The type of weighted clustering coefficient.
%                   1: Calculate weighted clustering coefficient according
%                   to Barrat et al.'s paper(PNAS 2004);
%                   2: Calculate weighted clustering coefficient according
%                   to Onnela et al.'s paper (Physical Review E 2005)
%                   (default).
%
%                 n:
%                   The number of generated random matrix (default: n =
%                   100).
%          randtype:
%                   1: The random matrix was generated using a modified
%                   Maslov's wiring program (Maslov and Sneppen 2002).
%                   When the edges are randomly rewired, their weights are
%                   not changed (default).
%                   2: The random matrix was generated using a modified
%                   Maslov's wiring program (Maslov and Sneppen 2002).
%                   Weights are randomly redistributed on the network.
%
% Outputs:
%                 N:
%                   The number of nodes in the graph G.
%                 K:
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
% 4. Newman MEJ. The structure and function of complex networks. Siam
%    Rev 2003;45(2):167¨C256.
% 5. Barrat A, Barthelemy M, Pastor-Satorras R, Vespignani A (2004) The
%    architecture of complex weighted networks. Proc Natl Acad Sci U S A
%    101:3747-3752.
% 6. Onnela J-P, Saramaki J, Kertesz J, Kaski K. Intensity and coherence of
%    motifs in weighted complex networks. Phys Rev E 2005; 71: 065103.
%
% Yong   HE,   BIC,    MNI, McGill,  2007/05/01
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

if nargin < 1
    error('No input parameters'); end

if nargin == 1
    wCptype = 2; n = 100; randtype = 1; end

if nargin == 2
    n = 100; randtype = 1; end

if nargin == 3
    randtype = 1; end

if nargin > 4
    error('Too many input parameters, 1 <= the numer of parameters <= 4');end


W = W - diag(diag(W));
W = abs(W);

N = length(W);
K = sum(sum(logical(W)))/2;

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
[sw.Cp sw.nodalCp] = gretna_node_clustcoeff_weight(W,wCptype);

% shortest path length
[sw.Lp sw.nodalLp] = gretna_node_shortestpathlength_weight(W);

% properties of random networks
if n ~= 0
    for i = 1:n
        fprintf('.');
        if randtype == 1
            Wrand = gretna_gen_random_network1_weight(W);
        else
            Wrand = gretna_gen_random_network2_weight(W);
        end
        
        % clustering coefficient
        if wCptype == 1
            [sw.Cprand(i), sw.nodalCprand(i,:)] = gretna_node_clustcoeff_weight(Wrand,'1');
        else
            [sw.Cprand(i), sw.nodalCprand(i,:)] = gretna_node_clustcoeff_weight(Wrand,'2');
        end
        
        % shortest path length
        [sw.Lprand(i), sw.nodalLprand(i,:)] = gretna_node_shortestpathlength_weight(Wrand);
    end
    
    sw.Gamma     = sw.Cp/mean(sw.Cprand);
    sw.Lambda    = sw.Lp/mean(sw.Lprand);
    sw.Sigma     = sw.Gamma/sw.Lambda;
end

fprintf('finished!\n');

return