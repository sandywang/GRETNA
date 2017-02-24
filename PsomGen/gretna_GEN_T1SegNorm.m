function Process=gretna_GEN_T1SegNorm(InputFile, SourPath, SourPrefix, InputT1File, GMTpm, WMTpm, CSFTpm BBox, VoxSize)
%-------------------------------------------------------------------------%
%   Generate psom-used struct for Normalize by EPI
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

Process.command='gretna_RUN_T1SegNorm(InputFile, SourPath, SourPrefix, InputT1File, GMTpm, WMTpm, , BBox, VoxSize)';
OutputFile=cellfun(@(f) gretna_FUN_GetOutputFile(f, 'w'), InputFile,...
    'UniformOutput', false);

% Options
Process.opt.InputFile=InputFile;
Process.opt.SourPath=SourPath;
Process.opt.SourPrefix=SourPrefix;
Process.opt.EpiTpm=EpiTpm;
Process.opt.BBox=BBox;
Process.opt.VoxSize=VoxSize;

% Input Files
Process.files_in=InputFile;
% Output Files
Process.OutputImgFile=OutputFile;
Process.files_out=OutputFile;