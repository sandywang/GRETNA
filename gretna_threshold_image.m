function gretna_threshold_image(Data_path, Thres)

%==========================================================================
% This function is used to threshold a image and generate a binary mask.
%
%
% Syntax: function gretna_threshold_image(Data_path, Thres)
%
% Inputs:
%       Data_path:
%                   The directory & filename of a image that will be 
%                   thresholded.
%       Thres:
%                   The threshold.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2012/08/17, Jinhui.Wang.1982@gmail.com
%==========================================================================

[pathstr, name, ext] = fileparts(Data_path);

cd (pathstr)

Vin = spm_vol([name ext]);
[Ydata, ~] = spm_read_vols(Vin);
Ydata(isnan(Ydata)) = 0;

Ydata(Ydata < Thres) = 0;
Ydata(logical(Ydata)) = 1;

Vout = Vin;
Vout.dt(1) = 16;
Vout.fname = [name '_thresholded_' num2str(Thres) ext];
Vout = spm_write_vol(Vout,Ydata);

return