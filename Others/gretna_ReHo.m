function [RH] = gretna_ReHo(data)

%==========================================================================
% This function is used to calculate regional homogeneity (ReHo) of multiple
% variables as specified in 'data', where rows indicating ovservations and
% columns variables.
%
%
% Syntax: function [RH] = gretna_ReHo(data)
%
% Input:
%        data:
%                   m*n array with rows indicating ovservations and columns
%                   variables.
%
% Output:
%          RH:
%                   ReHo value.
%
% Jinhui WANG, CCBD, HNU, HangZhou, 2012/08/20, Jinhui.Wang.1982@gmail.com
%==========================================================================

[m n] = size(data);
[~, rank_data] = sort(data);
SR = sum(rank_data,2);
RH = 12*(sum(SR.^2) - m*((m+1)*n/2)^2)/(n^2*(m^3 - m));

return