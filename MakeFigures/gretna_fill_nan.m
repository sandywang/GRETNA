function [Fdata] = gretna_fill_nan(Data)

%==========================================================================
% This function is used to reorganize data format for the convenience of
% subsequent figure plot. Users can ignore this function.
%
%
% Syntax: function [Fdata] = gretna_fill_nan(Data).
%
% Input:
%       Data:
%            1*N cell with each element being a M*C data array (N, the
%            number of groups; M, the number of subjects; C, the number of
%            variables). NOTE, M can vary but C MUST be equal across groups. 
%
% Output:
%     Fdata:
%            The reorganized data.
%
%       [Fdata] = gretna_fill_nan({data1,data2})
%
% Hao WANG, CCBD, HZNU, Hangzhou, 2015/12/03, hall.wong@outlook.com
% =========================================================================

if iscell(Data) == 0
    error('The inputted Data must be a 1×N cell, please check it!'); end

[~,Numgroup] = size(Data);
[~,Numcol] = size(Data{1,1});
Numrow = zeros(Numgroup,1);

for i = 1:Numgroup
    [Numrow(i,1),~] = size(Data{1,i});
end

for i = 1:Numgroup
    Data{1,i}(Numrow(i) + 1:max(Numrow)+1,:) = nan;
    Fdata(:,i:Numgroup:Numgroup*Numcol) = Data{1,i}(1:end-1,:);
end

return