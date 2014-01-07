function gretna_gen_mask(Data_path, File_filter, Output_path, Output_filename)

%==========================================================================
% This function is used to generate a data-based EPI mask based on two
% criteria: 1) non-zero deviation over time; and 2) intensity > (global mean)/8.
% NOTE, this is usually performed after all individual images have be
% normalized into a common standard space.
%
%
% Syntax: function gretna_gen_mask(Data_path, File_filter, Output_path, Output_filename)
%
% Inputs:
%       Data_path:
%                   The directory & filename of a .txt file that contains
%                   the directories of those files to be processed (can be
%                   obtained by gretna_gen_data_path.m).
%       File_filter:
%                   The prefix of those files to be processed.
%       Output_path:
%                   The directory where the generated mask will be sorted.
%       Output_filename:
%                   The filename of the generated mask.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2012/08/15, Jinhui.Wang.1982@gmail.com
%==========================================================================

fid = fopen(Data_path);
Dir_data = textscan(fid, '%s');
fclose(fid);

Num_subs = size(Dir_data{1},1);

for i = 1:Num_subs
    cd (Dir_data{1}{i})
    File_name = spm_select('List',pwd, ['^' File_filter '.*\.img$']);
    if isempty(File_name)
        File_name = spm_select('List',pwd, ['^' File_filter '.*\.nii$']);
    end
    
    Vdata = spm_vol(File_name);
    Timepoints = size(Vdata,1);
    Rows = Vdata(1).dim(1); Columns= Vdata(1).dim(2); Slices = Vdata(1).dim(3);
    
    % criterion 1
    Mask1 = zeros(Vdata(1).dim(1:3));
    for k = 1:Slices
        SliceData = zeros(Rows,Columns,Timepoints);
        for t = 1:Timepoints
            SliceData(:,:,t) = spm_slice_vol(Vdata(t),spm_matrix([0 0 k]),[Rows Columns],0);
        end
        Mask1(:,:,k) = std(SliceData,0,3);
    end
    Mask1(logical(Mask1)) = 1;
    
    % criterion 2
    Mask2 = zeros(Vdata(1).dim(1:3));
    for t = 1:Timepoints
        [Ydata_t ~] = spm_read_vols(Vdata(t));
        m_Ydata_t = mean(Ydata_t(:));
        Ydata_t(Ydata_t <= m_Ydata_t/8) = 0;
        Ydata_t(logical(Ydata_t)) = 1;
        Mask2 = Ydata_t + Mask2;
    end
    Mask2 = Mask2/Timepoints;
    Mask2(Mask2 < 1) = 0;
    
    ind_Mask = Mask1 & Mask2;
    
    cd (Output_path)
    save (['Mask_sub' num2str(i) '.mat'], 'ind_Mask')
    
    ind_Vout = Vdata(1);
    ind_Vout.fname = ['Mask_sub' num2str(i) '.img'];
    ind_Vout = spm_write_vol(ind_Vout, ind_Mask);
    
    fprintf('%s done\n', [Dir_data{1}{i}]);
end

group_Mask = zeros(Vdata(1).dim);
cd (Output_path)

for i = 1:size(Dir_data{1},1)
    load (['Mask_sub' num2str(i) '.mat']);
    group_Mask = group_Mask + ind_Mask;
    delete (['Mask_sub' num2str(i) '.mat']);
end

group_Mask(group_Mask ~= Num_subs) = 0;
group_Mask(logical(group_Mask)) = 1;

group_Vout = Vdata(1);
group_Vout.fname = Output_filename;
group_Vout = spm_write_vol(group_Vout, group_Mask);

return
