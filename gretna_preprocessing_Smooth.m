function gretna_preprocessing_Smooth(Data_path, File_filter, Para)

%==========================================================================
% This function is used to perform spatial smoothing for images of multiple
% subjects. NOTE, the resultant iamges will be started with prefix 'smo_'.
%
%
% Syntax: function gretna_preprocessing_Smooth(Data_path, File_filter, Para)
%
% Inputs:
%       Data_path:
%                   The directory & filename of a .txt file that contains
%                   the directory of those files to be processed (can be
%                   obtained by gretna_gen_data_path.m).
%       File_filter:
%                   The prefix of those files to be processed.
%       Para (optional):
%                   Para.Smooth.FWHM:
%                        The full width half maximum of the Gaussian
%                        smoothing kernel (mm).
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/01/17, Jinhui.Wang.1982@gmail.com
%==========================================================================

if nargin == 2
    Para.Smooth.FWHM = spm_input('FWHM',[],'e',[],3)';
end
close

load gretna_Smooth.mat
matlabbatch{1}.spm.spatial.smooth.fwhm = Para.Smooth.FWHM;

fid = fopen(Data_path);
Dir_data = textscan(fid, '%s');
fclose(fid);

Num_subs = size(Dir_data{1},1);

for i = 1:Num_subs
    
    fprintf('Performing spatial smoothing for %s\n', [Dir_data{1}{i}]);
    
    batch_smo = matlabbatch;
    
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
    
    batch_smo{1}.spm.spatial.smooth.data = datacell;
    
    spm_jobman('run',batch_smo)
    
    fprintf('Performing spatial smoothing for %s ...... is done\n', [Dir_data{1}{i}]);
    
end

return