function gretna_RUN_Realign(InputFile, NumPasses)
%-------------------------------------------------------------------------%
%   Run Realign
%   Input:
%   InputFile  - The input file list, Nx1 cell (1x1 cell for 4D NIfTI)
%   NumPasses  - NumPasses
%                1: Register to first
%                2: Register to mean
%-------------------------------------------------------------------------%
%   Written by Sandy Wang (sandywang.rest@gmail.com) 20161013.
%   Copyright (C) 2013-2016
%   State Key Laboratory of Cognitive Neuroscience and Learning &
%   IDG/McGovern Institute of Brain Research, 
%   Beijing Normal University,
%   Beijing, PR China.

FstFile=InputFile{1};
[Path, Name, Ext]=fileparts(FstFile);
RpFile=fullfile(Path, ['rp_', Name, '.txt']);
HMFile=fullfile(Path, 'HeadMotionParameter.txt');
FDFile=fullfile(Path, 'PowerFD.txt');

if numel(InputFile)==1
    Nii=nifti(InputFile{1});
    TP=size(Nii.dat, 4);     
    InputCell=arrayfun(@(t) sprintf('%s,%d', InputFile{1}, t),...
        (1:TP)', 'UniformOutput', false);
else
    InputCell=InputFile;    
end

GRETNAPath=fileparts('gretna.m');
JM=fullfile(GRETNAPath, 'Jobsman', 'gretna_Realignment.mat');
SpmJob=load(JM);
SpmJob.matlabbatch{1, 1}.spm.spatial.realign.estwrite.data{1}=InputCell;
SpmJob.matlabbatch{1, 1}.spm.spatial.realign.estwrite.eoptions.rtm=NumPasses;
SpmJob.matlabbatch{1, 1}.spm.spatial.realign.estwrite.roptions.prefix='r';

spm_jobman('run', SpmJob.matlabbatch);
copyfile(RpFile, HMFile); 

% Calculate FD Power (Power, J.D., Barnes, K.A., Snyder, A.Z., 
% Schlaggar, B.L., Petersen, S.E., 2012. Spurious but systematic 
% correlations in functional connectivity MRI networks arise from subject 
% motion. Neuroimage 59, 2142-2154.) 
Rp=load(RpFile);
Dif=diff(Rp);
Dif=[zeros(1,6); Dif];
Sph=Dif;
Sph(:,4:6)=Sph(:,4:6)*50;
PowerFD=sum(abs(Sph),2);
save(FDFile, 'PowerFD', '-ASCII', '-DOUBLE','-TABS');
