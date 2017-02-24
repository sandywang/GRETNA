function Process=gretna_GEN_T1CoregNewSeg(InputFile, SoFile, InputT1File, TPMTpm)
%-------------------------------------------------------------------------%
%   Generate psom-used struct for Coregister And New Segmentation
%   Input:
%   InputFile    - The input file list, Nx1 cell (1x1 cell for 4D NIfTI)
%   SourPath     - The path of source image
%   SourPrefix   - The prefix of source image
%   InputT1File  - The input T1 file list, 1x1 cell
%   TPMTpm       - The tiusse template file, string
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

Process.command='gretna_RUN_T1CoregNewSeg(opt.InputFile, opt.SoFile, opt.InputT1File, opt.TPMTpm)';

% Options
Process.opt.InputFile=InputFile;
Process.opt.SoFile=SoFile;
Process.opt.InputT1File=InputT1File;
Process.opt.TPMTpm=TPMTpm;

% Input Files
Process.files_in=[InputFile; SoFile;InputT1File];
% Output Files

[TPath, TName, TExt]=fileparts(InputT1File{1});
C1File={fullfile(TPath, ['c1co', TName, TExt])};
C2File={fullfile(TPath, ['c2co', TName, TExt])};
C3File={fullfile(TPath, ['c3co', TName, TExt])};
RC1File={fullfile(TPath, ['rc1co', TName, TExt])};
RC2File={fullfile(TPath, ['rc2co', TName, TExt])};

Process.C1File=C1File{1};
Process.C2File=C2File{1};
Process.C3File=C3File{1};
Process.RC1File=RC1File{1};
Process.RC2File=RC2File{1};

Process.files_out=[C1File; C2File; C3File; RC1File; RC2File];