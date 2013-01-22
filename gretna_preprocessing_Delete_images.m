function gretna_preprocessing_Delete_images(Data_path, File_filter, Para)

%==========================================================================
% This function is used to delete the first N EPI iamges to allow for the T1
% saturatin effect.
%
%
% Syntax: function gretna_preprocessing_Delete_images(Data_path, File_filter, Para)
%
% Inputs:
%       Data_path:
%                   The directory & filename of a .txt file that contains
%                   the directory of those files to be processed (can be
%                   obtained by gretna_gen_data_path.m).
%       File_filter:
%                   The prefix of those files to be processed.
%       Para (optional):
%                   Para.DeleteImage.N:
%                           The number of images to be deleted.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

if nargin == 2
    Para.DeleteImage.N = spm_input('# of images to delete',[],'e',[],1);
end

fid = fopen(Data_path);
Dir_data = textscan(fid, '%s');
fclose(fid);

Num_subs = size(Dir_data{1},1);

for i = 1:Num_subs
    
    fprintf('Deleting images for %s\n', [Dir_data{1}{i}]);
    
    cd ([Dir_data{1}{i}])
    images = spm_select('List',pwd, ['^' File_filter  '.*\.img$']);
    if ~isempty(images)
        for j = 1:Para.DeleteImage.N
            delete([images(j,1:end-4) '.img'])
            delete([images(j,1:end-4) '.hdr'])
        end
    else
        images = spm_select('List',pwd, ['^' File_filter  '.*\.nii$']);
        for j = 1:Para.DeleteImage.N
            delete(images(j,:))
        end
    end
    
    fprintf('Deleting images for %s ...... is done\n', [Dir_data{1}{i}]);
    
end

return