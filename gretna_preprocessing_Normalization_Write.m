function gretna_preprocessing_Normalization_Write(Data_path, File_filter, Mat_path, File_filter_mat, Para)

%==========================================================================
% This function is used to apply transformation matrix to images. NOTE, the
% resultant iamges will be started with prefix 'nor_'.
%
%
% Syntax: function gretna_preprocessing_Normalization_Write(Data_path, File_filter, Mat_path, File_filter_mat, Para)
%
% Inputs:
%       Data_path:
%                   The directory & filename of a .txt file that contains
%                   the directory of those files to be processed (can be
%                   obtained by gretna_gen_data_path.m).
%       File_filter:
%                   The prefix of those files to be processed.
%       Mat_path:
%                   The directory & filename of a .txt file that contains
%                   the directory of those transformation matrices (can be
%                   obtained by gretna_gen_data_path.m).
%       File_filter_mat:
%                   The prefix of those transformation matrices.
%       Para (optional):
%                   Para.Normalization.VoxSize
%                        Voxel size (e.g., [3 3 3]).
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

if nargin == 4
    Para.Normalization.VoxSize = spm_input('Voxel Size',1,'e',[],3)';
end
close

load gretna_Normalization_write
matlabbatch{1}.spm.spatial.normalise.write.roptions.vox =  Para.Normalization.VoxSize;

fid = fopen(Data_path);
Dir_data = textscan(fid, '%s');
fclose(fid);

Num_subs = size(Dir_data{1},1);

fid = fopen(Mat_path);
Dir_mat = textscan(fid, '%s');
fclose(fid);

for i = 1:Num_subs
    
    fprintf('Writing spatial transformation for %s\n', [Dir_data{1}{i}]);
    
    batch_nor = matlabbatch;
    
    % update the transform matrix
    cd (Dir_mat{1}{i})
    mat = spm_select('List',pwd, ['^' File_filter_mat  '.*\.mat$']);
    batch_nor{1}.spm.spatial.normalise.write.subj.matname = {[pwd filesep mat]};
    
    % update images to be transformed
    cd([Dir_data{1}{i}])
    imgs = spm_select('List',pwd, ['^' File_filter  '.*\.img$']);
    if isempty(imgs)
        imgs = spm_select('List',pwd, ['^' File_filter  '.*\.nii$']);
    end
    
    Num_imgs = size(imgs,1);
    datacell = cell(Num_imgs,1);
    for j = 1:Num_imgs
        datacell{j,1} = [pwd filesep imgs(j,:)];
    end
    batch_nor{1}.spm.spatial.normalise.write.subj.resample = datacell;
    
    spm_jobman('run',batch_nor)
    
    fprintf('Writing spatial transformation for %s ...... is done\n', [Dir_data{1}{i}]);
    
end

return