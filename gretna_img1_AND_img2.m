function gretna_img1_AND_img2(Data_path1, Data_path2, Output_path, Output_filename)

%==========================================================================
% This function is used to perform logical AND of two images.
%
%
% Syntax: function gretna_img1_AND_img2(Data_path1, Data_path2)
%
% Inputs:
%       Data_path1:
%                   The directory % filename of one image.
%       Data_path2:
%                   The directory % filename of the other image.
%       Output_path:
%                   The directory where the generated mask will be sorted.
%       Output_filename:
%                   The filename of the generated mask.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2012/08/17, Jinhui.Wang.1982@gmail.com
%==========================================================================

[pathstr1, name1, ext1] = fileparts(Data_path1);
cd (pathstr1)
Vin1 = spm_vol([name1 ext1]);
[Ydata1, ~] = spm_read_vols(Vin1);
Ydata1(isnan(Ydata1)) = 0;

[pathstr2, name2, ext2] = fileparts(Data_path2);
cd (pathstr2)
Vin2 = spm_vol([name2 ext2]);
[Ydata2, ~] = spm_read_vols(Vin2);
Ydata2(isnan(Ydata2)) = 0;

cd (Output_path)
Yout = Ydata1 & Ydata2;
Vout = Vin1;
Vout.fname = Output_filename;
Vout = spm_write_vol(Vout,Yout);

return