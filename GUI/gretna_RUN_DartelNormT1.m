function gretna_RUN_DartelNormT1(RC1FileList, RC2FileList, C1FileList, C2FileList, C3FileList)
%-------------------------------------------------------------------------%
%   RUN DARTEL Normalizing T1 Image
%   Input:
%   RC1FileList   -
%   RC2FileList   -
%   C1FileList    - All subject GM list, Sx1 cell, Nx1 cell in each cell
%   C2FileList    - All subject WM list, Sx1 cell, Nx1 cell in each cell
%   C3FileList    - All subject CSF list, Sx1 cell, Nx1 cell in each cell
%-------------------------------------------------------------------------%
%   Written by Sandy Wang (sandywang.rest@gmail.com) 20161013.
%   Copyright (C) 2013-2016
%   State Key Laboratory of Cognitive Neuroscience and Learning &
%   IDG/McGovern Institute of Brain Research, 
%   Beijing Normal University,
%   Beijing, PR China.

GRETNAPath=fileparts('gretna.m');
% Create Template
JM=fullfile(GRETNAPath, 'Jobsman', 'gretna_DartelCreateTpm.mat');
SpmJob=load(JM);

SpmJob.matlabbatch{1, 1}.spm.tools.dartel.warp.images{1, 1}=RC1FileList;
SpmJob.matlabbatch{1, 1}.spm.tools.dartel.warp.images{1, 2}=RC2FileList;

spm_jobman('run', SpmJob.matlabbatch);

% Normalize T1
FFFile=cellfun(@(inRC1) GenFFFile(inRC1), RC1FileList, 'UniformOutput', false);
DTFile=cellfun(@(inRC1) GenDTFile(inRC1), RC1FileList, 'UniformOutput', false);

JM=fullfile(GRETNAPath, 'Jobsman', 'gretna_DartelT1Normalization.mat');
SpmJob=load(JM);

SpmJob.matlabbatch{1, 1}.spm.tools.dartel.mni_norm.template=DTFile;
SpmJob.matlabbatch{1, 1}.spm.tools.dartel.mni_norm.data.subjs.flowfields=FFFile;
    
SpmJob.matlabbatch{1, 1}.spm.tools.dartel.mni_norm.data.subjs.images{1,1}=C1FileList;
SpmJob.matlabbatch{1, 1}.spm.tools.dartel.mni_norm.data.subjs.images{1,2}=C2FileList;
SpmJob.matlabbatch{1, 1}.spm.tools.dartel.mni_norm.data.subjs.images{1,3}=C3FileList;

function DTFile=GenDTFile(in)
[Path, Name, Ext]=fileparts(in);
DTFile=fullfile(Path, ['Template_6', Ext]);
    
function FFFile=GenFFFile(in)
[Path, Name, Ext]=fileparts(in);
FFFile=fullfile(Path, ['u_', Name, '_Template', Ext]);