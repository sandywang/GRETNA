function Process=gretna_GEN_Assortativity(InputFile, RandNetFile, OutputFile, NType)
%-------------------------------------------------------------------------%
%   Generate psom-used struct for Global - Assortativity
%   Input:
%   InputFile   - The input file, string
%   RandNetFile - The random network file, string
%   OutputFile  - The output file, string
%   NType       - The type of network
%                 1: Binary
%                 2: Weighted
%
%   Output:
%   Process     - The output process structure used by psom
%-------------------------------------------------------------------------%
%   Written by Sandy Wang (sandywang.rest@gmail.com) 20161013.
%   Copyright (C) 2013-2016
%   State Key Laboratory of Cognitive Neuroscience and Learning &
%   IDG/McGovern Institute of Brain Research, 
%   Beijing Normal University,
%   Beijing, PR China.

Process.command='gretna_RUN_Assortativity(opt.InputFile, opt.RandNetFile, opt.OutputFile, opt.NType)';
% Option 
Process.opt.InputFile=InputFile;
Process.opt.RandNetFile=RandNetFile;
Process.opt.OutputFile=OutputFile;
Process.opt.NType=NType;

% Output Directory
% Input Files
Process.files_in=[{InputFile};{RandNetFile}];
% Output Files
Process.OutputMatFile=OutputFile;
Process.files_out={OutputFile};