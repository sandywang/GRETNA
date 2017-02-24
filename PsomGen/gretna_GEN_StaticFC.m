function Process=gretna_GEN_StaticFC(InputFile, SubjLab, FunPath, FCAtlas, FZTInd)
%-------------------------------------------------------------------------%
%   Generate psom-used struct for Static Functional Connectivity
%   Input:
%   InputFile  - The input file list, Nx1 cell (1x1 cell for 4D NIfTI)
%   SubjLab    - The lab of subject for outputing.
%   FunPath    - The directory of functional dataset
%   FCAtlas    - The atlas file to generate functional connectivity
%                matrix, string
%   FZTInd     - Execute Fisher's z transformation or not
%                1: Do
%                2: Do not
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

Process.command='gretna_RUN_StaticFC(opt.InputFile, opt.SubjLab, opt.FunPath, opt.FCAtlas, opt.FZTInd)';

% Options
Process.opt.InputFile=InputFile;
Process.opt.SubjLab=SubjLab;
Process.opt.FunPath=FunPath;
Process.opt.FCAtlas=FCAtlas;
Process.opt.FZTInd=FZTInd;
% Input Files
Process.files_in=InputFile;
% Output Files
Process.OutputImgFile=InputFile;

PPath=fileparts(FunPath);
TCFile={fullfile(PPath, 'GretnaTimeCourse', [SubjLab, '.txt'])};
MatrixFile={fullfile(PPath, 'GretnaSFCMatrixR', ['r', SubjLab, '.txt'])};
Process.files_out=[MatrixFile;TCFile];