function gretna_preprocessing_BandPassFilter(Data_path, File_filter, Para)

%==========================================================================
% This function is used to perform bandpass filtering of images. NOTE, the
% resultant iamges will be started with prefix 'fil_'.
%
%
% Syntax: function gretna_preprocessing_BandPassFilter(Data_path, File_filter, Para)
%
% Inputs:
%       Data_path:
%                   The directory & filename of a .txt file that contains
%                   the directory of those files to be processed (can be
%                   obtained by gretna_gen_data_path.m).
%       File_filter:
%                   The prefix of those files to be processed.
%       Para (optional):
%                   Para.Filtering.TR:
%                        Repetition time (s).
%                   Para.Filtering.FreBand:
%                        Frequency-band (e.g.,[0.01 0.1]).
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

if nargin == 2
    Para.Filtering.TR = spm_input('TR',1,'e',[],1);
    Para.Filtering.FreBand = spm_input('Fre Band',2,'e',[],2);
end
close

fid = fopen(Data_path);
Dir_data = textscan(fid, '%s');
fclose(fid);

Num_subs = size(Dir_data{1},1);

for i = 1:Num_subs
    
    fprintf('Performing temporal filtering for %s\n', [Dir_data{1}{i}]);
    
    cd ([Dir_data{1}{i}])
    
    File_name = spm_select('List',pwd, ['^' File_filter '.*\.img$']);
    if isempty(File_name)
        File_name = spm_select('List',pwd, ['^' File_filter '.*\.nii$']);
    end
    
    Vin = spm_vol(File_name);
    Timepoints = size(Vin,1);
    
    Rows = Vin(1).dim(1); Columns= Vin(1).dim(2); Slices = Vin(1).dim(3);
    
    Vout = Vin;
    for t = 1:Timepoints
        [pth,nm,xt] = fileparts(deblank(Vin(t).fname));
        Vout(t).fname  = fullfile(pth,['fil_' nm xt]);
        Vout(t).dt(1) = 16;
    end
    Vout = spm_create_vol(Vout);
    
    for k = 1:Slices
        SliceData = zeros(Rows,Columns,Timepoints);
        
        for t = 1:Timepoints
            SliceData(:,:,t) = spm_slice_vol(Vin(t),spm_matrix([0 0 k]),[Rows Columns],0);
        end
        
        meanSliceData = mean(SliceData,3);
        
        [SliceData] = gretna_filtering(SliceData, Para.Filtering.TR, Para.Filtering.FreBand);
        
        SliceData = SliceData + repmat(meanSliceData,[1 1 Timepoints]);
        
        for t = 1:Timepoints
            Vout(t) = spm_write_plane(Vout(t),SliceData(:,:,t),k);
        end
    end
    
    fprintf('Performing temporal filtering for %s ...... is done\n', [Dir_data{1}{i}]);
    
end

return