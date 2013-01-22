function [stat] = gretna_glm(respmatrix, desnmatrix, type, k)

%==========================================================================
% This function is used to perform multiple linear regress analysis. For
% more info, see the matlab command 'regstats'.
%
%
% Syntax: function [stat] = gretna_glm(respmatrix, desnmatrix, type, k)
%
% Inputs:
%       respmatrix:
%                  A n*m array: n is the number of subjects (or time
%                  points); m is the number of vertices.
%       desnmatrix:
%                  A n*m array: n is the number of subjects (or time
%                  pointes); m is the number of covariates.
%       type:
%                  't': return the t-statistic and p-value;
%                  'r': return the residual.
%       k:
%                  if type = 't'; k: the kth statistical value, e.g. k=1.
%
% Output:
%       stat:
%                  The returned t/p or residual.
%
% Yong HE, BIC,MNI. 2007/06
%==========================================================================

n = size(respmatrix,1);
m = size(respmatrix,2);

if type == 't'
    for i = 1:m
        resp = respmatrix(:,i);
        s = regstats(resp,desnmatrix,'linear',{'tstat','r'});
        stat.t(i,1) = s.tstat.t(k+1);
        stat.p(i,1) = s.tstat.pval(k+1);
        stat.beta(i,1) = s.tstat.beta(k+1);
    end
    stat.df = s.tstat.dfe;
end

if type == 'r'
    for i = 1:m

        resp = respmatrix(:,i);
        s = regstats(resp,desnmatrix,'linear',{'r'});
        stat.r(:,i) = s.r;
    end
end

return