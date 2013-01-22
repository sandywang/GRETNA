function gretna_preprocessing_SliceTiming(Data_path, File_filter, Para)

%==========================================================================
% This function is used to perform slice timing to correct intra-volume
% time offset among slices for EPI images of multiple subjects. NOTE, the
% resultant iamges will be started with prefix 'sli_'.
%
%
% Syntax: function gretna_preprocessing_Smooth(Data_path, File_filter, Para)
%
% Inputs:
%       Data_path:
%                   The directory & filename of a .txt file that contains
%                   the directory of those files to be processed (can be
%                   obtained by gretna_gen_data_path.m).
%       File_filter:
%                   The prefix of those files to be processed.
%       Para (optional):
%                   Para.SliceTiming.N:
%                        The number of slices in a volume.
%                   Para.SliceTiming.TR:
%                        The time repetition.
%                   Para.SliceTiming.SliOrd:
%                        The slice order.          
%                   Para.SliceTiming.RefSlice:
%                        The reference slice.
%                   Para.SliceTiming.TA:
%                        TR-(TR/N).
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/01/17, Jinhui.Wang.1982@gmail.com
%==========================================================================

if nargin == 2
    Para.SliceTiming.N = spm_input('Num of slices',[],'e',[],1);
    Para.SliceTiming.TR = spm_input('TR',[],'e',[],1);
    Para.SliceTiming.SliOrd = spm_input('Slice Order',[],'e',[],Para.SliceTiming.N);
    Para.SliceTiming.RefSlice = spm_input('Reference Slice',[],'e',[],1);
    Para.SliceTiming.TA = Para.SliceTiming.TR - Para.SliceTiming.TR/Para.SliceTiming.N;
end
close

load gretna_SliceTiming.mat
matlabbatch{1}.spm.temporal.st.nslices = Para.SliceTiming.N;
matlabbatch{1}.spm.temporal.st.tr = Para.SliceTiming.TR;
matlabbatch{1}.spm.temporal.st.ta = Para.SliceTiming.TA;
matlabbatch{1}.spm.temporal.st.so = Para.SliceTiming.SliOrd;
matlabbatch{1}.spm.temporal.st.refslice = Para.SliceTiming.RefSlice;

fid = fopen(Data_path);
Dir_data = textscan(fid, '%s');
fclose(fid);

Num_subs = size(Dir_data{1},1);

for i = 1:Num_subs
    
    fprintf('Performing slice timing for %s\n', [Dir_data{1}{i}]);
    
    batch_slice = matlabbatch;
    
    cd ([Dir_data{1}{i}])
    imgs = spm_select('List',pwd, ['^' File_filter  '.*\.img$']);
    if isempty(imgs)
        imgs = spm_select('List',pwd, ['^' File_filter  '.*\.nii$']);
    end
    
    Num_imgs = size(imgs,1);
    datacell = cell(Num_imgs,1);
    for j = 1:Num_imgs
        datacell{j,1} = [pwd '\' imgs(j,:)];
    end
    
    batch_slice{1}.spm.temporal.st.scans{1} = datacell;
    
    spm_jobman('run',batch_slice);
    
    fprintf('Performing slice timing for %s ...... is done\n', [Dir_data{1}{i}]);
    
end

return