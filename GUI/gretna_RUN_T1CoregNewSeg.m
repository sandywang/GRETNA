function gretna_RUN_T1CoregNewSeg(InputFile, SoFile, InputT1File, TPMTpm)
%-------------------------------------------------------------------------%
%   RUN Coregister And New Segmentation
%   Input:
%   InputFile    - The input file list, Nx1 cell (1x1 cell for 4D NIfTI)
%   SourPath     - The path of source image
%   InputT1File  - The input T1 file list, 1x1 cell
%   TPMTpm       - The tiusse template file, string
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
SpmJob.matlabbatch{1, 1}.spm.spatial.coreg.estimate.source=InputT1File;
SpmJob.matlabbatch{1, 1}.spm.spatial.coreg.estimate.ref=SoFile;

spm_jobman('run', SpmJob.matlabbatch);

[TPath, TName, TExt]=fileparts(InputT1File{1});
CoregT1File={fullfile(TPath, ['co', TName, TExt])};
copyfile(InputT1File{1}, CoregT1File{1});

% NewSegment
SPMPath=fileparts('spm.m');
if exist(fullfile(SPMPath, 'toolbox', 'Seg', 'TPM.nii'), 'file')~=2 %spm12
    JM=fullfile(GRETNAPath, 'Jobsman', 'gretna_NewSegment12.mat');
    SpmJob=load(JM);
    for t=1:6
        SpmJob.matlabbatch{1, 1}.spm.spatial.preproc.tissue(1, t).tpm{1,1}=...
            sprintf('%s,%d', TPMTpm, t);
        SpmJob.matlabbatch{1, 1}.spm.spatial.preproc.tissue(1, t).warped=...
            [0 0];
    end
    SpmJob.matlabbatch{1, 1}.spm.spatial.preproc.channel.vols=CoregT1File;
else
    JM=fullfile(GRETNAPath, 'Jobsman', 'gretna_NewSegment8.mat');
    SpmJob=load(JM);
    
    % Tissue Template
    for t=1:6
        SpmJob.matlabbatch{1, 1}.spm.tools.preproc8.tissue(1, t).tpm{1,1}=...
            sprintf('%s,%d', TPMTpm, t);
        SpmJob.matlabbatch{1, 1}.spm.tools.preproc8.tissue(1, t).warped=...
            [0 0];
    end    
    SpmJob.matlabbatch{1, 1}.spm.tools.preproc8.channel.vols=CoregT1File;
end
spm_jobman('run', SpmJob.matlabbatch);