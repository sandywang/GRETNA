function gretna_mean_tc_cov(Data_path, File_filter_data, Pro_path, File_filter_pro, Pro_thr, Prefix)

%==========================================================================
% This function is used to generate mean wm/csf time course according to
% common wm/csf probability maps (e.g., provided in spm) or
% subject-specific wm/csf probability maps obtained by segmentation.
%
%
% Syntax: function gretna_mean_tc_cov(Data_path, File_filter_data, Pro_path, File_filter_pro, Pro_thr, Prefix)
%
% Inputs:
%       Data_path:
%                   The directory & filename of a .txt file that contains
%                   the directory of those files to be processed (can be
%                   obtained by gretna_gen_data_path.m).
%       File_filter_data:
%                   The prefix of those files to be processed.
%       Pro_path:
%                   The directory & filename of a .txt file that contains
%                   the directory of those probability maps (can be
%                   obtained by gretna_gen_data_path.m). If only one
%                   directory is included in the .txt file, then the
%                   probability map (prefixed by File_filter_pro) is used
%                   for all subjects. Otherwise, the number and order of
%                   directories should be the same as those included in
%                   Data_path.
%       File_filter_pro:
%                   The prefix of those probability maps.
%       Pro_thr:
%                   The probability threshold. Brain areas with values larger
%                   than the probability threshold are used to extract signals.
%       Prefix:
%                   The prefix of generated .txt files.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

fid = fopen(Data_path);
Dir_data = textscan(fid, '%s');
fclose(fid);
Num_subs = size(Dir_data{1},1);

fid = fopen(Pro_path);
Dir_pro = textscan(fid, '%s');
fclose(fid);
Num_pros = size(Dir_pro{1},1);

if Num_pros == 1
    
    fprintf('%s\n', 'A common image (probability map) is used to extract the mean tc for all subjects');
    
    cd (Dir_pro{1}{1})
    File_name_pro = spm_select('List',pwd, ['^' File_filter_pro '.*\.img$']);
    if isempty(File_name_pro)
        File_name_pro = spm_select('List',pwd, ['^' File_filter_pro '.*\.nii$']);
    end
    
    head_pro = spm_vol(File_name_pro);
    [Y_pro ~] = spm_read_vols(head_pro);
    Y_pro(Y_pro <= Pro_thr) = 0;
    Y_pro(Y_pro > 0) = 1;
    Index = find(Y_pro == 1);
    [I J K] = ind2sub(size(Y_pro), Index);
    
    for sub = 1:Num_subs
        
        fprintf('Extracting time series for %s\n', [Dir_data{1}{sub}]);
        
        [~, name, ~] = fileparts(Dir_data{1}{sub});
        cd (Dir_data{1}{sub})
        File_name_data = spm_select('List',pwd, ['^' File_filter_data '.*\.img$']);
        if isempty(File_name_data)
            File_name_data = spm_select('List',pwd, ['^' File_filter_data '.*\.nii$']);
        end
        
        V_data = spm_vol(File_name_data);
        TC_data = spm_get_data(V_data,[I J K]');
        m_TC_data = mean(TC_data,2);
        
        save([Prefix '_' name '.txt'], 'm_TC_data', '-ascii')
        
        fprintf('Extracting time series for %s ...... is done\n', [Dir_data{1}{sub}]);
        
    end
    
else
    
    fprintf('%s\n', 'Subject-specific images (probability maps)are used to extract the mean tc');
    
    for sub = 1:Num_subs
        
        fprintf('Extracting time series for %s\n', [Dir_data{1}{sub}]);
        
        cd (Dir_pro{1}{sub})
        File_name_pro = spm_select('List',pwd, ['^' File_filter_pro '.*\.img$']);
        if isempty(File_name_pro)
            File_name_pro = spm_select('List',pwd, ['^' File_filter_pro '.*\.nii$']);
        end
        
        head_pro = spm_vol(File_name_pro);
        [Y_pro ~] = spm_read_vols(head_pro);
        Y_pro(Y_pro <= Pro_thr) = 0;
        Y_pro(Y_pro > 0) = 1;
        Index = find(Y_pro == 1);
        [I J K] = ind2sub(size(Y_pro), Index);
        
        [~, name, ~] = fileparts(Dir_data{1}{sub});
        cd (Dir_data{1}{sub})
        
        File_name_data = spm_select('List',pwd, ['^' File_filter_data '.*\.img$']);
        if isempty(File_name_data)
            File_name_data = spm_select('List',pwd, ['^' File_filter_data '.*\.nii$']);
        end
        
        V_data = spm_vol(File_name_data);
        TC_data = spm_get_data(V_data,[I J K]');
        m_TC_data = mean(TC_data,2);
        
        save([Prefix '_' name '.txt'], 'm_TC_data', '-ascii')
        
        fprintf('Extracting time series for %s ...... is done\n', [Dir_data{1}{sub}]);
        
    end
end

return