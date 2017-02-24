function Process=gretna_GEN_Filter(InputFile, TR, Band)
%-------------------------------------------------------------------------%
%   Generate psom-used struct for Temporally Filter
%   Input:
%   InputFile  - The input file list, Nx1 cell (1x1 cell for 4D NIfTI)
%   TR         - TR
%   Band       - Frequency Band, 
%                e.g., band-pass: [0.01, 0.08] 
%                      high-pass: [0.01, Inf]
%                      low-pass : [0, 0.1]
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

Process.command='gretna_RUN_Filter(opt.InputFile, opt.TR, opt.Band)';
OutputFile=cellfun(@(f) gretna_FUN_GetOutputFile(f, 'b'), InputFile,...
    'UniformOutput', false);

% Options
Process.opt.InputFile=InputFile;
Process.opt.TR=TR;
Process.opt.Band=Band;
% Input Files
Process.files_in=InputFile;
% Output Files
Process.OutputImgFile=OutputFile;
Process.files_out=OutputFile;