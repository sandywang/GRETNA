function [FC_r FC_p] = gretna_fc_partial(TC)

%==========================================================================
% This function is used to calculate linear partical correlation among 
% multiple variables.
%
%
% Syntax: function [FC_r FC_p] = gretna_fc_partial(TC)
%
% Input:
%       TC:
%               Cell array with each cell representing a time series matrix
%               with rows being observations and columns being variables.
%
% Output:
%       FC_r:
%               The generated linear Partial correlation matrix.
%       FC_p:
%               The generated significance level of non-zero correlation for
%               each element in the Partial correlation matrix.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================
   
Num_Sub = length(TC);

FC_r = cell(Num_Sub,1);
FC_p = cell(Num_Sub,1);

for i = 1:Num_Sub
    [fc_r fc_p] = partialcorr(TC{i});
    
    fc_r = fc_r - diag(diag(fc_r));
    fc_p = fc_p - diag(diag(fc_p));
    
    FC_r{i,1} = fc_r;
    FC_p{i,1} = fc_p;
end

return