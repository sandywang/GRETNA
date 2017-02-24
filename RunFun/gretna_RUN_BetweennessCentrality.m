function gretna_RUN_BetweennessCentrality(InputFile, OutputFile, NType, AUCInterval)
%-------------------------------------------------------------------------%
%   RUN Nodal - Betweenness Centrality
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
Bc=cellfun(@(a) BetweennessCentrality(a, NType), A,...
    'UniformOutput', false);
Bc=cell2mat(Bc);

SPath=fileparts(OutputFile);
if exist(SPath, 'dir')~=7
    mkdir(SPath);
end
save(OutputFile, 'Bc');

if AUCInterval>0
    deltas=AUCInterval;
    aBc=(sum(Bc, 2)-sum(Bc(:,[1 end]), 2)/2)*deltas;
    save(OutputFile, 'aBc', '-append');
end

function Bc=BetweennessCentrality(Matrix, NType)
if NType==1
    [avgBc, Bc]=gretna_node_betweenness(Matrix);
elseif NType==2
    [avgBc, Bc]=gretna_node_betweenness_weight(Matrix);
end
Bc=Bc';