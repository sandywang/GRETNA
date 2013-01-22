function gretna_global_signal(Data_path, File_filter, Mask_path)

%==========================================================================
% This funciton is used to calculate global signal of a brain volume.
%
%
% Syntax: gretna_global_signal(Data_path, File_Filter, Mask_Path)
%
% Inputs:
%       Data_path:
%                   The directory & filename of a .txt file that contains
%                   the directory of those files to be processed (can be
%                   obtained by gretna_gen_data_path.m).
%       File_filter:
%                   The prefix of those files to be processed (e.g., 'w').
%       Mask_path:
%                   The directory & filename of a brain mask within which
%                   the global signal is calculated.

% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

Maskinfo = spm_vol(Mask_path);
[Ymask, ~] = spm_read_vols(Maskinfo);
Ymask(isnan(Ymask)) = 0;
Ymask(Ymask ~= 0) = 1;

index = find(Ymask);
[I J K] = ind2sub(size(Ymask), index);
clear index

fid = fopen(Data_path);
Dir_data = textscan(fid, '%s');
fclose(fid);

Num_sub = size(Dir_data{1},1);

for sub = 1:Num_sub
    
    fprintf('Extracting time series for %s\n', [Dir_data{1}{sub}]);
    
    [~, name, ~] = fileparts(Dir_data{1}{sub});
    cd (Dir_data{1}{sub})
    File_name = spm_select('List',pwd, ['^' File_filter '.*\.img$']);
    if isempty(File_name)
        File_name = spm_select('List',pwd, ['^' File_filter '.*\.nii$']);
    end
    
    V = spm_vol(File_name);
    
    TC = spm_get_data(V,[I J K]');
    GS = mean(TC,2);
    
    save(['GloSig_' name '.txt'], 'GS', '-ascii')
    
    fprintf('Extracting time series for %s ...... is done\n', [Dir_data{1}{sub}]);
end

return