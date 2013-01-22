function [Arand] = gretna_gen_random_network1(A)

%==========================================================================
% This function is used to generate a random network with the same number 
% of noes, number of edges and degree distribution as a real binary network
% G using Maslovs wiring algorithm (Maslov et al. 2002). This function is
% slightly revised according to Maslov's wiring program
% (http://www.cmth.bnl.gov/~maslov/).
%
%
% Syntax: functiona [Arand] = gretna_gen_random_network1(A)
%
% Input: 
%      A:
%            The adjacency matrix of G (N*N, symmetric).
%
% Output:
%      Arand:
%            The generated random network.
%
% Yong HE, BIC, MNI, McGill 2007/05/01
%==========================================================================

Arand = A;
Arand = Arand - diag(diag(Arand));
nrew = 0;

[i1,j1] = find(Arand);
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
%     if Arand(v1,v2) < 1;
%         v1
%         v2
%         Arand(v1,v2)
%         pause;
%     end;
%     if Arand(v3,v4) < 1;
%         v3
%         v4
%         Arand(v3,v4)
%         pause;
%     end;

    if (v1~=v3)&&(v1~=v4)&&(v2~=v4)&&(v2~=v3);
        if rand > 0.5;
            if (Arand(v1,v3)==0)&&(Arand(v2,v4)==0);

                % the following line prevents appearance of isolated clusters of size 2
                %           if (k1(v1).*k1(v3)>1)&(k1(v2).*k1(v4)>1);

                Arand(v1,v2) = 0;
                Arand(v3,v4) = 0;
                Arand(v2,v1) = 0;
                Arand(v4,v3) = 0;

                Arand(v1,v3) = 1;
                Arand(v2,v4) = 1;
                Arand(v3,v1) = 1;
                Arand(v4,v2) = 1;

                nrew = nrew + 1;

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

            if (Arand(v1,v3)==0)&&(Arand(v2,v4)==0);

                % the following line prevents appearance of isolated clusters of size 2
                %           if (k1(v1).*k1(v3)>1)&(k1(v2).*k1(v4)>1);

                Arand(v1,v2) = 0;
                Arand(v4,v3) = 0;
                Arand(v2,v1) = 0;
                Arand(v3,v4) = 0;

                Arand(v1,v3) = 1;
                Arand(v2,v4) = 1;
                Arand(v3,v1) = 1;
                Arand(v4,v2) = 1;

                nrew = nrew + 1;

                i1(e1) = v1;
                j1(e1) = v3;
                i1(e2) = v2;
                j1(e2) = v4;

                % the following line prevents appearance of isolated clusters of size 2
                %           end;

            end;
        end;
    end;
end;

return