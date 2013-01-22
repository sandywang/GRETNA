function [Wrand] = gretna_gen_random_network1_weight(W)

%==========================================================================
% This function is used to generate a random network with the same N, K and
% degree distribution as a  real weighted network G using Maslovs wiring
% algorithm (Maslov et al. 2002). This function is slightly revised according
% to Maslov's wiring program (http://www.cmth.bnl.gov/~maslov/). When the
% edges were randomized, the corresponding weights were bindinged with
% edges.
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
% =========================================================================

Wrand = W - diag(diag(W));
Topo = Wrand;
Topo(Topo ~= 0) = 1;
srand = Topo;
srand = srand - diag(diag(srand));
nrew = 0;

[i1,j1] = find(srand);
aux = find(i1>j1);
i1 = i1(aux);
j1 = j1(aux);
Ne = length(i1);

ntry = 2*Ne;% maximum randmised times

for i = 1:ntry
    e1 = 1+floor(Ne*rand);% randomly select two links
    e2 = 1+floor(Ne*rand);
    v1 = i1(e1);
    v2 = j1(e1);
    v3 = i1(e2);
    v4 = j1(e2);
%     if srand(v1,v2)<1;
%         v1
%         v2
%         srand(v1,v2)
%         pause;
%     end
%     if srand(v3,v4)<1;
%         v3
%         v4
%         srand(v3,v4)
%         pause;
%     end
    
    if (v1~=v3)&&(v1~=v4)&&(v2~=v4)&&(v2~=v3);
        if rand > 0.5;
            if (srand(v1,v3)==0)&&(srand(v2,v4)==0);
                
                % the following line prevents appearance of isolated clusters of size 2
                %           if (k1(v1).*k1(v3)>1)&(k1(v2).*k1(v4)>1);
                
                srand(v1,v2) = 0;
                srand(v3,v4) = 0;
                srand(v2,v1) = 0;
                srand(v4,v3) = 0;
                
                srand(v1,v3) = 1;
                srand(v2,v4) = 1;
                srand(v3,v1) = 1;
                srand(v4,v2) = 1;
                
                Wrand(v1,v3) = Wrand(v1,v2);
                Wrand(v2,v4) = Wrand(v3,v4);
                Wrand(v3,v1) = Wrand(v2,v1);
                Wrand(v4,v2) = Wrand(v4,v3);
                
                Wrand(v1,v2) = 0;
                Wrand(v3,v4) = 0;
                Wrand(v2,v1) = 0;
                Wrand(v4,v3) = 0;
                
                nrew = nrew+1;
                
                i1(e1) = v1;
                j1(e1) = v3;
                i1(e2) = v2;
                j1(e2) = v4;
                
                % the following line prevents appearance of isolated clusters of size 2
                %            end;
                
            end;
        else
            v5 = v3;
            v3 = v4;
            v4 = v5;
            clear v5;
            
            if (srand(v1,v3)==0)&&(srand(v2,v4)==0);
                
                % the following line prevents appearance of isolated clusters of size 2
                %           if (k1(v1).*k1(v3)>1)&(k1(v2).*k1(v4)>1);
                
                srand(v1,v2) = 0;
                srand(v4,v3) = 0;
                srand(v2,v1) = 0;
                srand(v3,v4) = 0;
                
                srand(v1,v3) = 1;
                srand(v2,v4) = 1;
                srand(v3,v1) = 1;
                srand(v4,v2) = 1;
                
                Wrand(v1,v3) = Wrand(v1,v2);
                Wrand(v2,v4) = Wrand(v3,v4);
                Wrand(v3,v1) = Wrand(v2,v1);
                Wrand(v4,v2) = Wrand(v4,v3);
                
                Wrand(v1,v2) = 0;
                Wrand(v3,v4) = 0;
                Wrand(v2,v1) = 0;
                Wrand(v4,v3) = 0;
                
                nrew=nrew+1;
                
                i1(e1) = v1;
                j1(e1) = v3;
                i1(e2) = v2;
                j1(e2) = v4;
                
                % the following line prevents appearance of isolated clusters of size 2
                %           end;
                
            end
        end
    end
end

return