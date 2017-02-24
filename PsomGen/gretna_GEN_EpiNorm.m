function Process=gretna_GEN_EpiNorm(InputFile, SoFile, EPITpm, BBox, VoxSize)
%-------------------------------------------------------------------------%
%   Generate psom-used struct for Normalize by EPI
%   Input:
%   InputFile    - The input file list, Nx1 cell (1x1 cell for 4D NIfTI)
%   SoFile       - The source image file, 1x1 cell.
%   EPITpm       - EPI template file, 1x1 cell
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

Process.command='gretna_RUN_EpiNorm(opt.InputFile, opt.SoFile, opt.EPITpm, opt.BBox, opt.VoxSize)';
OutputFile=cellfun(@(f) gretna_FUN_GetOutputFile(f, 'w'), InputFile,...
    'UniformOutput', false);
OutputSoFile=cellfun(@(f) gretna_FUN_GetOutputFile(f, 'w'), SoFile,...
    'UniformOutput', false);

% Options
Process.opt.InputFile=[InputFile; SoFile];
Process.opt.SoFile=SoFile;
Process.opt.EPITpm=EPITpm;
Process.opt.BBox=BBox;
Process.opt.VoxSize=VoxSize;

% Input Files
Process.files_in=[InputFile;SoFile];
% Output Files
Process.OutputImgFile=OutputFile;
Process.OutputSoFile=OutputSoFile;
Process.files_out=[OutputFile; OutputSoFile];