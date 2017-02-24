function Process=gretna_GEN_SliTim(InputFile, TR, SInd, RInd)
%-------------------------------------------------------------------------%
%   Generate psom-used struct for Slice Timing
%   Input:
%   InputFile  - The input file list, Nx1 cell (1x1 cell for 4D NIfTI)
%   TR         - TR of BOLD-fMRI Time Series
%   SInd       - The index of slice order
%                1: alt+z
%                2: alt+z2
%                3: alt-z
%                4: alt-z2
%                5: seq+z
%                6: seq-z
%   RInd       - The index of Reference Slice
%                1: The first slice
%                2: The middle slice
%                3: The last slice
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

Process.command='gretna_RUN_SliTim(opt.InputFile, opt.TR, opt.SInd, opt.RInd)';
OutputFile=cellfun(@(f) gretna_FUN_GetOutputFile(f, 'a'), InputFile,...
    'UniformOutput', false);

% Options
Process.opt.InputFile=InputFile;
Process.opt.TR=TR;
Process.opt.SInd=SInd;
Process.opt.RInd=RInd;
% Input Files
Process.files_in=InputFile;
% Output Files
Process.OutputImgFile=OutputFile;
Process.files_out=OutputFile;
