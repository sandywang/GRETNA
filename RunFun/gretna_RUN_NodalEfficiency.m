function gretna_RUN_NodalEfficiency(InputFile, OutputFile, NType, AUCInterval)
%-------------------------------------------------------------------------%
%   RUN Nodal - Efficiency
%   Input:
%   InputFile   - The input file, string
%   OutputFile  - The output file, string
%   NType       - The type of network
%                 1: Binary
%                 2: Weighted
%   AUCInterval - The interval to estimate AUC, 0 if just one threshold
%-------------------------------------------------------------------------%
%   Written by Sandy Wang (sandywang.rest@gmail.com) 20161013.
%   Copyright (C) 2013-2016
%   State Key Laboratory of Cognitive Neuroscience and Learning &
%   IDG/McGovern Institute of Brain Research, 
%   Beijing Normal University,
%   Beijing, PR China.

RealNet=load(InputFile);
A=RealNet.A;
Ne=cellfun(@(a) NodalEfficiency(a, NType), A,...
    'UniformOutput', false);
Ne=cell2mat(Ne);

SPath=fileparts(OutputFile);
if exist(SPath, 'dir')~=7
    mkdir(SPath);
end
save(OutputFile, 'Ne');

if AUCInterval>0
    deltas=AUCInterval;
    aNe=(sum(Ne, 2)-sum(Ne(:,[1 end]), 2)/2)*deltas;
    save(OutputFile, 'aNe', '-append');
end

function Ne=NodalEfficiency(Matrix, NType)
if NType==1
    [avgNe, Ne]=gretna_node_global_efficiency(Matrix);
elseif NType==2
    [avgNe, Ne]=gretna_node_global_efficiency_weight(Matrix);
end
Ne=Ne';