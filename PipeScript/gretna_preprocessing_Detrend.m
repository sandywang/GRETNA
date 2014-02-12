function gretna_preprocessing_Detrend(Data_path, File_filter, Para)

%==========================================================================
% This function is used to remove linear or nonlinear trends in fMRI data.
% NOTE, the resultant iamges will be started with prefix 'det_'.
%
%
% Syntax: function gretna_preprocessing_Detrend(Data_path, File_filter, Para)
%
% Inputs:
%       Data_path:
%                   The directory & filename of a .txt file that contains
%                   the directory of those files to be processed (can be
%                   obtained by gretna_gen_data_path.m).
%       File_filter:
%                   The prefix of those files to be processed.
%       Para (optional):
%                   Para.Detrend.N:
%                           The degrees of polynomial curve fitting (e.g.,
%                           0, delete mean value;
%                           1, delete also linear trend;
%                           2, delete also 2th order;
%                           ......).
%                   Para.Detrend.RemainMean:
%                           yes/1: remain the mean of time course;
%                           no /0: remove the mean of time course.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2010/08/16, Jinhui.Wang.1982@gmail.com
%==========================================================================

if nargin == 2
    Para.Detrend.N = spm_input('Order of Polynomial',1,'e',[],1)';
    Para.Detrend.RemainMean = spm_input('Remain Mean',2,'y/n',[1,0],0);
end
close

fid = fopen(Data_path);
Dir_data = textscan(fid, '%s');
fclose(fid);

Num_subs = size(Dir_data{1},1);

for i = 1:Num_subs
    
    fprintf('Performing detrend for %s\n', [Dir_data{1}{i}]);
    
    cd ([Dir_data{1}{i}])
    File_name = spm_select('List',pwd, ['^' File_filter '.*\.img$']);
    if isempty(File_name)
        File_name = spm_select('List',pwd, ['^' File_filter '.*\.nii$']);
    end
    
    Vin = spm_vol(File_name);
    Timepoint = size(Vin,1);
    Rows = Vin(1).dim(1); Columns= Vin(1).dim(2); Slices = Vin(1).dim(3);
    
    Vout = Vin;
    for t = 1:Timepoint
        [pth,nm,xt] = fileparts(deblank(Vin(t).fname));
        Vout(t).fname  = fullfile(pth,['det_' nm xt]);
    end
    Vout = spm_create_vol(Vout);
    
    for k = 1:Slices
        SliceData = zeros(Rows,Columns,Timepoint);
        for t = 1:Timepoint
            SliceData(:,:,t) = spm_slice_vol(Vin(t),spm_matrix([0 0 k]),[Rows Columns],0);
        end
        
        meanSliceData = mean(SliceData,3);
        
        tmp = reshape(SliceData,prod([Rows Columns]),Timepoint);
        tmp_detrend = spm_detrend(tmp',Para.Detrend.N);
        SliceData = reshape(tmp_detrend',[Rows Columns Timepoint]);
        
        if Para.Detrend.RemainMean
            SliceData = SliceData + repmat(meanSliceData,[1 1 Timepoint]);
        end
        
        for t = 1:Timepoint
            Vout(t) = spm_write_plane(Vout(t),SliceData(:,:,t),k);
        end;
    end
    
    fprintf('Performing detrend for %s ...... is done\n', [Dir_data{1}{i}]);
    
end

return