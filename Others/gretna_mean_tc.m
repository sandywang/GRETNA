function [MTC] = gretna_mean_tc(Data_path, File_filter, Path_template, RoiIndex, Data_mask)

%==========================================================================
% This function is used to calculate the mean regional time course in ROIs.
%
%
% Syntax: function [MTC] = gretna_mean_tc(Data_path, File_filter, Path_template, RoiIndex, Data_mask)
%
% Inputs:
%       Data_path:
%                   The directory & filename of a .txt file that contains
%                   the directory of those files to be copied (can be
%                   obtained by gretna_gen_data_path.m).
%       File_filter:
%                   The prefix of those files to be processed.
%       Path_template:
%                   The directory & filename of brain template or atlas.
%       RoiIndex:
%                   The index of ROIs in the brain template or atlas (e.g.,
%                   [1:40 60:90]). Note that the order of extracted time
%                   course is the same as the order entered in RoiIndex.
%       Data_mask (optional):
%                   This argument is added for conditions where
%                   the data FOV is not enough to coverage the whole brain.
%                   That is, the data does not cover some of the ROIs.
%
% Output:
%       MTC:
%                   L (# of subjects)*1 cell array with each cell containing
%                   a N (# of time points) * M (# of ROIs) matrix.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

Vtem = spm_vol(Path_template);
[Ytem, ~] = spm_read_vols(Vtem);
Ytem(isnan(Ytem)) = 0;

if nargin == 5
    Vmask = spm_vol(Data_mask);
    [Ymask, ~] = spm_read_vols(Vmask);
    Ymask(logical(Ymask)) = 1;
    Ytem = Ytem.*Ymask;
end

MNI_coord = cell(length(RoiIndex),1);
for j = 1:length(RoiIndex)
    Region = RoiIndex(j);
    ind = find(Region == Ytem(:));
    
    if ~isempty(ind)
        [I,J,K] = ind2sub(size(Ytem),ind);
        XYZ = [I J K]';
        XYZ(4,:) = 1;
        MNI_coord{j,1} = XYZ;
    else
        error (['There are no voxels in ROI' blanks(1) num2str(RoiIndex(j)) ', please specify ROIs again']);
    end
end

fid = fopen(Data_path);
Dir_data = textscan(fid, '%s');
fclose(fid);

Num_subs = size(Dir_data{1},1);
MTC = cell(Num_subs,1);

for i = 1:Num_subs
    
    fprintf('Extracting time series for %s\n', Dir_data{1}{i});
    
    cd ([Dir_data{1}{i}])
    File_name = spm_select('List',pwd, ['^' File_filter '.*\.img$']);
    if isempty(File_name)
        File_name = spm_select('List',pwd, ['^' File_filter '.*\.nii$']);
    end
    
    Vin = spm_vol(File_name);
    Mean_tc = zeros(size(Vin,1),length(RoiIndex));
    
    for j = 1:length(RoiIndex)
            VY = spm_get_data(Vin,MNI_coord{j,1});
            Mean_tc(:,j) = mean(VY,2);
    end
    
    MTC{i,1} = Mean_tc;
    
    fprintf('Extracting time series for %s ...... is done\n', [Dir_data{1}{i}]);
    
end

return