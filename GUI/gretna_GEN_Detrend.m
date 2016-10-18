function Process=gretna_GEN_Detrend(InputFile, PolyOrd)
%-------------------------------------------------------------------------%
%   Generate psom-used struct for Temporally Detrend
%   Input:
%   InputFile  - The input file list, Nx1 cell (1x1 cell for 4D NIfTI)
%   PolyOrd    - Polynomial Order
%              - 1: Linear
%              - 2: Linear and Quadratic
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

Process.command='gretna_RUN_Detrend(opt.InputFile, opt.PolyOrd)';
OutputFile=cellfun(@(f) gretna_FUN_GetOutputFile(f, 'd'), InputFile,...
    'UniformOutput', false);

% Options
Process.opt.InputFile=InputFile;
Process.opt.PolyOrd=PolyOrd;
% Input Files
Process.files_in=InputFile;
% Output Files
Process.OutputImgFile=OutputFile;
Process.files_out=OutputFile;