function Process=gretna_GEN_Realign(InputFile, NumPasses)
%-------------------------------------------------------------------------%
%   Generate psom-used struct for Realign
%   Input:
%   InputFile  - The input file list, Nx1 cell (1x1 cell for 4D NIfTI)
%   NumPasses  - NumPasses
%                1: Register to first
%                2: Register to mean
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

Process.command='gretna_RUN_Realign(opt.InputFile, opt.NumPasses)';
OutputFile=cellfun(@(f) gretna_FUN_GetOutputFile(f, 'r'), InputFile,...
    'UniformOutput', false);
FstFile=InputFile{1};
[Path, Name, Ext]=fileparts(FstFile);
% Options
Process.opt.InputFile=InputFile;
Process.opt.NumPasses=NumPasses;
% Input Files
Process.files_in=InputFile;
% Output Files
Process.OutputImgFile=OutputFile;
Process.HMFile={fullfile(Path, 'HeadMotionParameter.txt')};
Process.FDFile={fullfile(Path, 'PowerFD.txt')};
Process.SoFile={fullfile(Path, ['mean', Name, Ext])};
Process.files_out=[OutputFile;...
    {fullfile(Path, 'HeadMotionParameter.txt')};...
    {fullfile(Path, 'PowerFD.txt')};...
    {fullfile(Path, ['mean', Name, Ext])}];