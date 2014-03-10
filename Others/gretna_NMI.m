function [NMI] = gretna_NMI(A, B)

%========================================================================== 
% This function is used to calculate normalized mutual information between
% two modular architectures. NOTE, the number of nodes should be equal
% between these two partitions.
%
%
% Syntax: function NMI = gretna_NMI(A, B)
%
% Inputs:
%        A:
%            The modular structure of a network
%            (e.g., A = {[1 2 3],[4 5 6]}).
%        B:
%            The modular structure of another network
%            (e.g., B = {[1 2],[3 4],[5 6]}).
%
% Output:
%        NMI:
%            The normalized mutual information between A and B.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

Ca = length(A);
Cb = length(B);

Na = zeros(Ca,1);
Nb = zeros(1,Cb);
overlap = zeros(Ca,Cb);

for i = 1:Ca
    Na(i,1) = length(A{i});
end

for i = 1:Cb
    Nb(1,i) = length(B{i});
end

N = sum(Na);

Tot_a = sum(Na.*log(Na./N));
Tot_b = sum(Nb.*log(Nb./N));

for i = 1:Ca
    for j = 1:Cb
        overlap(i,j) = length(intersect(A{i},B{j}));
    end
end

numerator = overlap.*log(overlap.*N./(Na*Nb));
numerator = -2*nansum(numerator(:));
denominator = Tot_a + Tot_b;

NMI = numerator/denominator;

return