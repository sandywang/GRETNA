function Process=gretna_GEN_CommunityIndex(InputFile, OutputFile, NType, MType, DDPcInd)
%-------------------------------------------------------------------------%
%   Generate psom-used struct for Nodal - Community Index
%   Input:
%   InputFile   - The input file, string
%   OutputFile  - The output file, string
%   NType       - The type of network
%                 1: Binary
%                 2: Weighted
%   MType       - The algorthim of modularity
%                 1: Modified Greedy Optimization, Danon et al., 2006
%                 2: Spectral Optimization, Newman et al., 2006
%   DDPcInd     - Estimating data-driven participant coefficient
%                 1: Do
%                 2: Not Do
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

Process.command='gretna_RUN_CommunityIndex(opt.InputFile, opt.OutputFile, opt.NType, opt.MType, opt.DDPcInd)';
% Option 
Process.opt.InputFile=InputFile;
Process.opt.OutputFile=OutputFile;
Process.opt.NType=NType;
Process.opt.MType=MType;
Process.opt.DDPcInd=DDPcInd;

% Output Directory
% Input Files
Process.files_in={InputFile};
% Output Files
Process.OutputMatFile=OutputFile;
Process.files_out={OutputFile};