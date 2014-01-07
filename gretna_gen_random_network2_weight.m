function [Wrand] = gretna_gen_random_network2_weight(W)

%==========================================================================
% This function is used to generate a random weighted network G with the same
% N, K and degree distribution as a real network using Maslovs wiring algorithm
% (Maslov et al. 2002). Meanwhile, the correspongding weights are redistributed.
% This function is slightly revised according to Maslov's wiring program
% (http://www.cmth.bnl.gov/~maslov/).
%
%
% Syntax: function [Wrand] = gretna_gen_random_network1_weight(W)
%
% Input:
%       W:
%           The adjacency matrix of G (N*N, symmetric).
% Output:
%       Wrand:
%           The generated random weighted network.
%
% Yong   HE,   BIC,    MNI, McGill,  2007/05/01
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

W = W - diag(diag(W));
Topo = W;
Topo(Topo ~= 0) = 1;

N = length(Topo);
K = sum(sum(Topo))/2;

if K == N*(N-1)/2
    [~, Weivec] = gretna_matrix2triu(W);
    
    randwei = Weivec(randperm(length(Weivec)));
    [Wrand] = gretna_triu2matrix (randwei, N);
    return
    
else
      
    nrew = 0;
    
    [i1,j1] = find(Topo);
    aux = find(i1>j1);
    i1 = i1(aux);
    j1 = j1(aux);
    Ne = length(i1);
    
    ntry = 2*Ne;
    
    for i = 1:ntry
        e1 = 1+floor(Ne*rand);
        e2 = 1+floor(Ne*rand);
        v1 = i1(e1);
        v2 = j1(e1);
        v3 = i1(e2);
        v4 = j1(e2);
        %     if Wrand(v1,v2) < 1;
        %         v1
        %         v2
        %         Wrand(v1,v2)
        %         pause;
        %     end;
        %     if Wrand(v3,v4) < 1;
        %         v3
        %         v4
        %         Wrand(v3,v4)
        %         pause;
        %     end;
        
        if (v1~=v3)&&(v1~=v4)&&(v2~=v4)&&(v2~=v3);
            if rand > 0.5;
                if (Topo(v1,v3)==0)&&(Topo(v2,v4)==0);
                    
                    % the following line prevents appearance of isolated
                    % clusters of size 2
                    % if (k1(v1).*k1(v3)>1)&(k1(v2).*k1(v4)>1);
                    
                    Topo(v1,v2) = 0;
                    Topo(v3,v4) = 0;
                    Topo(v2,v1) = 0;
                    Topo(v4,v3) = 0;
                    
                    Topo(v1,v3) = 1;
                    Topo(v2,v4) = 1;
                    Topo(v3,v1) = 1;
                    Topo(v4,v2) = 1;
                    
                    nrew = nrew+1;
                    
                    i1(e1) = v1;
                    j1(e1) = v3;
                    i1(e2) = v2;
                    j1(e2) = v4;
                    
                    % the following line prevents appearance of isolated
                    % clusters of size 2
                    % end;
                    
                end;
            else
                v5 = v3;
                v3 = v4;
                v4 = v5;
                clear v5;
                
                if (Topo(v1,v3)==0)&&(Topo(v2,v4)==0);
                    
                    % the following line prevents appearance of isolated
                    % clusters of size 2
                    % if (k1(v1).*k1(v3)>1)&(k1(v2).*k1(v4)>1);
                    
                    Topo(v1,v2) = 0;
                    Topo(v4,v3) = 0;
                    Topo(v2,v1) = 0;
                    Topo(v3,v4) = 0;
                    
                    Topo(v1,v3) = 1;
                    Topo(v2,v4) = 1;
                    Topo(v3,v1) = 1;
                    Topo(v4,v2) = 1;
                    
                    nrew=nrew+1;
                    
                    i1(e1) = v1;
                    j1(e1) = v3;
                    i1(e2) = v2;
                    j1(e2) = v4;
                    
                    % the following line prevents appearance of isolated
                    % clusters of size 2
                    % end;
                    
                end;
            end;
        end;
    end;
end



Weivec = W(logical(triu(W)));
randwei = Weivec(randperm(length(Weivec)));

Mid = triu(Topo);
Mid(Mid ~= 0) = randwei;
Wrand = Mid + Mid';

return