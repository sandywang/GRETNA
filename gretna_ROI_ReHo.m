function [RH] = gretna_ROI_ReHo(Data_path, File_filter, Path_template, RoiIndex, Data_mask)

%==========================================================================
% This function is used to calculate regional homogeneity (ReHo) in a ROI
% manner.
%
%
% Syntax: function [RH] = gretna_ROI_ReHo(Data_path, File_filter, Path_template, RoiIndex, Data_mask)
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
%                   [1:40 60:90]). Note that the order of outputed ReHo
%                   values is the same as the order entered in RoiIndex.
%       Data_mask (optional):
%                   This argument is added for conditions where
%                   the data FOV is not enough to coverage the whole brain.
%                   That is, the data does not cover some of the ROIs.
%
% Output:
%          RH:
%                   L (# of subjects)*1 cell array with each cell containing
%                   N (# of ROIs)*1 ReHo values.
%
% Reference
% 1. Zang et al. (2004)£º Regional homogeneity approach to fMRI data
%    analysis. Neuroimage.
%
% Jinhui WANG, CCBD, HNU, HangZhou, 2012/08/20, Jinhui.Wang.1982@gmail.com
%==========================================================================

Ptem = spm_vol(Path_template);
[Y_tem, ~] = spm_read_vols(Ptem);

if nargin == 5
    Pmask = spm_vol(Data_mask);
    [Ymask, ~] = spm_read_vols(Pmask);
    Ymask(logical(Ymask)) = 1;
    Y_tem = Y_tem.*Ymask;
end

fid = fopen(Data_path);
Dir_data = textscan(fid, '%s');
fclose(fid);

Num_subs = size(Dir_data{1},1);
RH = cell(Num_subs,1);
Nroi = length(RoiIndex);

for i = 1:Num_subs
    
    fprintf('Calculating ReHo for %s\n', [Dir_data{1}{i}]);
    
    cd ([Dir_data{1}{i}])
    File_name = spm_select('List',pwd, ['^' File_filter '.*\.img$']);
    if isempty(File_name)
        File_name = spm_select('List',pwd, ['^' File_filter '.*\.nii$']);
    end
    
    V = spm_vol(File_name);
    
    for j = 1:Nroi
        reho = zeros(Nroi,1);
        Region = RoiIndex(j);
        ind = find(Region == Y_tem(:));
        if ~isempty(ind)
            [I,J,K] = ind2sub(size(Ymask),ind);
            XYZ = [I J K]';
            XYZ(4,:) = 1;
            VY = spm_get_data(V,XYZ);
            reho(j,1) = gretna_ReHo(VY);
        else
            error (['There are no voxels in ROI' blanks(1) num2str(RoiIndex(j)) ', please specify ROIs again']);
        end
    end
    
    RH{i,1} = reho;
    
    fprintf('Calculating ReHo for %s ...... is done\n', [Dir_data{1}{i}]);
end

return