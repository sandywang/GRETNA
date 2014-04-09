function gretna_voxel_based_degree_pipeuse(Data_List, Output_path, Data_mask, R_thr, Dis, name)

%==========================================================================
% This function is used to calculate nodal degree for each voxel in the
% brain. (for GUI pipeline)
%
% Syntax: function gretna_voxel_based_degree(Data_List, Output_path, File_filter, Data_mask)
%
% Inputs:
%   Data_List:
%   The cell that contains those files to be processed
%
%   Output_path:
%   The directory where the results will be sorted.
%
%   Data_mask:
%   The directory & filename of a brain mask that is used
%   to determine which voxels will be calculated. In general,
%   the brainmask_bin_xxx.nii can be used as in
%   ...\gretna\templates.
%   R_thr:
%   Positive value of R-threshold used to rule out low
%   spurious correlations.
%   Dis (mm):
%   Distance threshold used to classify long vs. short
%   connections.
%
% Outputs:
%
%   pos_xxx_long.nii/hdr:
%   Positive long degree,  i.e., R > R_thr (> Dis);
%   pos_xxx_short.nii/hdr:
%   Positive short degree, i.e., R > R_thr (< Dis);
%   pos_xxx.nii/hdr:
%   Positive degree,   i.e., R > R_thr;
%   neg_xxx_long.nii/hdr:
%   Negative long degree,  i.e., R < -R_thr (> Dis);
%   neg_xxx_short.nii/hdr:
%   Negative short degree, i.e., R < -R_thr (< Dis);
%   neg_xxx.nii/hdr:
%   Negative degree,   i.e., R < -R_thr;
%   abs_xxx_long.nii/hdr:
%   Absolute long degree,  i.e., |R| < -R_thr (> Dis);
%   abs_xxx_short.nii/hdr:
%   Absolute short degree, i.e., |R| < -R_thr (< Dis);
%   abs_xxx.nii/hdr:
%   Absolute degree,   i.e., |R| > R_thr;
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

if ~strcmpi(Output_path(end),filesep)
    Output_path=[Output_path, filesep];
end

if exist(Output_path, 'dir')~=7
    mkdir(Output_path);
end

Vmask = spm_vol(Data_mask);
[Ymask, XYZ] = spm_read_vols(Vmask);
Ymask(isnan(Ymask)) = 0;

Index = find(Ymask);
XYZ = XYZ(:,Index)';
[I J K] = ind2sub(size(Ymask),Index);

Vin = spm_vol(Data_List);
Ydata = spm_get_data(Vin,[I J K]');

numSample = size(Ydata,1);
Ydata = Ydata - repmat(mean(Ydata), numSample, 1);
Ydata = Ydata./repmat(std(Ydata, 0, 1), numSample, 1);

R_pos_bin = zeros(size(Ymask));
R_pos_bin_long = zeros(size(Ymask));
R_pos_bin_short = zeros(size(Ymask));

R_pos_wei = zeros(size(Ymask));
R_pos_wei_long = zeros(size(Ymask));
R_pos_wei_short = zeros(size(Ymask));

R_abs_bin = zeros(size(Ymask));
R_abs_bin_long = zeros(size(Ymask));
R_abs_bin_short = zeros(size(Ymask));

R_abs_wei = zeros(size(Ymask));
R_abs_wei_long = zeros(size(Ymask));
R_abs_wei_short = zeros(size(Ymask));

if Dis==0
    for ii = 1:length(Index)
        r = Ydata(:,ii)' * Ydata / (numSample - 1);

        tmp = find(r >= R_thr);
        R_pos_bin(Index(ii))   = length(tmp) - 1;
        R_pos_wei(Index(ii))   = sum(r(tmp)) - 1;

        tmp = find(abs(r) >= R_thr);
        R_abs_bin(Index(ii))   = length(tmp) - 1;
        R_abs_wei(Index(ii))   = sum(abs(r(tmp))) - 1;
    end
else
    for ii = 1:length(Index)
        D = gretna_pdist2(XYZ(ii,:),XYZ);

        r = Ydata(:,ii)' * Ydata / (numSample - 1);

        tmp = find(r >= R_thr);
        R_pos_bin(Index(ii))   = length(tmp) - 1;
        R_pos_bin_long(Index(ii))  = length(find(D(tmp) >= Dis));
        R_pos_bin_short(Index(ii)) = length(find(D(tmp) < Dis)) - 1;
        R_pos_wei(Index(ii))   = sum(r(tmp)) - 1;
        R_pos_wei_long(Index(ii))  = sum(r(tmp(D(tmp) >= Dis)));
        R_pos_wei_short(Index(ii)) = sum(r(tmp(D(tmp) < Dis))) - 1;

        tmp = find(abs(r) >= R_thr);
        R_abs_bin(Index(ii))   = length(tmp) - 1;
        R_abs_bin_long(Index(ii))  = length(find(D(tmp) >= Dis));
        R_abs_bin_short(Index(ii)) = length(find(D(tmp) < Dis)) - 1;
        R_abs_wei(Index(ii))   = sum(abs(r(tmp))) - 1;
        R_abs_wei_long(Index(ii))  = sum(abs(r(tmp(D(tmp) >= Dis))));
        R_abs_wei_short(Index(ii)) = sum(abs(r(tmp(D(tmp) < Dis)))) - 1;
    end
end
    
R_neg_bin   = R_abs_bin - R_pos_bin;
if Dis>0
    R_neg_bin_long  = R_abs_bin_long - R_pos_bin_long;
    R_neg_bin_short = R_abs_bin_short - R_pos_bin_short;
end

R_neg_wei   = R_abs_wei - R_pos_wei;
if Dis>0
    R_neg_wei_long  = R_abs_wei_long - R_pos_wei_long;
    R_neg_wei_short = R_abs_wei_short - R_pos_wei_short;
end

Vout = Vin{1};
Vout.dt(1) = 16;

Vout.fname = [Output_path 'degree_pos_bin_' name '.nii'];
Vout = spm_write_vol(Vout, R_pos_bin);
if Dis>0
    Vout.fname = [Output_path 'degree_pos_bin_long_' name '.nii'];
    Vout = spm_write_vol(Vout, R_pos_bin_long);
    Vout.fname = [Output_path 'degree_pos_bin_short_' name '.nii'];
    Vout = spm_write_vol(Vout, R_pos_bin_short);
end

Vout.fname = [Output_path 'degree_pos_wei_' name '.nii'];
Vout = spm_write_vol(Vout, R_pos_wei);
if Dis>0
    Vout.fname = [Output_path 'degree_pos_wei_long_' name '.nii'];
    Vout = spm_write_vol(Vout, R_pos_wei_long);
    Vout.fname = [Output_path 'degree_pos_wei_short_' name '.nii'];
    Vout = spm_write_vol(Vout, R_pos_wei_short);
end

Vout.fname = [Output_path 'degree_neg_bin_' name '.nii'];
Vout = spm_write_vol(Vout, R_neg_bin);
if Dis>0
    Vout.fname = [Output_path 'degree_neg_bin_long_' name '.nii'];
    Vout = spm_write_vol(Vout, R_neg_bin_long);
    Vout.fname = [Output_path 'degree_neg_bin_short_' name '.nii'];
    Vout = spm_write_vol(Vout, R_neg_bin_short);
end

Vout.fname = [Output_path 'degree_neg_wei_' name '.nii'];
Vout = spm_write_vol(Vout, R_neg_wei);
if Dis>0
    Vout.fname = [Output_path 'degree_neg_wei_long_' name '.nii'];
    Vout = spm_write_vol(Vout, R_neg_wei_long);
    Vout.fname = [Output_path 'degree_neg_wei_short_' name '.nii'];
    Vout = spm_write_vol(Vout, R_neg_wei_short);
end

Vout.fname = [Output_path 'degree_abs_bin_' name '.nii'];
Vout = spm_write_vol(Vout, R_abs_bin);
if Dis>0
    Vout.fname = [Output_path 'degree_abs_bin_long_' name '.nii'];
    Vout = spm_write_vol(Vout, R_abs_bin_long);
    Vout.fname = [Output_path 'degree_abs_bin_short_' name '.nii'];
    Vout = spm_write_vol(Vout, R_abs_bin_short);
end

Vout.fname = [Output_path 'degree_abs_wei_' name '.nii'];
Vout = spm_write_vol(Vout, R_abs_wei);
if Dis>0
    Vout.fname = [Output_path 'degree_abs_wei_long_' name '.nii'];
    Vout = spm_write_vol(Vout, R_abs_wei_long);
    Vout.fname = [Output_path 'degree_abs_wei_short_' name '.nii'];
    spm_write_vol(Vout, R_abs_wei_short);
end
