function gretna_gen_mean_image(Data_path, File_filter, Output_path, Output_filename)

%==========================================================================
% This function is used to calculate a mean image over multiple images.
%
%
% Syntax: function gretna_gen_mean_image(Data_path, File_filter, Output_path, Output_filename)
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
Ydata = zeros(Vdata(1).dim);

for i = 1:size(File_name,1)
    [Ytmp, ~] = spm_read_vols(Vdata(i));
    Ydata = Ydata + Ytmp;
end

mYdata = Ydata./size(Vdata,1);

Vout = Vdata(1);
Vout.dt(1) = 16;
Vout.fname = Output_filename;
cd (Output_path)
Vout = spm_write_vol(Vout,mYdata);

return