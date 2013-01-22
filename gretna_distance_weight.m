function [D] = gretna_distance_weight(W)

%==========================================================================
% This function is used to calculated the distance matrix of shortest path
% length between all pairs of nodes in a weighted graph or network G. NOTE,
% a mapping from weight to distance is embedded in this function, so the 
% input matrix must be a SIMILARITY matrix such that higher similarity
% corresponds to shorter distances after an inverse mapping.
%
%
% Syntax: function [D] = gretna_distance_weight(W)
%
% Input: 
%       W:
%          The adjacency matrix of G (N*N, symmetric).
%
% Output:
%       D:
%          The resultant distance matrix.
% 
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
% Modified according to BCT written by ika Rubinov, UNSW
% =========================================================================

W = abs(W);
W = W - diag(diag(W));
W(logical(W)) = 1./W(logical(W));

N = length(W);
D = zeros(N); D(~eye(N)) = inf;     %distance matrix

% Dijkstra's algorithm
for i = 1:N
    S = true(1,N);                %distance permanence (true is temporary)
    G1 = W;
    V = i;
    while 1
        S(V) = 0;                 %distance u->V is now permanent
        G1(:,V) = 0;              %no in-edges as already shortest
        for v = V
            Nei = find(G1(v,:));	%neighbours of shortest nodes
            for w = Nei;
                D(i,w) = min(D(i,w),D(i,v)+G1(v,w));
                %the smallest of old (if exist) and current path lengths
            end
        end

        minD = min(D(i,S));
        if isempty(minD)||isinf(minD), break, end;
        %isempty: all nodes reached; isinf: some nodes cannot be reached
        V = find(D(i,:)==minD);
    end
end

return