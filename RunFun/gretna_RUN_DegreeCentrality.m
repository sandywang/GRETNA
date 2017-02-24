function gretna_RUN_DegreeCentrality(InputFile, OutputFile, NType, AUCInterval)
%-------------------------------------------------------------------------%
%   Generate psom-used struct for Nodal - Degree Centrality
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
Dc=cellfun(@(a) DegreeCentrality(a, NType), A,...
    'UniformOutput', false);
Dc=cell2mat(Dc);

SPath=fileparts(OutputFile);
if exist(SPath, 'dir')~=7
    mkdir(SPath);
end
save(OutputFile, 'Dc');

if AUCInterval>0
    deltas=AUCInterval;
    aDc=(sum(Dc, 2)-sum(Dc(:,[1 end]), 2)/2)*deltas;
    save(OutputFile, 'aDc', '-append');
end

function Dc=DegreeCentrality(Matrix, NType)
if NType==1
    [avgDc, Dc]=gretna_node_degree(Matrix);
elseif NType==2
    [avgDc, Dc]=gretna_node_degree_weight(Matrix);
end
Dc=Dc';