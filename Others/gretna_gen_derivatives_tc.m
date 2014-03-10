function gretna_gen_derivatives_tc(Data_path, File_filter, Output_prefix)

%==========================================================================
% This function is used to calculate the first derivatives (backward) of
% variables.
%
%
% Syntax: function gretna_gen_derivatives_tc(Data_path, File_filter, Output_prefix)
%
% Inputs:
%       Data_path:
%                   The directory & filename of a .txt file that contains
%                   the directory of those files to be processed (can be
%                   obtained by gretna_gen_data_path.m).
%       File_filter:
%                   The prefix of those files to be processed.
%       Output_prefix:
%                   The prefix of the resultant .txt files.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

fid = fopen(Data_path);
Dir_data = textscan(fid, '%s');
fclose(fid);

Nsubs = size(Dir_data{1},1);

for sub = 1:Nsubs
    
    cd (Dir_data{1}{sub})
    file = ls([File_filter '*.txt']);
    data = load(deblank(file));
    
    fprintf('Calculating derivatives of %s for %s\n', file, [Dir_data{1}{sub}]);
    
    backward_der = zeros(size(data));
    diff_data = diff(data);
    backward_der(2:end,:) = diff_data;
    
    save(deblank([Output_prefix '_' file]), 'backward_der', '-ascii')
    
    fprintf('Calculating derivatives of %s for %s ...... is done\n', file, [Dir_data{1}{sub}]);
    
end

return