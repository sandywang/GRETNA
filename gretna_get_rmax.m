function [Rmax Smin Kmin] = gretna_get_rmax (Rmatrix)

%==========================================================================
% This function is used to get the maximum correlation or minimum sparsity
% threshold that the small world properties of the resultant networks are
% estimable.
%
%
% Syntax: function [Rmax Smin Kmin] = gretna_get_rmax (N)
% 
% Input:
%           Rmatrix:
%                   The symmetric correlation matrix.
%
% Outputs:
%           Rmax: 
%                   The maximum correlation threshold to ensure small-world
%                   estimation.
%           Smin: 
%                   The minimum sparsity threshold to ensure small-world
%                   estimation.
%           Kmin: 
%                   The minimum edge threshold to ensure small-world
%                   estimation.
%
% Reference
% 1. Watts DJ, Strogatz SH (1998) Collective dynamics of 'small-world'
%    networks. Nature 393:440-442.
%
% Yong   HE,   BIC,    MNI, McGill,  2008/07/10            
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

Rmatrix = abs(Rmatrix);
Rmatrix = Rmatrix - diag(diag(Rmatrix));

N = length(Rmatrix);

Kmin = ceil(N*log(N)/2);
Smin = Kmin/(N*(N-1)/2);

tmp = sort(Rmatrix(:),'descend');
Rmax = tmp(2*Kmin);

return
