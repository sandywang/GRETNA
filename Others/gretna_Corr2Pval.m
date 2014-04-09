function [Pval] = gretna_Corr2Pval(R, n, tail)

%==========================================================================
% This function is used to calculate the P value corresponding to
% correlation coefficient R.
%
%
% Syntax: function [Pval] = gretna_Corr2Pval(R,n)
%
% Inputs:
%       R:
%          Correlaion coefficient.
%       n:
%          The sample size used to compute the R.
%       tail:
%          'right' for R > 0;
%          'left'  for R < 0;
%          'both'  for R ~= 0.
% Output:
%       Pval:
%          The resultant P value.
%
% Yong He,     NKLCNL, BNU, Beijing.
% Jinhui WANG, NKLCNL, BNU, Beijing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

t = (R.*sqrt(n-2))./(sqrt(1-R.^2));
Tscore = abs(t); df = n-2;

% calculate p value
if strcmpi(tail, 'right')
    Pval = tcdf(-Tscore,df);
elseif strcmpi(tail, 'left')
    Pval = tcdf(Tscore,df);
elseif strcmpi(tail, 'both')
    Pval = 2 .* tcdf(-abs(Tscore),df);
else
    error('Wrong input for the third argument')
end

return