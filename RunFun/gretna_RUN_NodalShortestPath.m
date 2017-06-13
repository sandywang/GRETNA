function gretna_RUN_NodalShortestPath(InputFile, OutputFile, NType, AUCInterval)
%-------------------------------------------------------------------------%
%   RUN Nodal - Shortest Path Length
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
NLp=cellfun(@(a) NodalShortestPath(a, NType), A,...
    'UniformOutput', false);
NLp=cell2mat(NLp);

SPath=fileparts(OutputFile);
if exist(SPath, 'dir')~=7
    mkdir(SPath);
end
save(OutputFile, 'NLp');

if AUCInterval>0
    deltas=AUCInterval;
    aNLp=(sum(NLp, 2)-sum(NLp(:,[1 end]), 2)/2)*deltas;
    save(OutputFile, 'aNLp', '-append');
end

function Li=NodalShortestPath(Matrix, NType)
if NType==1
    [Lp, Li]=gretna_node_shortestpathlength(Matrix);
elseif NType==2
    [Lp, Li]=gretna_node_shortestpathlength_weight(Matrix);
end
Li=Li';