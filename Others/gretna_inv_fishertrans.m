function r = gretna_inv_fishertrans(z)

%==========================================================================
% This function is used to perform fisher's r-to-z inverse transformation
% (i.e., z-to-r).
%
%
% Syntax: function r = gretna_inv_fishertrans(z)
%
% Input: 
%       z:
%         The zscores.
%
% Output: 
%       r:
%         The resultant correlation coefficients.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

r = (exp(2*z) - 1)./(exp(2*z) + 1);

return