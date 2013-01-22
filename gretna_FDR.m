function [pID,pN] = gretna_FDR(p,q)

%==========================================================================
% This function is used to correct multiple comparissons based on False
% Discovery Rate (FDR) procedure.
%
%
% Syntax: function [pID,pN] = gretna_FDR(p,q)
% 
% Inputs:
%        p:
%           Vector of p-values.
%        q:
%           False Discovery Rate level.
%
% Outputs:
%        pID:
%           P-value threshold based on independence or positive dependence
%           at FDR level of q.
%        pN:
%           Nonparametric p-value at FDR level of q.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

p = sort(p(:));
V = length(p);
I = (1:V)';

cVID = 1;
cVN = sum(1./(1:V));

pID = p(find(p<=I/V*q/cVID, 1, 'last' ));
pN  = p(find(p<=I/V*q/cVN,  1, 'last' ));

return

