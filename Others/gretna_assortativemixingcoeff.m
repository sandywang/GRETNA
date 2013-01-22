function [alpha sigma_r_square ] = gretna_assortativemixingcoeff(AIJ,bsigma)

% *************************************************************************
% calculate the assortative mixing coefficient of a given binariazed
% network Aij according to the reference below.
% [alpha sigma_r_square ] = gretna_assortativemixingcoeff(AIJ);
% input:    AIJ:   adjacency matrix
%           bsigma: if bsigma>=1; calcuating the sigma_r_square;
% output: 
%        alpha: assortative mixing coefficient. If alpha>0, the network
%        shows a assortative mixing feature, i.e a node with many
%        connections prefers to those with many connections, vice versa; if
%        alpha < 0, the network will show a disassortative mixing feature,
%        i.e. a node with many connections preferes to those with few
%        connections.(Newman 2002)
%
%        sigma_r_square:  the expected statistical
%        error on the value of r, so that we can evaluate the significance
%        of our results. One way to calculate this error is to use the
%        jackknife method. Regarding each of the L edges in a network
%        as an independent measurement of the contributions to the elements
%        of the matrix AIJ, we can show that the expected standard deviation
%        sr on the value of r satisfies (Newman 2003)
%  
% Yong HE, BIC, MNI, McGill
% 2006/09/01
%
% M. E. J. Newman, Phys. Rev. Lett. 89 208701 (2002).
% M. E. J. Newman, Phys. Rev. E 67 (2003) 026126.
% *************************************************************************
if nargin==1
    bsigma = 0;end
if nargin>2
    error('incorrect input parameters');end
    

AIJ = AIJ - diag(diag(AIJ));
[alpha] = assortcoeff (AIJ);
N = length(AIJ);
sigma_r_square = 0;

if bsigma>=1
    alpha_jn = [];
    for i = 1:N-1
        for j = (i+1):N
            if AIJ(i,j)==1
                BIJ = AIJ;
                BIJ(i,j) = 0;
                BIJ(j,i) = 0;
                alpha_jn = [alpha_jn assortcoeff(BIJ)];
            end
        end
    end
    sigma_r_square = sum((alpha_jn-alpha).^2);
end
return



function [alpha] = assortcoeff(AIJ);

[avedeg v_deg N] = fmri_degree(AIJ);
L = sum(sum(AIJ))/2;
A = [];
for i = 1:N-1
    for j = i+1:N
        if AIJ(i,j) ==1
            A = [A  v_deg(i)*v_deg(j)];
        end
    end
end
A = sum(A)/L;

B = [];
for i = 1:N-1
    for j = i+1:N
        if AIJ(i,j) ==1
            B = [B 0.5*(v_deg(i)+v_deg(j))];
        end
    end
end
B = (sum(B)/L).^2;



C = [];
for i = 1:N-1
    for j = i+1:N
        if AIJ(i,j) ==1
            C = [C  0.5*(v_deg(i)^2 + v_deg(j)^2)];
        end
    end
end
C = sum(C)/L;

if C==B
    alpha=0;
else
    alpha = (A - B)/(C-B);
end
 
return


function [ave_k v_k N] = fmri_degree(A)

N = length(A);
v_k = sum(A);
ave_k = sum(v_k)/N;
return
