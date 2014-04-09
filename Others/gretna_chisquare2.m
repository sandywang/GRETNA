function [chi, p] = gretna_chisquare2(A)

%==========================================================================
% This function is used to perform a 2*2 chi-square test.
%
%
% Syntax: function [chi, p] = gretna_chisquare2(A)
%
% Input:
%          A:
%                2D matrix.
%
% Outputs:
%          chi:
%                X^2 value.
%          p:
%                Significance level.
%
% E.g., A = [156 704-156; 174 1252-174];
% [intra_inter_chi intra_inter_p] = fmri_chisquare2(A);
%
% He Yong,   BIC,    MNI, McGill, CA, 2006/01/22.
%==========================================================================

if nargin ~= 1
    error('error input parameters.');
end

r = size(A,1);
s = size(A,2);
df = (r-1)*(s-1);
chi = 0;

for i =1:r
    for j = 1:s
        chi = chi+A(i,j)^2/(sum(A(i,:))*sum(A(:,j)));
    end
end

chi = sum(sum(A))*(chi-1);
p = ( 1 - spm_Xcdf(chi,df));

return