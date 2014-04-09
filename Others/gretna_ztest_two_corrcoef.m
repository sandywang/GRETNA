function [Zscore, Pvalue] = gretna_ztest_two_corrcoef(r1, r2, n1, n2, tail)

%==========================================================================
% This function is used to test the difference between two correlation
% coefficients.
%
%
% Syntax: function [Zscore, Pvalue] = gretna_ztest_two_corrcoef(r1, r2, n1, n2, type)
%
% Inputs:
%      r1:
%          The one correlation coefficient (or a matrix).
%      r2:
%          The other correlation coefficient (or a matrix).
%      n1:
%          The sample size used to calculate r1.
%      n2:
%          The sample size used to calculate r2.
%      tail:
%          'right' for r1 > r2;
%          'left'  for r1 < r2;
%          'both'  for r1 ~= r2.
%
% Outputs:
%      Zscore:
%          The test statistic.
%      Pvalue:
%          The significance level.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

zf1 = gretna_fishertrans(r1);
zf2 = gretna_fishertrans(r2);

Zscore = (zf1 - zf2)./(1./(n1 - 3) + 1./(n2 - 3)).^0.5;

% calculate p value
if strcmpi(tail, 'right')
    Pvalue = normcdf(-Zscore,0,1);
elseif strcmpi(tail, 'left')
    Pvalue = normcdf(Zscore,0,1);
else
    Pvalue = 2 .* normcdf(-abs(Zscore),0,1);
end

return