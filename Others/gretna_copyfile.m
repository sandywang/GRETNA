function gretna_copyfile(Data_path, File_filter, Output_path)

%==========================================================================
% This function is used to copy files (with specific prefix) from different
% directories into a single directory. One case where this function is
% needed is that you perform a VBM analysis on some subjects and obtain
% individual GM volumes in the different directories. Copying these GM
% volume into a single directory is simple for the following statistical
% analysis.
%
%
% Syntax: function gretna_copyfile(Data_path, File_filter, Output_path)
%
% Inputs:
%       Data_path:
%                   The directory & filename of a .txt file that contains
%                   the directory of those files to be copied (can be
%                   obtained by gretna_gen_data_path.m).
%       File_filter:
%                   The prefix of those files to be copyed.
%       Output_path:
%                   The directory where the files will be sorted (e.g.,
%                   E:\Mydata\GrayMatter).
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

fid = fopen(Data_path);
Dir_data = textscan(fid, '%s');
fclose(fid);

Num_subs = size(Dir_data{1},1);

for i = 1:Num_subs
    
    fprintf('Copying files for %s\n', [Dir_data{1}{i}]);
    
    cd (Dir_data{1}{i})
    
    File_name = spm_select('List',pwd, ['^' File_filter]);
    
    if isempty(File_name)
        File_name = spm_select('List',pwd, ['^' File_filter]);
    end
    
    cd (Output_path)
    [~, name, ~] = fileparts(Dir_data{1}{i});
    
    for num_file = 1:size(File_name,1)
        copyfile([deblank(Dir_data{1}{i}) filesep deblank(File_name(num_file,:))], [Output_path filesep 'copy_' name '_' deblank(File_name(num_file,:))]);
    end
    
    fprintf('Copying files for %s ...... is done\n', [Dir_data{1}{i}]);
    
end

return