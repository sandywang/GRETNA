function gretna_preprocessing_Realignment(Data_path, File_filter, Para)

%==========================================================================
% This function is used to perform realignment to correct inter-volume head
% motion for EPI images of multiple subjects. NOTE, the resultant iamges
% will be started with prefix 'rea_'.
%
%
% Syntax: function gretna_preprocessing_Realignment(Data_path, File_filter)
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
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/01/17, Jinhui.Wang.1982@gmail.com
%==========================================================================

load gretna_Realignment.mat

fid = fopen(Data_path);
Dir_data = textscan(fid, '%s');
fclose(fid);

Num_subs = size(Dir_data{1},1);

for i = 1:Num_subs
    
    fprintf('Performing realignment for %s\n', [Dir_data{1}{i}]);
    
    batch_rea = matlabbatch;
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
    batch_rea{1}.spm.spatial.realign.estwrite.data{1} = datacell;
    
    spm_jobman('run',batch_rea);
    
    fprintf('Performing realignment for %s ...... is done\n', [Dir_data{1}{i}]);
    
end

return