function Process=gretna_RUN_T1SegNorm(InputFile, SourPath, SourPrefix, InputT1File, GMTpm, WMTpm, CSFTpm, BBox, VoxSize)
%-------------------------------------------------------------------------%
%   RUN Normalize by T1 Unified Segmentation
%   Input:
%   InputFile    - The input file list, Nx1 cell (1x1 cell for 4D NIfTI)
%   SourPath     - The path of source image
%   SourPrefix   - The prefix of source image
%   InputT1File  - The input T1 file list, 1x1 cell
%   GMTpm        - Grey matter template file, 1x1 cell
%   WMTpm        - White matter template file, 1x1 cell
%   CSFTpm       - CSF template file, 1x1 cell
%   BBox         - Bounding Box, 2x3 array
%   VoxSize      - VoxSize 1x3 array
%
%   Output:
%   Process    - The output process structure used by psom
%-------------------------------------------------------------------------%
%   Written by Sandy Wang (sandywang.rest@gmail.com) 20161013.
%   Copyright (C) 2013-2016
%   State Key Laboratory of Cognitive Neuroscience and Learning &
%   IDG/McGovern Institute of Brain Research, 
%   Beijing Normal University,
%   Beijing, PR China.

FstFile=InputFile{1};
[Path, Name, Ext]=fileparts(FstFile);
[FPath, SPath]=fileparts(Path);
% Get Source Image
if isempty(SourPath)
    SourPath=FPath;
end

SD=dir(fullfile(SourPath, SPath, [SourPrefix, '.nii']));
if isempty(SD)
    SD=dir(fullfile(SourPath, SPath, [SourPrefix, '.img']));
end
SourFile={fullfile(SourPath, SPath, SD(1).name)};

% Coregister
GRETNAPath=fileparts(which('gretna.m'));
JM=fullfile(GRETNAPath, 'Jobsman', 'gretna_Coregister.mat');
SpmJob=load(JM);
SpmJob.matlabbatch{1, 1}.spm.spatial.coreg.estimate.source = InputT1File;
SpmJob.matlabbatch{1, 1}.spm.spatial.coreg.estimate.ref=SourFile;

spm_jobman('run', SpmJob.matlabbatch);

[TPath, TName, TExt]=fileparts(InputT1File{1});
CoregT1File={fullfile(TPath, ['co', TName, TExt])};
copyfile(InputT1File{1}, CoregT1File{1});

% Segment
JM=fullfile(GRETNAPath, 'Jobsman', 'gretna_OldSegmentation.mat');
SpmJob=load(JM);
SpmJob.matlabbatch{1,1}.spm.spatial.preproc.opts.tpm={GMTpm; WMTpm; CSFTpm};
SpmJob.matlabbatch{1,1}.spm.spatial.preproc.data=CoregT1File;
SpmJob.matlabbatch{1,1}.spm.spatial.preproc.opts.regtype='mni';

spm_jobman('run', SpmJob.matlabbatch);
D=dir(fullfile('*_seg_sn.mat'));
% Normalization
if numel(InputFile)==1
    Nii=nifti(InputFile{1});
    TP=size(Nii.dat, 4);     
    InputCell=arrayfun(@(t) sprintf('%s,%d', InputFile{1}, t),...
        (1:TP)', 'UniformOutput', false);
else
    InputCell=InputFile;    
end


SpmJob.matlabbatch{1, 1}.spm.spatial.normalise.estwrite.eoptions.template={EPITpm};
SpmJob.matlabbatch{1, 1}.spm.spatial.normalise.estwrite.roptions.bb=BBox;
SpmJob.matlabbatch{1, 1}.spm.spatial.normalise.estwrite.roptions.vox=VoxSize;
SpmJob.matlabbatch{1, 1}.spm.spatial.normalise.estwrite.roptions.prefix='w';

