function gretna_preprocessing_Coregister(Data_path_ref, File_filter_ref, Data_path_sour, File_filter_sour)

%==========================================================================
% This function is used to perform  inter-modality coregister (only estimate)
% of within-subjects. NOTE, the default objective function is set as
% normalized mutual information.
%
%
% Syntax: function gretna_preprocessing_Coregister(Data_path_ref, File_filter_ref, Data_path_source, File_filter_source)
%
% Inputs:
%         Data_path_ref:
%                   The directory & filename of a .txt file that contains
%                   the directory of those reference files (can be
%                   obtained by gretna_gen_data_path.m).
%         File_filter_ref:
%                   The prefix of those reference files.
%         Data_path_sour:
%                   The directory & filename of a .txt file that contains
%                   the directory of those source files (can be
%                   obtained by gretna_gen_data_path.m).
%         File_filter_sour:
%                   The prefix of those source files.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

load gretna_Coregister

fid = fopen(Data_path_ref);
Dir_data_ref = textscan(fid, '%s');
fclose(fid);

fid = fopen(Data_path_sour);
Dir_data_sour = textscan(fid, '%s');
fclose(fid);

if size(Dir_data_ref{1},1) ~= size(Dir_data_sour{1},1)
    error('The numbers of subjects differ between modalities!!')
end

Num_subs  = size(Dir_data_ref{1},1);

for i = 1:Num_subs
    
    fprintf('Performing inter-modality coregister for %s\n', [Dir_data_ref{1}{i}]);
    
    batch_cor = matlabbatch;
    
    % updata individual reference image
    cd ([Dir_data_ref{1}{i}])
    ref = spm_select('List',pwd, ['^' File_filter_ref '.*\.img$']);
    if isempty(ref)
        ref = spm_select('List',pwd, ['^' File_filter_ref '.*\.nii$']);
    end
    
    if size(ref,1) == 1
        batch_cor{1}.spm.spatial.coreg.estimate.ref = {[pwd '\' ref]};
    else
        error(['There are no or multiple reference images srarted with' blanks(1) '''' File_filter_ref '''' blanks(1) 'in the' blanks(1) num2str(i) 'th subject''s file, please check it']);
    end
    
    % update individual source image
    cd (Dir_data_sour{1}{i})
    sour = spm_select('List',pwd, ['^' File_filter_sour '.*\.nii$']);
    if isempty(sour)
        sour = spm_select('List',pwd, ['^' File_filter_sour '.*\.img$']);
    end
    
    if size(sour,1) == 1
        batch_cor{1}.spm.spatial.coreg.estimate.source = {[pwd '\' sour]};
    else
        error(['There are no or multiple images srarted with' blanks(1) '''' File_filter_sour '''' blanks(1) 'in the' blanks(1) num2str(i) 'th subject''s file, please check it']);
    end
    
    spm_jobman('run',batch_cor)
    
    fprintf('Performing inter-modality coregister for %s ...... is done\n', [Dir_data_ref{1}{i}]);
    
end

return