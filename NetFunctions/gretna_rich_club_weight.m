function phi = gretna_rich_club_weight(W)

%==========================================================================
% This function is used to calculate rich club metric for a weighted graph
% or network G.
%
%
% Syntax:  function [rc] = gretna_rich_club_weight(W)
%
% Input:
%        W:
%                The adjencent matrix of G.
%
% Outputs:
%        phi:
%                Rich club coefficient of G.
%                1 by N-1 Array: if k>k_max or k<k_min. rc(i)=NaN
%
% References:
% 1. Martijn P. van den Heuvel and Olaf Sporns (2011) Rich-Club Organization
%    of the Human Connectome. The Journal of Neuroscience, 31:15775�C15786.
%
% Jinhui WANG, CCBD, HZNU, HangZhou, 2013/04/25, Jinhui.Wang.1982@gmail.com
% Revised by Xindi Wang 20151231
%==========================================================================

W=W - diag(diag(W));
W=abs(W);
N=size(W, 1);
phi=nan(1, N-1);

Wvec = sort(W(logical(triu(W))),'descend');

Wbin = logical(W);
K  = sum(Wbin);
clear Wbin
kmin = max([1 min(K)]); kmax = max(K);

k = kmin:kmax-1;

for i = 1:length(k)
    ind = find(K <= k(i));
    
    net = W;
    net(ind,:) = [];
    net(:,ind) = [];
    
    if sum(net(:)) == 0, break, end
    
    index = find(triu(net));
    
    phi(1,k(i))  = sum(net(index))/sum(Wvec(1:length(index)));
end
