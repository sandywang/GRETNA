function gretna_RUN_T1CoregSegNorm(InputFile, SoFile, InputT1File, GMTpm, WMTpm, CSFTpm, BBox, VoxSize)
%-------------------------------------------------------------------------%
%   RUN Normalize by T1 Unified Segmentation
%   Input:
%   InputFile    - The input file list, Nx1 cell (1x1 cell for 4D NIfTI)
%   SoFile       - The source image file
%   InputT1File  - The input T1 file list, 1x1 cell
%   GMTpm        - Grey matter template file, string
%   WMTpm        - White matter template file, string
%   CSFTpm       - CSF template file, string
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
[Path, Name, Ext]=fileparts(FstFile);

% Coregister
GRETNAPath=fileparts('gretna.m');
JM=fullfile(GRETNAPath, 'Jobsman', 'gretna_Coregister.mat');
SpmJob=load(JM);
SpmJob.matlabbatch{1, 1}.spm.spatial.coreg.estimate.source = InputT1File;
SpmJob.matlabbatch{1, 1}.spm.spatial.coreg.estimate.ref=SoFile;

spm_jobman('run', SpmJob.matlabbatch);

[TPath, TName, TExt]=fileparts(InputT1File{1});
CoregT1File={fullfile(TPath, ['co', TName, TExt])};
copyfile(InputT1File{1}, CoregT1File{1});

% Segment
JM=fullfile(GRETNAPath, 'Jobsman', 'gretna_OldSegment.mat');
SpmJob=load(JM);
SpmJob.matlabbatch{1,1}.spm.spatial.preproc.opts.tpm={GMTpm; WMTpm; CSFTpm};
SpmJob.matlabbatch{1,1}.spm.spatial.preproc.data=CoregT1File;
SpmJob.matlabbatch{1,1}.spm.spatial.preproc.opts.regtype='mni';

spm_jobman('run', SpmJob.matlabbatch);

% Normalization
SMFile={fullfile(TPath, ['co', TName, '_seg_sn.mat'])};
if numel(InputFile)==1
    Nii=nifti(InputFile{1});
    TP=size(Nii.dat, 4);     
    InputCell=arrayfun(@(t) sprintf('%s,%d', InputFile{1}, t),...
        (1:TP)', 'UniformOutput', false);
else
    InputCell=InputFile;    
end

JM=fullfile(GRETNAPath, 'Jobsman', 'gretna_WriteNormalization.mat');
SpmJob=load(JM);
SpmJob.matlabbatch{1, 1}.spm.spatial.normalise.write.subj.matname=SMFile;
SpmJob.matlabbatch{1, 1}.spm.spatial.normalise.write.subj.resample=InputCell;
SpmJob.matlabbatch{1, 1}.spm.spatial.normalise.write.roptions.bb=BBox;
SpmJob.matlabbatch{1, 1}.spm.spatial.normalise.write.roptions.vox=VoxSize;
SpmJob.matlabbatch{1, 1}.spm.spatial.normalise.write.roptions.prefix='w';

spm_jobman('run', SpmJob.matlabbatch);
