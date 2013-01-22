function gretna_batch_preprocessing(Data_path, File_filter, Order)

%==========================================================================
% This function is used to perform preprocessings of EPI dataset in a batch
% manner. The batch includes the following functions:
%
% 1) Deletion of the first several volumes
%
% 2) Slice timing
%            (the resultant iamges will be started with 'sli_');
% 3) Realignment
%            (the resultant iamges will be started with 'rea_');
% 4) Spatial normalization
%            (the resultant iamges will be started with 'nor_');
% 5) Spatial smoothing
%            (the resultant iamges will be started with 'smo_');
% 6) Detrend
%            (the resultant iamges will be started with 'det_');
% 7) Temporal filtering
%            (the resultant iamges will be started with 'fil_').
%
% NOTE, ensure that your images are not initialized by these predefined
% characters to avoid potential errors.
%
%
% Syntax: function gretna_batch_preprocessing(Data_path, File_filter, Order)
%
% Inputs:
%       Data_path:
%                   The directory & filename of a .txt file that contains
%                   the directory of those files to be processed (can be
%                   obtained by gretna_gen_data_path.m).
%       File_filter:
%                   The prefix of those files to be processed.
%       Order:
%                   The order of processing steps (e.g., [6 3 1] means
%                   performing Temporal filtering first, then Spatial
%                   normalization and final Slice timing).
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

prefix = {[],'sli_','rea_','nor_','smo_','det_','fil_'};

str = {'Delete several imgs',   'Slice timing',      'Realignment', ...
       'Spatial normalization', 'Spatial smoothing', 'Detrend', 'Filtering'};

funs ={'gretna_preprocessing_Delete_images', 'gretna_preprocessing_SliceTiming', ...
       'gretna_preprocessing_Realignment', 'gretna_preprocessing_Normalization', ...
       'gretna_preprocessing_Smooth', 'gretna_preprocessing_Detrend', ...
       'gretna_preprocessing_BandPassFilter'};

prefix{1} = File_filter;
prefix = prefix(Order(1:end-1));
File_filter = [File_filter prefix];

str = str(Order);

funs = funs(Order);

% Specify parameters
for i = 1:length(Order)
    switch Order(i)
        case 1
            spm_input(['Step' num2str(i)],1,'b',str{i},1);
            Para.DeleteImage.N = spm_input('# of Imgs',2,'e',[],1);
            close
            
        case 2
            spm_input(['Step' num2str(i)],1,'b',str{i},1);
            Para.SliceTiming.N = spm_input('# of Slices',2,'e',[],1);
            Para.SliceTiming.TR = spm_input('TR',3,'e',[],1);
            Para.SliceTiming.SliOrd = spm_input('Slice Order',4,'e',[],Para.SliceTiming.N);
            Para.SliceTiming.RefSlice = spm_input('Ref Slice',5,'e',[],1);
            Para.SliceTiming.TA = Para.SliceTiming.TR - Para.SliceTiming.TR/Para.SliceTiming.N;
            close
            
        case 3
            spm_input(['Step' num2str(i)],1,'b',str{i},1);
            
        case 4
            spm_input(['Step' num2str(i)],1,'b',str{i},1);
            Para.Normalization.Type = spm_input('Normalize type',2,'with EPI|with T1');
            Para.Normalization.VoxSize = spm_input('Voxel Size',3,'e',[],3)';
            if strcmp(Para.Normalization.Type, 'with T1')
                Para.Normalization.T1_path = spm_input('Enter Path of T1 (***\.txt)',4,'s');
                Para.Normalization.T1_File_filter = spm_input('Enter prefix of T1 Imgs',5,'s');
            end
            close
            
        case 5
            spm_input(['Step' num2str(i)],1,'b',str{i},1);
            Para.Smooth.FWHM = spm_input('FWHM',[],'e',[],3)';
            close
            
        case 6
            spm_input(['Step' num2str(i)],1,'b',str{i},1);
            Para.Detrend.N = spm_input('Order of Polynomial',2,'e',[],1)';
            Para.Detrend.RemainMean = spm_input('Remain Mean',3,'y/n',[1,0],0);
            close
            
        case 7
            spm_input(['Step' num2str(i)],1,'b',str{i},1);
            Para.Filtering.TR = spm_input('TR',2,'e',[],1);
            Para.Filtering.FreBand = spm_input('Fre Band',3,'e',[],2);
            close
    end
end

% Perform specified steps
for i = 1:length(Order)
    fprintf('============================================================== \n')
    fprintf('Performing preprocessing of %s \n', str{i});
    fprintf('============================================================== \n')
    
    feval(funs{i}, Data_path, File_filter{i}, Para);
end


% Generate a preprocessing.log file to record all preprocess parameters
[pathstr, ~, ~] = fileparts(Data_path);
cd (pathstr)

fid = fopen('preprocessing.log','w+');

for i = 1:length(Order)
    switch Order(i)
        case 1
            fprintf(fid, '%s\n', str{i});
            fprintf(fid, '%s\n', [blanks(4) 'Number of Delete images:' blanks(1) num2str(Para.DeleteImage.N)]);
            fprintf(fid, '\n');
            
        case 2
            fprintf(fid, '%s\n', str{i});
            fprintf(fid, '%s\n', [blanks(4) 'Number of Slices:' blanks(1) num2str(Para.SliceTiming.N)]);
            fprintf(fid, '%s\n', [blanks(4) 'TR:'              blanks(1) num2str(Para.SliceTiming.TR)]);
            fprintf(fid, '%s\n', [blanks(4) 'TA:'              blanks(1) num2str(Para.SliceTiming.TA)]);
            fprintf(fid, '%s\n', [blanks(4) 'Slice Order:'     blanks(1) num2str(Para.SliceTiming.SliOrd')]);
            fprintf(fid, '%s\n', [blanks(4) 'Reference Slice:' blanks(1) num2str(Para.SliceTiming.RefSlice)]);
            fprintf(fid, '\n');
            
        case 3
            fprintf(fid, '%s\n', str{i});
            fprintf(fid, '\n');
            
        case 4
            fprintf(fid, '%s\n', str{i});
            fprintf(fid, '%s\n', [blanks(4) 'Normalize Type:' blanks(1) Para.Normalization.Type]);
            fprintf(fid, '%s\n', [blanks(4) 'Resample:'       blanks(1) num2str(Para.Normalization.VoxSize)]);
            fprintf(fid, '\n');
            
        case 5
            fprintf(fid, '%s\n', str{i});
            fprintf(fid, '%s\n', [blanks(4) 'FWHM:' blanks(1) num2str(Para.Smooth.FWHM)]);
            fprintf(fid, '\n');
            
        case 6
            fprintf(fid, '%s\n', str{i});
            fprintf(fid, '%s\n', [blanks(4) 'Order of Polynomial:' blanks(1) num2str(Para.Detrend.N)]);
            if Para.Detrend.RemainMean == 1
                fprintf(fid, '%s\n', [blanks(4) 'Retain Mean:' blanks(1) 'Yes']);
            else
                fprintf(fid, '%s\n', [blanks(4) 'Retain Mean: No']);
            end
            fprintf(fid, '\n');
            
        case 7
            fprintf(fid, '%s\n', str{i});
            fprintf(fid, '%s\n', [blanks(4) 'TR:'                      blanks(1) num2str(Para.Filtering.TR)]);
            fprintf(fid, '%s\n', [blanks(4) 'Frequency Band:' blanks(1) num2str(Para.Filtering.FreBand')]);
            fprintf(fid, '\n');
    end
end

fclose(fid);

return