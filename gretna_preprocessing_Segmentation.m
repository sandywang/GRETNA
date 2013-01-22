function gretna_preprocessing_Segmentation(Data_path, File_filter, Para)

%==========================================================================
% This function is used to perform segmentation of anatomical images.
%
%
% Syntax: function gretna_preprocessing_Segmentation(Data_path, File_filter, Para)
%
% Inputs:
%       Data_path:
%                   The directory & filename of a .txt file that contains
%                   the directory of those files to be processed (can be
%                   obtained by gretna_gen_data_path.m).
%       File_filter:
%                   The prefix of those files to be processed.
%       Para (unused):
%                   The unused argument is reserved for consistency.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

fid = fopen(Data_path);
Dir_data = textscan(fid, '%s');
fclose(fid);

Num_subs = size(Dir_data{1},1);

spm_dir = which('spm');
if isempty(spm_dir)
    error('cant find spm function in matlab search path, please ensutre it!!')
end
[pathstr, ~, ~] = fileparts(spm_dir);

GM_dir = [pathstr '\tpm\grey.nii'];
WM_dir = [pathstr '\tpm\white.nii'];
CSF_dir = [pathstr '\tpm\csf.nii'];

load gretna_Segmentation.mat

% update gm, wm, and csf probability files
matlabbatch{1}.spm.spatial.preproc.opts.tpm{1} = GM_dir;
matlabbatch{1}.spm.spatial.preproc.opts.tpm{2} = WM_dir;
matlabbatch{1}.spm.spatial.preproc.opts.tpm{3} = CSF_dir;

for i = 1:Num_subs
    
    fprintf('Performing segmentation for %s\n', [Dir_data{1}{i}]);
    
    batch_seg = matlabbatch;
    
    cd (Dir_data{1}{i})
    sour = spm_select('List',pwd, ['^' File_filter '.*\.nii$']);
    if isempty(sour)
        sour = spm_select('List',pwd, ['^' File_filter '.*\.img$']);
    end
    
    % update source images to be segmented
    batch_seg{1}.spm.spatial.preproc.data = {[pwd '\' sour]};
    
    spm_jobman('run',batch_seg)
    
    fprintf('Performing segmentation for %s ...... is done\n', [Dir_data{1}{i}]);
    
end

return