function Process=gretna_GEN_T1CoregSegNorm(InputFile, SoFile, InputT1File, GMTpm, WMTpm, CSFTpm, BBox, VoxSize)
%-------------------------------------------------------------------------%
%   Generate psom-used struct for Normalize by T1 Unified Segmentation
%   Input:
%   InputFile    - The input file list, Nx1 cell (1x1 cell for 4D NIfTI)
%   SoFile       - The source image file, 1x1 cell
%   InputT1File  - The input T1 file list, 1x1 cell
%   GMTpm        - Grey matter template file, string
%   WMTpm        - White matter template file, string
%   CSFTpm       - CSF template file, string
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

Process.command='gretna_RUN_T1CoregSegNorm(opt.InputFile, opt.SoFile, opt.InputT1File, opt.GMTpm, opt.WMTpm, opt.CSFTpm, opt.BBox, opt.VoxSize)';
OutputFile=cellfun(@(f) gretna_FUN_GetOutputFile(f, 'w'), InputFile,...
    'UniformOutput', false);
OutputSoFile=cellfun(@(f) gretna_FUN_GetOutputFile(f, 'w'), SoFile,...
    'UniformOutput', false);

% Options
Process.opt.InputFile=[InputFile; SoFile];
Process.opt.SoFile=SoFile;
Process.opt.InputT1File=InputT1File;
Process.opt.GMTpm=GMTpm;
Process.opt.WMTpm=WMTpm;
Process.opt.CSFTpm=CSFTpm;
Process.opt.BBox=BBox;
Process.opt.VoxSize=VoxSize;

% Input Files
Process.files_in=[InputFile; SoFile; InputT1File];
% Output Files
Process.OutputImgFile=OutputFile;
Process.OutputSoFile=OutputSoFile;
Process.files_out=[OutputFile; OutputSoFile];