function [R2] = gretna_rsquare(y,yhat)

%==========================================================================
% This function is used to calculate r square using data y and estimates
% yhat. Note: NaNs in either y or yhat are deleted from both sets.
%
%
% Syntax: function [R2] = gretna_rsquare(y,yhat)
%
% Inputs:
%       y:
%                   The original values (n*1 array).
%       yhat:
%                   The estimates calculated from y using a fit (n*1 array).
%
% Output:
%       R2:
%                   The r square value calculated using 1-SS_E/SS_T.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

if nargin ~= 2
    error('This function needs some exactly 2 input arguments!');
end

% delete NaNs
y(isnan(y) | isnan(yhat)) = [];
yhat(isnan(y) | isnan(yhat)) = [];

% 1 - SSe/SSt
R2 = 1 - ( sum( (y-yhat).^2 ) / sum( (y-mean(y)).^2 ) );

if R2<0 || R2>1
    error(['R^2 of ',num2str(R2),' : yhat does not appear to be the estimate of y from a fit.'])
end

return