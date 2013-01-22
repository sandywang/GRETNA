function [avercc cci] = gretna_node_clustcoeff_weight(W, Algorithm)

%==========================================================================
% This function is used to nodal clustering coefficient of a weighted graph G.
%
%
% Syntax: function [avercc cci] = gretna_clustcoeff_weight(W, type)
%
% Inputs:
%       W:
%          The weighted adjacency matrix (N*N, symmetric).
%       Algorithm:
%          '1':
%              Ref--Barrat et al., 2009, The architecture of complex weighted
%                   networks.
%          '2':
%              Ref--Onnela et al., 2005, Intensity and coherence of motifs
%                   in weighted complex networks.
% Outputs:
%       avercc:
%          The average clustering coefficient of all nodes in the graph G.
%       cci:
%          The clustering coefficiency of each node in the graph G.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

if strcmpi(Algorithm, '1') % Barrat's algorithm
    A = W;
    N = size(A,1);
    cci = zeros(1,N);
    
    for i = 1:N
        NV = find(A(i,:));
        if length(NV) == 1 || isempty(NV)
            cci(i) = 0;
        else
            nei = A(NV,NV);
            [X Y] = find(nei);
            cci(i) = sum([A(i,NV(X)) A(i,NV(Y))])/2/((length(NV)-1)*sum(A(i,:)));
        end
    end
    avercc = mean(cci);
    
elseif  strcmpi(Algorithm, '2') % Onnela's algorithm
    W = W/(max(max(W)));
    A=W ~= 0;                     %adjacency matrix
    S = W.^(1/3)+(W.').^(1/3);	%symmetrized weights matrix ^1/3
    K = sum(A+A.',2);            	%total degree (in + out)
    cyc3 = diag(S^3)/2;           %number of 3-cycles (ie. directed triangles)
    K(cyc3 == 0) = inf;             %if no 3-cycles exist, make C=0 (via K=inf)
    CYC3 = K.*(K-1)-2*diag(A^2);	%number of all possible 3-cycles
    cci = (cyc3./CYC3)';              %clustering coefficient
    avercc = mean(cci);
    
else
    error('Wrong input for the second argument')
end

return