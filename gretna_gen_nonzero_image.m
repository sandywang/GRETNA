function gretna_gen_nonzero_image(Data_path, File_filter)

%==========================================================================
% This function is used to calculate a binary mask where all images have 
% nonzero values.
%
%
% Syntax: function gretna_gen_nonzero_image(Data_path, File_filter)
%
% Inputs:
%       Data_path:
%                   The directory where those files to be processed are 
%                   sorted.
%       File_filter:
%                   The prefix of those files to be processed.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2012/08/17, Jinhui.Wang.1982@gmail.com
%==========================================================================

cd (Data_path)

File_name = spm_select('List',pwd, ['^' File_filter '.*\.img$']);
if isempty(File_name)
    File_name = spm_select('List',pwd, ['^' File_filter '.*\.nii$']);
end

Vin = spm_vol(File_name);

msk = zeros(Vin(1).dim);

for i = 1:size(Vin,1)
    [Ydata ~] = spm_read_vols(Vin(i));
    Ydata(isnan(Ydata)) = 0;
    Ydata(logical(Ydata)) = 1;
    msk = msk + Ydata;
end

msk = msk./size(Vin,1);
msk(msk < 1) = 0;

vout = Vin(1);
vout.fname = 'nonzero_image_allsubjects.nii';
vout = spm_write_vol(vout,msk);

return