function [Fdata] = gretna_fill_nan(Data)
%==========================================================================
% This function is used to fill nan for different  
%
%
% Syntax: function  gretna_fill_nan(Data)
%
% Inputs:
%       Data:
%           1 x N Cellarry with elements being numerical colums of M x C length
%           (N: categories or group; M: subjects or voxels; C: conditions or levels.
%            Note: The M maybe unequal, however, the C must be equal!). 
%
% Examples:
%       We have 2 groups (A and B), group A has 10 participants, group B has 20 participants.
%       each participant has undergone 4 experiments. our inputs should be {rand(10,4),rand(20,4)}).
%       
%       [Fdata] = gretna_fill_nan({rand(10,4),rand(20,4)})
%
% Hao WANG, CCBD, HZNU, Hangzhou, 2015/12/03, hall.wong@outlook.com
% =========================================================================

if iscell(Data) == 0;
    error('the data must be a 1¡ÁN cell, please check the illustration of the code in detail.')
end

[~,Numgroup] = size(Data);
[~,Numcol] = size(Data{1,1});
Numrow = zeros(Numgroup,1);

for i = 1:Numgroup
    [Numrow(i,1),~] = size(Data{1,i});
end

for i = 1:Numgroup
Data{1,i}(Numrow(i)+1:max(Numrow)+1,:) = nan;
Fdata(:,i:Numgroup:Numgroup*Numcol) = Data{1,i}(1:end-1,:);
end