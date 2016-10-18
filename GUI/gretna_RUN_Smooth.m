function Process=gretna_RUN_Smooth(InputFile, FWHM)
%-------------------------------------------------------------------------%
%   RUN Smooth
%   Input:
%   InputFile    - The input file list, Nx1 cell (1x1 cell for 4D NIfTI)
%   FWHM         - Full width at half maximum (mm), e.g., [4 4 4] 
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
    InputCell=InputFile;    
end

GRETNAPath=fileparts('gretna.m');
JM=fullfile(GRETNAPath, 'Jobsman', 'gretna_Smooth.mat');
SpmJob=load(JM);
SpmJob.matlabbatch{1, 1}.spm.spatial.smooth.data=InputCell;
SpmJob.matlabbatch{1, 1}.spm.spatial.smooth.fwhm=FWHM;
SpmJob.matlabbatch{1, 1}.spm.spatial.smooth.prefix='s';
SpmJob.matlabbatch{1, 1}.spm.spatial.smooth.dtype=spm_type('float32');

spm_jobman('run', SpmJob.matlabbatch);