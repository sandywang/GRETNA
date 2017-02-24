function Process=gretna_GEN_GenRandNet(InputFile, OutputFile, NType, RandNum)
%-------------------------------------------------------------------------%
%   Generate psom-used struct for Generating Random Networks
%   Input:
%   InputFile  - The input file, string
%   OutputFile - The output file, string
%   NType      - The type of network
%                1: Binary
%                2: Weighted
%   RandNum    - The number of random network
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

Process.command='gretna_RUN_GenRandNet(opt.InputFile, opt.OutputFile, opt.NType, opt.RandNum)';
% Option 
Process.opt.InputFile=InputFile;
Process.opt.OutputFile=OutputFile;
Process.opt.NType=NType;
Process.opt.RandNum=RandNum;

% Output Directory
% Input Files
Process.files_in={InputFile};
% Output Files
Process.OutputMatFile=OutputFile;
Process.files_out={OutputFile};