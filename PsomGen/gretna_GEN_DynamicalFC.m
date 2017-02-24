function Process=gretna_GEN_DynamicalFC(InputFile, SubjLab, FunPath, FCAtlas, FZTInd, SWL, SWS)
%-------------------------------------------------------------------------%
%   Generate psom-used struct for Dynamical Functional Connectivity
%   Input:
%   InputFile  - The input file list, Nx1 cell (1x1 cell for 4D NIfTI)
%   SubjLab    - The lab of subject for outputing.
%   FunPath    - The directory of functional dataset
%   FCAtlas    - The atlas file to generate functional connectivity
%                matrix, string
%   FZTInd     - Execute Fisher's z transformation or not
%                1: Do
%                2: Do not
%   SWL        - Sliding window length (time point)
%   SWS        - Sliding window step (time point)
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

Process.command='gretna_RUN_DynamicalFC(opt.InputFile, opt.SubjLab, opt.FunPath, opt.FCAtlas, opt.FZTInd, opt.SWL, opt.SWS)';

% Options
Process.opt.InputFile=InputFile;
Process.opt.SubjLab=SubjLab;
Process.opt.FunPath=FunPath;
Process.opt.FCAtlas=FCAtlas;
Process.opt.FZTInd=FZTInd;
Process.opt.SWL=SWL;
Process.opt.SWS=SWS;
% Input Files
PPath=fileparts(FunPath);
TCFile={fullfile(PPath, 'GretnaTimeCourse', [SubjLab, '.txt'])};
Process.files_in=[InputFile; TCFile];
% Output Files
Process.OutputImgFile=InputFile;
DFCFile={fullfile(PPath, 'GretnaDFCMatrixR', ['r', SubjLab, '.mat'])};
Process.files_out=DFCFile;