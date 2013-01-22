function z = gretna_fishertrans(r)

%==========================================================================
% This function is used to perform fisher's r-to-z transformation.
%
%
% Syntax: function z = gretna_fishertrans(r)
%
% Input: 
%       r:
%         The correlation coefficients.
%
% Output: 
%       z:
%         The resultant zscores.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

z = 0.5*log((1+r)./(1-r));

return