function gretna_voxel_based_degree_pipeuse(Data_List, Output_path, Data_mask, R_thr, Dis)

%==========================================================================
% This function is used to calculate nodal degree for each voxel in the
% brain. (for GUI pipeline)
%
% Syntax: function gretna_voxel_based_degree(Data_List, Output_path, File_filter, Data_mask)
%
% Inputs:
%       Data_List:
%                   The cell that contains those files to be processed (can be
%                   obtained by gretna_gen_Data_List.m).
%       Output_path:
%                   The directory where the results will be sorted.
%
%       Data_mask:
%                   The directory & filename of a brain mask that is used
%                   to determine which voxels will be calculated. In general,
%                   the brainmask_bin_xxx.img can be used as in
%                   ...\gretna\templates.
%       R_thr:
%                   Positive value of R-threshold used to rule out low
%                   spurious correlations.
%       Dis (mm):
%                   Distance threshold used to classify long vs. short
%                   connections.
%
% Outputs:
%
%       pos_xxx_long.img/hdr:
%                   Positive long degree,  i.e., R > R_thr (> Dis);
%       pos_xxx_short.img/hdr:
%                   Positive short degree, i.e., R > R_thr (< Dis);
%       pos_xxx.img/hdr:
%                   Positive degree,       i.e., R > R_thr;
%       neg_xxx_long.img/hdr:
%                   Negative long degree,  i.e., R < -R_thr (> Dis);
%       neg_xxx_short.img/hdr:
%                   Negative short degree, i.e., R < -R_thr (< Dis);
%       neg_xxx.img/hdr:
%                   Negative degree,       i.e., R < -R_thr;
%       abs_xxx_long.img/hdr:
%                   Absolute long degree,  i.e., |R| < -R_thr (> Dis);
%       abs_xxx_short.img/hdr:
%                   Absolute short degree, i.e., |R| < -R_thr (< Dis);
%       abs_xxx.img/hdr:
%                   Absolute degree,       i.e., |R| > R_thr;
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

Vmask = spm_vol(Data_mask);
[Ymask, XYZ] = spm_read_vols(Vmask);
Ymask(isnan(Ymask)) = 0;

Index = find(Ymask);
XYZ = XYZ(:,Index)';
[I J K] = ind2sub(size(Ymask),Index);

Num_subs = length(Dir_data{1});
    
    Vin = spm_vol(File_name);
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
    
    for ii = 1:length(Index)
        D = pdist2(XYZ(ii,:),XYZ);
        
        r = Ydata(:,ii)' * Ydata / (numSample - 1);
        
        tmp = find(r >= R_thr);
        R_pos_bin(Index(ii))       = length(tmp) - 1;
        R_pos_bin_long(Index(ii))  = length(find(D(tmp) >= Dis));
        R_pos_bin_short(Index(ii)) = length(find(D(tmp) < Dis)) - 1;
        R_pos_wei(Index(ii))       = sum(r(tmp)) - 1;
        R_pos_wei_long(Index(ii))  = sum(r(tmp(D(tmp) >= Dis)));
        R_pos_wei_short(Index(ii)) = sum(r(tmp(D(tmp) < Dis))) - 1;
        
        tmp = find(abs(r) >= R_thr);
        R_abs_bin(Index(ii))       = length(tmp) - 1;
        R_abs_bin_long(Index(ii))  = length(find(D(tmp) >= Dis));
        R_abs_bin_short(Index(ii)) = length(find(D(tmp) < Dis)) - 1;
        R_abs_wei(Index(ii))       = sum(abs(r(tmp))) - 1;
        R_abs_wei_long(Index(ii))  = sum(abs(r(tmp(D(tmp) >= Dis))));
        R_abs_wei_short(Index(ii)) = sum(abs(r(tmp(D(tmp) < Dis)))) - 1;
    end
    
    R_neg_bin       = R_abs_bin - R_pos_bin;
    R_neg_bin_long  = R_abs_bin_long - R_pos_bin_long;
    R_neg_bin_short = R_abs_bin_short - R_pos_bin_short;
    R_neg_wei       = R_abs_wei - R_pos_wei;
    R_neg_wei_long  = R_abs_wei_long - R_pos_wei_long;
    R_neg_wei_short = R_abs_wei_short - R_pos_wei_short;
    
    cd (Output_path)
    Vout = Vin(1);
    Vout.dt(1) = 16;
    
    Vout.fname = ['degree_pos_bin_' name '.img'];
    Vout = spm_write_vol(Vout, R_pos_bin);
    Vout.fname = ['degree_pos_bin_long_' name '.img'];
    Vout = spm_write_vol(Vout, R_pos_bin_long);
    Vout.fname = ['degree_pos_bin_short_' name '.img'];
    Vout = spm_write_vol(Vout, R_pos_bin_short);
    
    Vout.fname = ['degree_pos_wei_' name '.img'];
    Vout = spm_write_vol(Vout, R_pos_wei);
    Vout.fname = ['degree_pos_wei_long_' name '.img'];
    Vout = spm_write_vol(Vout, R_pos_wei_long);
    Vout.fname = ['degree_pos_wei_short_' name '.img'];
    Vout = spm_write_vol(Vout, R_pos_wei_short);
    
    Vout.fname = ['degree_neg_bin_' name '.img'];
    Vout = spm_write_vol(Vout, R_neg_bin);
    Vout.fname = ['degree_neg_bin_long_' name '.img'];
    Vout = spm_write_vol(Vout, R_neg_bin_long);
    Vout.fname = ['degree_neg_bin_short_' name '.img'];
    Vout = spm_write_vol(Vout, R_neg_bin_short);
    
    Vout.fname = ['degree_neg_wei_' name '.img'];
    Vout = spm_write_vol(Vout, R_neg_wei);
    Vout.fname = ['degree_neg_wei_long_' name '.img'];
    Vout = spm_write_vol(Vout, R_neg_wei_long);
    Vout.fname = ['degree_neg_wei_short_' name '.img'];
    Vout = spm_write_vol(Vout, R_neg_wei_short);
    
    Vout.fname = ['degree_abs_bin_' name '.img'];
    Vout = spm_write_vol(Vout, R_abs_bin);
    Vout.fname = ['degree_abs_bin_long_' name '.img'];
    Vout = spm_write_vol(Vout, R_abs_bin_long);
    Vout.fname = ['degree_abs_bin_short_' name '.img'];
    Vout = spm_write_vol(Vout, R_abs_bin_short);
    
    Vout.fname = ['degree_abs_wei_' name '.img'];
    Vout = spm_write_vol(Vout, R_abs_wei);
    Vout.fname = ['degree_abs_wei_long_' name '.img'];
    Vout = spm_write_vol(Vout, R_abs_wei_long);
    Vout.fname = ['degree_abs_wei_short_' name '.img'];
    Vout = spm_write_vol(Vout, R_abs_wei_short);
    
    fprintf('Calculating voxelwise degree for %s ...... is done\n', [Dir_data{1}{i}]);