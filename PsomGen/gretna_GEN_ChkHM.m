function Process=gretna_GEN_ChkHM(InputFile, SubjLab, FunPath)
%-------------------------------------------------------------------------%
%   Generate psom-used struct for Check Head Motion
%   Input:
%   InputFile  - The input file list, Nx1 cell (1x1 cell for 4D NIfTI)
%   SubjLab    - The lab of subject for outputing.
%   FunPath    - The directory of functional dataset
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

Process.command='gretna_RUN_ChkHM(opt.InputFile, opt.SubjLab, opt.FunPath)';

% Options
Process.opt.InputFile=InputFile;
Process.opt.SubjLab=SubjLab;
Process.opt.FunPath=FunPath;
% Input Files
FstFile=InputFile{1};
[Path, Name]=fileparts(FstFile);
Process.files_in=[{fullfile(Path, 'HeadMotionParameter.txt')};...
    {fullfile(Path, 'PowerFD.txt')}];
% Output Files
PPath=fileparts(FunPath);
SubjLab=strrep(SubjLab, filesep, '_');
SubjLab=strrep(SubjLab, '.nii', '');

FDFile={fullfile(PPath, 'GretnaLogs', 'HeadMotionInfo', 'PowerFD',...
    [SubjLab, '.txt'])};
Process.files_out=FDFile;