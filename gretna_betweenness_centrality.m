function bc = gretna_betweenness_centrality(W)

%==========================================================================
% This function is used to calculated the edge's betweenness of all pairs 
% of nodes in a weighted graph or network G. NOTE,
%
%
% Syntax: function bc = gretna_betweenness_centrality(W)
%
% Input: 
%       W:
%          The adjacency matrix of G (N*N, symmetric).
%
% Output:
%       D:
%          The resultant distance matrix.
% 
% Xindi WANG, NKLCNL, BNU, BeiJing, 2013/02/27, sandywang.rest@gmail.com
% Modified according to BCT written by ika Rubinov, UNSW
% =========================================================================

W = abs(double(W));
W = W - diag(diag(W));
%W(logical(W)) = 1./W(logical(W));

N = length(W);
D = zeros(N); D(~eye(N)) = inf;     %distance matrix
NP=eye(N);
bc=zeros(N,1);

% Dijkstra's algorithm
for i = 1:N
    S = true(1,N);                %distance permanence (true is temporary)
    G1 = W;
    
    P=false(N);
    Q=zeros(1,N);
    q=N;
    
    V = i;
    while 1
        S(V) = 0;                 %distance u->V is now permanent
        G1(:,V) = 0;              %no in-edges as already shortest
        for v = V
            Q(q)=v;
            q=q-1;
            Nei = find(G1(v,:));	%neighbours of shortest nodes
            for w = Nei;
                Dw = D(i,v)+G1(v,w);
                if Dw<D(i,w)
                    D(i,w)=Dw;
                    NP(i,w)=NP(i,v);
                    P(w,:)=0;
                    P(w,v)=1;
                elseif Dw==D(i,w)
                    NP(i,w)=NP(i,w)+NP(i,v);
                    P(w,v)=1;
                end
                %the smallest of old (if exist) and current path lengths
            end
        end

        minD = min(D(i,S));
        if isempty(minD) , break;
        elseif isinf(minD)
            Q(1:q)=find(isinf(D(i,:)));
            break; 
        end;
        %isempty: all nodes reached; isinf: some nodes cannot be reached
        V = find(D(i,:)==minD);
    end
    
    DP=zeros(N,1);
    for w=Q(1:N-1)
        bc(w)=bc(w)+DP(w);
        for v=find(P(w,:))
            DP(v)=DP(v)+(1+DP(w)).*NP(i,v)./NP(i,w);
        end
    end
end

return