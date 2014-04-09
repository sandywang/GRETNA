function gretna_alff(Data_path, File_filter, SamplePeriod, FreBand, Data_mask, Output_path)

%==========================================================================
% This function is used to calculate voxelwise ALFF in a specific frequency
% range. NOTE, only single-sided amplitude spectrum is used.
%
%
% Syntax: function gretna_alff(Data_path, File_filter, SamplePeriod, FreBand, Data_mask, Output_path)
%
% Inputs:
%       Data_path:
%                   The directory & filename of a .txt file that contains
%                   the directory of those files to be processed (can be
%                   obtained by gretna_gen_data_path.m).
%       File_filter:
%                   The prefix of those files to be processed.
% 	    SamplePeriod:
%                   TR.
%       FreBand:
%                   The frequency band for filtering (1*2 array). E.g.,
%                   FreBand = [f1 f2]  for band pass filtering: f1 < f < f2;
%                   FreBand = [0 f1]   for low  pass filtering: f < f1;
%                   FreBand = [f1 inf] for high pass filtering: f > f1.
%       Data_mask:
%                   The directory & filename a brain mask within which the
%                   ALFF calculation is performed.
%       Output_path:
%                   The directory where the resultant images are sorted.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2010/08/16, Jinhui.Wang.1982@gmail.com
%==========================================================================

Vmask = spm_vol(Data_mask);
[Ymask, ~] = spm_read_vols(Vmask);
Ymask(isnan(Ymask)) = 0;
IndMask = find(Ymask);

[I J K] = ind2sub(size(Ymask),IndMask);
XYZ = [I J K]';
XYZ(4,:) = 1;

sampleFreq 	 = 1/SamplePeriod;

fid = fopen(Data_path);
Dir_data = textscan(fid, '%s');
fclose(fid);

Num_subs = size(Dir_data{1},1);

for i = 1:Num_subs
    
    fprintf('Calculating ALFF for %s\n', [Dir_data{1}{i}]);
    
    cd ([Dir_data{1}{i}])
    
    File_name = spm_select('List',pwd, ['^' File_filter '.*\.img$']);
    if isempty(File_name)
        File_name = spm_select('List',pwd, ['^' File_filter '.*\.nii$']);
    end
    
    Vin = spm_vol(File_name);
    
    Ydata = spm_get_data(Vin,XYZ);
    Ydata = detrend(Ydata);
    
    Timepoints = size(Vin,1);
    NFFT = gretna_nextpow2(Timepoints);
    
    f = sampleFreq/2*linspace(0,1,NFFT/2+1);
    
    if isinf(FreBand(2))
        IndFre = f >= FreBand(1);
    else
        IndFre = f >= FreBand(1) & f <= FreBand(2);
    end
    
    Rows = Vin(1).dim(1); Columns= Vin(1).dim(2); Slices = Vin(1).dim(3);
    ALFF = zeros(Rows,Columns,Slices);
    PSD = 2*abs(fft(Ydata, NFFT))/Timepoints;
    ALFF(IndMask) = sum(PSD(IndFre,:));
    
    cd (Output_path)
    Vout = Vin(i);
    [~, name, ~] = fileparts(Dir_data{1}{i});
    Vout.fname = ['ALFF_' name '.img'];
    Vout.dt(1) = 16;
    Vout = spm_write_vol(Vout, ALFF);
    
    fprintf('Calculating ALFF for %s ...... is done\n', [Dir_data{1}{i}]);
    
end

return