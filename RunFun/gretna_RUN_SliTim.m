function gretna_RUN_SliTim(InputFile, TR, SInd, RInd)
%-------------------------------------------------------------------------%
%   Run Slice Timing
%   Input:
%   InputFile  - The input file list, Nx1 cell (1x1 cell for 4D NIfTI)
%   TR         - TR of BOLD-fMRI Time Series
%   SInd       - The index of slice order
%                1: alt+z
%                2: alt+z2
%                3: alt-z
%                4: alt-z2
%                5: seq+z
%                6: seq-z
%   RInd       - The index of Reference Slice
%                1: The first slice
%                2: The middle slice
%                3: The last slice
%-------------------------------------------------------------------------%
%   Written by Sandy Wang (sandywang.rest@gmail.com) 20161013.
%   Copyright (C) 2013-2016
%   State Key Laboratory of Cognitive Neuroscience and Learning &
%   IDG/McGovern Institute of Brain Research, 
%   Beijing Normal University,
%   Beijing, PR China.
if numel(InputFile)==1
    Nii=nifti(InputFile{1});
    TP=size(Nii.dat, 4);    
    InputCell=arrayfun(@(t) sprintf('%s,%d', InputFile{1}, t),...
        (1:TP)', 'UniformOutput', false);
else
    Nii=nifti(InputFile{1});
    InputCell=InputFile;
end
SliNum=size(Nii.dat, 3);
TA=TR-(TR/SliNum);
switch SInd
    case 1 %alt+z
        SliOrd=[1:2:SliNum, 2:2:SliNum];
    case 2 %alt+z2
        SliOrd=[2:2:SliNum, 1:2:SliNum];
    case 3 %alt-z
        SliOrd=[flipdim(1:2:SliNum, 2), flipdim(2:2:SliNum, 2)];
    case 4 %alt-z2
        SliOrd=[flipdim(2:2:SliNum, 2), flipdim(1:2:SliNum, 2)];
    case 5 %seq+z
        SliOrd=1:SliNum;
    case 6 %seq-z
        SliOrd=SliNum:-1:1;
    otherwise
        error('Error: Slice Order Index');
end

switch RInd
    case 1 % The first
        RefSli=SliOrd(1);
    case 2 % The middle 
        RefSli=SliOrd(ceil(length(SliOrd)/2));
    case 3 % The last
        RefSli=SliOrd(end);
    otherwise
        error('Error: Reference Slice Index')
end

GRETNAPath=fileparts(which('gretna.m'));
JM=fullfile(GRETNAPath, 'Jobsman', 'gretna_Slicetiming.mat');
SpmJob=load(JM);
SpmJob.matlabbatch{1, 1}.spm.temporal.st.scans{1}=InputCell;
SpmJob.matlabbatch{1, 1}.spm.temporal.st.nslices=SliNum;
SpmJob.matlabbatch{1, 1}.spm.temporal.st.so=SliOrd;
SpmJob.matlabbatch{1, 1}.spm.temporal.st.refslice=RefSli;
SpmJob.matlabbatch{1, 1}.spm.temporal.st.tr=TR;
SpmJob.matlabbatch{1, 1}.spm.temporal.st.ta=TA;
SpmJob.matlabbatch{1, 1}.spm.temporal.st.prefix='a';

spm_jobman('run', SpmJob.matlabbatch);
