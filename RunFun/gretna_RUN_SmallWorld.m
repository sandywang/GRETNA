function gretna_RUN_SmallWorld(InputFile, RandNetFile, OutputFile, NType, ClustAlgor, AUCInterval)
%-------------------------------------------------------------------------%
%   RUN Global - Small World
%   Input:
%   InputFile   - The input file, string
%   RandNetFile - The random network file, string
%   OutputFile  - The output file, string
%   NType       - The type of network
%                 1: Binary
%                 2: Weighted
%   ClustAlgor  - The alogrithm to estimate clusting coefficient
%                 1: Onnela et al., 2005 
%                 2: Barrat et al., 2009
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
if ~isempty(RandNetFile)
    RandNet=load(RandNetFile);
    Rand=RandNet.Rand;
else
    Rand=[];
end
if NType==1
    Cp=cellfun(@(a) gretna_node_clustcoeff(a), A,...
        'UniformOutput', false);
    Lp=cellfun(@(a) gretna_node_shortestpathlength(a), A,...
        'UniformOutput', false);
elseif NType==2
    if ClustAlgor==2
        Cp=cellfun(@(a) gretna_node_clustcoeff_weight(a, 1), A,...
            'UniformOutput', false);
    elseif ClustAlgor==1
        Cp=cellfun(@(a) gretna_node_clustcoeff_weight(a, 2), A,...
            'UniformOutput', false);
    end
    Lp=cellfun(@(a) gretna_node_shortestpathlength_weight(a), A,...
        'UniformOutput', false);
end
Cp=cell2mat(Cp);
Lp=cell2mat(Lp);

SPath=fileparts(OutputFile);
if exist(SPath, 'dir')~=7
    mkdir(SPath);
end
save(OutputFile, 'Cp', 'Lp');

if AUCInterval>0
    deltas=AUCInterval;
    aCp= (sum(Cp)-sum(Cp([1 end]))/2)*deltas;
    aLp=(sum(Lp)-sum(Lp([1 end]))/2)*deltas;
    save(OutputFile, 'aCp', 'aLp', '-append');
end

if ~isempty(Rand)
    [Cprand, Lprand]=cellfun(@(r) RandSmallWorld(r, NType, ClustAlgor), Rand,...
        'UniformOutput', false);
    Cprand=cell2mat(Cprand);
    Lprand=cell2mat(Lprand);
    Gamma=Cp./mean(Cprand);
    Lambda=Lp./mean(Lprand);
    Sigma=Gamma./Lambda;
    save(OutputFile, 'Gamma', 'Lambda', 'Sigma', '-append');
    if AUCInterval>0
        deltas=AUCInterval;
        aGamma=(sum(Gamma)-sum(Gamma([1 end]))/2)*deltas;
        aLambda=(sum(Lambda)-sum(Lambda([1 end]))/2)*deltas;
        aSigma=(sum(Sigma)-sum(Sigma([1 end]))/2)*deltas;
        save(SWMat, 'aGamma', 'aLambda', 'aSigma', '-append');
    end
end

function [Cp, Lp]=RandSmallWorld(A, NType, ClustAlgor)
if NType==2
    if ClustAlgor==2
        Cp=cellfun(@(a) gretna_node_clustcoeff_weight(a, 1), A,...
            'UniformOutput', false);
    elseif ClustAlgor==1
        Cp=cellfun(@(a) gretna_node_clustcoeff_weight(a, 2), A,...
            'UniformOutput', false);
    end
    Lp=cellfun(@(a) gretna_node_shortestpathlength_weight(a), A,...
        'UniformOutput', false);
elseif NType==1
    Cp=cellfun(@(a) gretna_node_clustcoeff(a), A,...
        'UniformOutput', false);
    Lp=cellfun(@(a) gretna_node_shortestpathlength(a), A,...
        'UniformOutput', false);
end
Cp=cell2mat(Cp);
Lp=cell2mat(Lp);