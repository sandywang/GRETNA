function Process=gretna_RUN_DartelNormEpi(InputFile, FFFile, DTFile, BBox, VoxSize)
%-------------------------------------------------------------------------%
%   RUN DARTEL Normalizing functional image
%   Input:
%   InputFile    - The input file list, Nx1 cell (1x1 cell for 4D NIfTI)
%   FFFile       - flow field file, string
%   DTFile       - The DARTEL template file, string
%   BBox         - Bounding Box, 2x3 array
%   VoxSize      - VoxSize 1x3 array
%
%   Output:
%   Process      - The output process structure used by psom
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
JM=fullfile(GRETNAPath, 'Jobsman', 'gretna_DartelEPINormalization.mat');
SpmJob=load(JM);
            
SpmJob.matlabbatch{1, 1}.spm.tools.dartel.mni_norm.data.subj(1,1).images=InputCell;       
SpmJob.matlabbatch{1, 1}.spm.tools.dartel.mni_norm.data.subj(1,1).flowfield={FFFile};
SpmJob.matlabbatch{1, 1}.spm.tools.dartel.mni_norm.template={DTFile};
SpmJob.matlabbatch{1, 1}.spm.tools.dartel.mni_norm.fwhm=[0 0 0];
SpmJob.matlabbatch{1, 1}.spm.tools.dartel.mni_norm.preserve=0;
SpmJob.matlabbatch{1, 1}.spm.tools.dartel.mni_norm.bb=BBox;
SpmJob.matlabbatch{1, 1}.spm.tools.dartel.mni_norm.vox=VoxSize;

spm_jobman('run', SpmJob.matlabbatch);