function gretna_preprocessing_Reslice(Data_path, File_filter, Para)

%==========================================================================
% This function is used to reslice images. NOTE, the resultant iamges will
% be started with prefix 'res_'.
%
%
% Syntax: function gretna_preprocessing_Reslice(Data_path, Filefilter, Para)
%
% Inputs:
%       Data_path:
%                   The directory & filename of a .txt file that contains
%                   the directory of those files to be processed (can be
%                   obtained by gretna_gen_data_path.m).
%       File_filter:
%                   The prefix of those files to be processed.
%       Para (optional):
%                   Para.Reslice_ReferenceImage:
%                        The reference image specifying the space to reslice.
%                   Para.Reslice_Interpolation:
%                        Interpolation methods--
%                        0--Nearest neighbour
%                        1--Trilinear
%                        2--2nd Degree B-Spline
%                        3--3nd Degree B-Spline
%                        4--4nd Degree B-Spline
%                        5--5nd Degree B-Spline
%                        6--6nd Degree B-Spline
%                        7--7nd Degree B-Spline.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

if nargin == 2
    Para.Reslice_ReferenceImage = spm_input('Reference Image',1,'s');
    Para.Reslice_Interpolation = spm_input('Interpolation',[],'e',[],1);
end
close

load gretna_Reslice.mat
matlabbatch{1}.spm.spatial.coreg.write.ref{1} = Para.Reslice_ReferenceImage;
matlabbatch{1}.spm.spatial.coreg.write.roptions.interp = Para.Reslice_Interpolation;

fid = fopen(Data_path);
Dir_data = textscan(fid, '%s');
fclose(fid);

Num_sub = size(Dir_data{1},1);

for i = 1:Num_sub
    
    fprintf('Performing reslice for %s\n', [Dir_data{1}{i}]);
    
    batch_res = matlabbatch;
    cd ([Dir_data{1}{i}])
    imgs = spm_select('List',pwd, ['^' File_filter  '.*\.img$']);
    if isempty(imgs)
        imgs = spm_select('List',pwd, ['^' File_filter  '.*\.nii$']);
    end
    
    Num_imgs = size(imgs,1);
    datacell = cell(Num_imgs,1);
    for j = 1:Num_imgs
        datacell{j,1} = [pwd '\' imgs(j,:)];
    end
    
    batch_res{1}.spm.spatial.coreg.write.source = datacell;
    
    spm_jobman('run',batch_res)
    
    fprintf('Performing reslice for %s ...... is done\n', [Dir_data{1}{i}]);
    
end

return