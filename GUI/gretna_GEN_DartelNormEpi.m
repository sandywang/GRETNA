function Process=gretna_GEN_DartelNormEpi(InputFile, FFFile, DTFile, BBox, VoxSize)
%-------------------------------------------------------------------------%
%   Generate psom-used struct for DARTEL Normalizing functional images
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

Process.command='gretna_RUN_DartelNormEpi(opt.InputFile, opt.FFFile, opt.DTFile, opt.BBox, opt.VoxSize)';

OutputFile=cellfun(@(f) gretna_FUN_GetOutputFile(f, 'w'), InputFile,...
    'UniformOutput', false);

% Options
Process.opt.InputFile=InputFile;
Process.opt.FFFile=FFFile;
Process.opt.DTFile=DTFile;
Process.opt.BBox=BBox;
Process.opt.VoxSize=VoxSize;

% Input Files
Process.files_in=[InputFile; {DTFile}; {FFFile}];
% Output Files
Process.OutputImgFile=OutputFile;
Process.files_out=OutputFile;
