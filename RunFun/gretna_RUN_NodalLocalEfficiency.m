function gretna_RUN_NodalLocalEfficiency(InputFile, OutputFile, NType, AUCInterval)
%-------------------------------------------------------------------------%
%   RUN Nodal - Local Efficiency
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
NLe=cellfun(@(a) NodalLocalEfficiency(a, NType), A,...
    'UniformOutput', false);
NLe=cell2mat(NLe);

SPath=fileparts(OutputFile);
if exist(SPath, 'dir')~=7
    mkdir(SPath);
end
save(OutputFile, 'NLe');

if AUCInterval>0
    deltas=AUCInterval;
    aNLe=(sum(NLe, 2)-sum(NLe(:,[1 end]), 2)/2)*deltas;
    save(OutputFile, 'aNLe', '-append');
end

function NLe=NodalLocalEfficiency(Matrix, NType)
if NType==1
    [avgNLe, NLe]=gretna_node_local_efficiency(Matrix);
elseif NType==2
    [avgNLe, NLe]=gretna_node_local_efficiency_weight(Matrix);
end
NLe=NLe';