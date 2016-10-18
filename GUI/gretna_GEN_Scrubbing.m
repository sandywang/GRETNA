function Process=gretna_GEN_Scrubbing(InputFile, FDFile, InterInd, FDTrd, PreNum, PostNum)
%-------------------------------------------------------------------------%
%   Generate psom-used struct for Temporally Filter
%   Input:
%   InputFile  - The input file list, Nx1 cell (1x1 cell for 4D NIfTI)
%   FDFile     - The Power's FD file, 1x1 cell;
%   InterInd   - The index of interpolation
%   FDTrd      - FD Threshold 
%   PreNum     - The time point number removed before bad time point 
%   PostNum    - The time point number removed after bad time point
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

Process.command='gretna_RUN_Scrubbing(opt.InputFile, opt.FDFile, opt.InterInd, opt.FDTrd, opt.PreNum, opt.PostNum)';
OutputFile=cellfun(@(f) gretna_FUN_GetOutputFile(f, 'x'), InputFile,...
    'UniformOutput', false);
FstFile=InputFile{1};
Path=fileparts(FstFile);
% Options
Process.opt.InputFile=InputFile;
Process.opt.FDFile=FDFile;
Process.opt.InterInd=InterInd;
Process.opt.FDTrd=FDTrd;
Process.opt.PreNum=PreNum;
Process.opt.PostNum=PostNum;
% Input Files
Process.files_in=[InputFile;FDFile];
% Output Files
Process.OutputImgFile=OutputFile;
Process.files_out=[OutputFile;...
    {fullfile(Path, 'ScrubbingPerctage.txt')}];