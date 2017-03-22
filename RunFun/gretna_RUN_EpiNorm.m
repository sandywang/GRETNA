function gretna_RUN_EpiNorm(InputFile, SoFile, EPITpm, BBox, VoxSize)
%-------------------------------------------------------------------------%
%   RUN Normalize by EPI
%   Input:
%   InputFile    - The input file list, Nx1 cell (1x1 cell for 4D NIfTI)
%   SoFile       - The source image file, 1x1 cell.
%   EPITpm       - EPI template file, 1x1 cell
%   BBox         - Bounding Box, 2x3 array
%   VoxSize      - VoxSize 1x3 array
%-------------------------------------------------------------------------%
%   Written by Sandy Wang (sandywang.rest@gmail.com) 20161013.
%   Copyright (C) 2013-2016
%   State Key Laboratory of Cognitive Neuroscience and Learning &
%   IDG/McGovern Institute of Brain Research, 
%   Beijing Normal University,
%   Beijing, PR China.

FstFile=InputFile{1};

if numel(InputFile)==1
    Nii=nifti(InputFile{1});
    TP=size(Nii.dat, 4);     
    InputCell=arrayfun(@(t) sprintf('%s,%d', InputFile{1}, t),...
        (1:TP)', 'UniformOutput', false);
else
    InputCell=InputFile;    
end

GRETNAPath=fileparts(which('gretna.m'));
JM=fullfile(GRETNAPath, 'Jobsman', 'gretna_EPINormalization.mat');
SpmJob=load(JM);
SpmJob.matlabbatch{1, 1}.spm.spatial.normalise.estwrite.subj.resample=InputCell;
SpmJob.matlabbatch{1, 1}.spm.spatial.normalise.estwrite.subj.source=SoFile;
SpmJob.matlabbatch{1, 1}.spm.spatial.normalise.estwrite.eoptions.template={EPITpm};
SpmJob.matlabbatch{1, 1}.spm.spatial.normalise.estwrite.roptions.bb=BBox;
SpmJob.matlabbatch{1, 1}.spm.spatial.normalise.estwrite.roptions.vox=VoxSize;
SpmJob.matlabbatch{1, 1}.spm.spatial.normalise.estwrite.roptions.prefix='w';

spm_jobman('run', SpmJob.matlabbatch);