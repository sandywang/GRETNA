function gretna_gen_std_image(Data_path, File_filter, Output_path, Output_filename)

%==========================================================================
% This function is used to calculate a std image over multiple images and
% multiple subjects.
%
%
% Syntax: function gretna_gen_std_image(Data_path, File_filter, Output_path, Output_filename)
%
% Inputs:
%       Data_path:
%                   The directory where those files to be processed are
%                   sorted.
%       File_filter:
%                   The prefix of those files to be processed.
%       Output_path:
%                   The directory where the generated image will be sorted.
%       Output_filename:
%                   The filename of the generated image.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2012/08/17, Jinhui.Wang.1982@gmail.com
%==========================================================================

cd (Data_path)

File_name = spm_select('List',pwd, ['^' File_filter '.*\.img$']);
if isempty(File_name)
    File_name = spm_select('List',pwd, ['^' File_filter '.*\.nii$']);
end

Vdata = spm_vol(File_name);

Timepoints = size(Vdata,1);
Rows = Vdata(1).dim(1); Columns= Vdata(1).dim(2); Slices = Vdata(1).dim(3);

Vout = Vdata(1);
Vout.dt(1) = 16;
Vout.fname = Output_filename;
Vout = spm_create_vol(Vout);

for k = 1:Slices
    
    SliceData = zeros(Rows,Columns,Timepoints);
    
    for t = 1:Timepoints
        SliceData(:,:,t) = spm_slice_vol(Vdata(t),spm_matrix([0 0 k]),[Rows Columns],0);
        
        stdSliceData = std(SliceData,0,3);
        Vout = spm_write_plane(Vout,stdSliceData,k);
    end
end

movefile([Data_path filesep Output_filename],Output_path)

return