function [R] = gretna_Pval2Corr(Pval, n, tail)

%==========================================================================
% This function is used to calculate the  correlation coefficient R
% corresponding to P value.
%
%
% Syntax: function [R] = gretna_Pval2Corr(Pval, n, tail)
%
% Inputs: 
%       Pval:
%          P value.
%       n: 
%          The sample size used to compute the R.
%       tail:
%          'right' for R > 0;
%          'left'  for R < 0;
%          'both'  for R ~= 0.
%
% Output:
%       R:
%          The resultant correlaion coefficient.
%
% Yong He,     NKLCNL, BNU, Beijing.
% Jinhui WANG, NKLCNL, BNU, Beijing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

df = n-2;

if strcmpi(tail, 'right')
    t = tinv(1 - Pval,df);
elseif strcmpi(tail, 'left')
    t = tinv(Pval,df);
else
    t = abs(tinv(Pval./2,df));
end

R = t./sqrt((t.^2 + df));

return