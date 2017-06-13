function gretna_RUN_NodalClustCoeff(InputFile, OutputFile, NType, AUCInterval)
%-------------------------------------------------------------------------%
%   RUN Nodal - Clusting Coefficient
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
NCp=cellfun(@(a) NodalClustCoeff(a, NType), A,...
    'UniformOutput', false);
NCp=cell2mat(NCp);

SPath=fileparts(OutputFile);
if exist(SPath, 'dir')~=7
    mkdir(SPath);
end
save(OutputFile, 'NCp');

if AUCInterval>0
    deltas=AUCInterval;
    aNCp=(sum(NCp, 2)-sum(NCp(:,[1 end]), 2)/2)*deltas;
    save(OutputFile, 'aNCp', '-append');
end

function Ci=NodalClustCoeff(Matrix, NType)
if NType==1
    [Cp, Ci]=gretna_node_clustcoeff(Matrix);
elseif NType==2
    [Cp, Ci]=gretna_node_clustcoeff_weight(Matrix, 2); % Onnela
end
Ci=Ci';