function gretna_preprocessing_Normalization(Data_path, File_filter, Para)

%==========================================================================
% This function is used to normalize inidividual EPI images into standard
% MNI space. NOTE, the resultant iamges will be started with prefix 'nor_'.
%
%
% Syntax: function gretna_preprocessing_Normalization(Data_path, File_filter, Para)
%
% Inputs:
%       Data_path:
%                   The directory & filename of a .txt file that contains
%                   the directory of those files to be processed (can be
%                   obtained by gretna_gen_data_path.m).
%       File_filter:
%                   The prefix of those files to be processed.
%       Para (optional):
%                   Para.Normalization.Type:
%                        EPI or T1.
%                   Para.Normalization.VoxSize:
%                        Voxel size (e.g., [3 3 3]).
%                   Para.Normalization.T1_path:
%                        The directory & filename of a .txt file that contains
%                        the directory of anatomical files corresponding to
%                        EPI images (can be otained by gretna_gen_data_path.m).
%                        Of note, the subject order in the T1_path .txt file
%                        shoule be the same as Data_path.
%                   Para.Normalization.T1_File_filter:
%                        The prefix of those anatomical files.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

if nargin == 2
    Para.Normalization.Type = spm_input('Normalize type',1,'with EPI|with T1');
    Para.Normalization.VoxSize = spm_input('Voxel Size',2,'e',[],3)';
    
    if strcmp(Para.Normalization.Type, 'with T1')
        Para.Normalization.T1_path = spm_input('Enter Path of T1 (***\.txt)',3,'s');
        Para.Normalization.T1_File_filter = spm_input('Enter prefix of T1 images',4,'s');
    end
end
close

fid = fopen(Data_path);
Dir_data = textscan(fid, '%s');
fclose(fid);

Num_subs = size(Dir_data{1},1);

switch Para.Normalization.Type
    case 'with EPI'
        load gretna_Normalization_EPI
        if exist('spm','file') == 2
            spm_dir = which('spm');
            [pathstr, ~, ~] = fileparts(spm_dir);
            EPI_dir = [pathstr '\templates\EPI.nii'];
        else
            error('cant find spm function in matlab search path!!')
        end
        
        % update the template
        matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.template = {[EPI_dir ',1']};
        
        for i = 1:Num_subs
            
            fprintf('Performing spatial normalization for %s\n', [Dir_data{1}{i}]);
            
            batch_nor = matlabbatch;
            
            % update the source image
            cd ([Dir_data{1}{i}])
            sour = spm_select('List',pwd, ['^mean' '.*\.img$']);
            if isempty(sour)
                sour = spm_select('List',pwd, ['^mean' '.*\.nii$']);
            end
            batch_nor{1}.spm.spatial.normalise.estwrite.subj.source = {[pwd filesep sour]};
            
            % update the data for normalization
            imgs = spm_select('List',pwd, ['^' File_filter  '.*\.img$']);
            if isempty(imgs)
                imgs = spm_select('List',pwd, ['^' File_filter  '.*\.nii$']);
            end
            
            Num_imgs = size(imgs,1);
            datacell = cell(Num_imgs,1);
            for j = 1:Num_imgs
                datacell{j,1} = [pwd filesep imgs(j,:)];
            end
            batch_nor{1}.spm.spatial.normalise.estwrite.subj.resample = datacell;
            
            spm_jobman('run',batch_nor)
            
            fprintf('Performing spatial normalization for %s ...... is done\n', [Dir_data{1}{i}]);
            
        end
        
    otherwise
        % coregister between T1 and mean functional image generated from realignmemt
        gretna_preprocessing_Coregister(Data_path, 'mean', Para.Normalization.T1_path, Para.Normalization.T1_File_filter)
        
        % segmentation of coregistered T1 images
        gretna_preprocessing_Segmentation(Para.Normalization.T1_path, Para.Normalization.T1_File_filter, Para)
        
        % wirte resultant transformation to images
        gretna_preprocessing_Normalization_Write(Data_path, File_filter, Para.Normalization.T1_path, '*seg_sn', Para)
end

return