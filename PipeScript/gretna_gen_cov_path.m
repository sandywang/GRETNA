function gretna_gen_cov_path(Data_path, File_filter)

%==========================================================================
% This function is used to generate a .txt file that contains the
% directories & filenames of those variables that are typically treated as
% covariates in fMRI studies (e.g., head motion profiles, white matter
% signal etc.).
%
%
% Syntax: function gretna_gen_cov_path(Data_path, File_filter)
%
% Inputs: 
%       Data_path:
%                   The directory & filename of a .txt file that contains
%                   the directories where those covariates are sorted (can 
%                   be obtained by gretna_gen_data_path.m).
%       File_filter:
%                   The prefix of those covariates (e.g., {'wm','rp'}).
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

fid = fopen(Data_path);
Dir_data = textscan(fid, '%s');
fclose(fid);

Nsub = size(Dir_data{1},1);

[pathstr, ~, ~] = fileparts(Data_path);
cd (pathstr)
fid = fopen('covariate.txt','wt');

for i = 1:Nsub
    cd (Dir_data{1}{i});

    for num_cov = 1:length(File_filter)
        covname = ls([File_filter{num_cov} '*.txt']);
        fprintf(fid, '%s', [Dir_data{1}{i} filesep covname]);
        if num_cov ~= length(File_filter)
            fprintf(fid, '\n');
        end
    end

    if i ~= length(Dir_data{1})
        fprintf(fid, '\n');
    end
end

fclose(fid);

return