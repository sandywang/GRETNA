function gretna_RUN_GEfficiency(InputFile, RandNetFile, OutputFile, NType, AUCInterval)
%-------------------------------------------------------------------------%
%   RUN Global - Efficiency
%   Input:
%   InputFile   - The input file, string
%   RandNetFile - The random network file, string
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
if ~isempty(RandNetFile)
    RandNet=load(RandNetFile);
    Rand=RandNet.Rand;
else
    Rand=[];
end

if NType==1
    Eloc=cellfun(@(a) gretna_node_local_efficiency(a), A,...
        'UniformOutput', false);
    Eg=cellfun(@(a) gretna_node_global_efficiency(a), A,...
        'UniformOutput', false);
elseif NType==2
    Eloc=cellfun(@(a) gretna_node_local_efficiency_weight(a), A,...
        'UniformOutput', false);
    Eg=cellfun(@(a) gretna_node_global_efficiency_weight(a), A,...
        'UniformOutput', false);
end
Eloc=cell2mat(Eloc);
Eg=cell2mat(Eg);


SPath=fileparts(OutputFile);
if exist(SPath, 'dir')~=7
    mkdir(SPath);
end
save(OutputFile, 'Eloc', 'Eg');

if AUCInterval>0
    deltas=AUCInterval;
    aEloc= (sum(Eloc)-sum(Eloc([1 end]))/2)*deltas;
    aEg=(sum(Eg)-sum(Eg([1 end]))/2)*deltas;
    save(OutputFile, 'aEloc', 'aEg', '-append');
end

if ~isempty(Rand)
    [Elocrand, Egrand]=cellfun(@(r) RandEfficiency(r, NType), Rand,...
        'UniformOutput', false);
    Elocrand=cell2mat(Elocrand);
    Egrand=cell2mat(Egrand);
    EGamma=Eloc./mean(Elocrand);
    ELambda=Eg./mean(Egrand);
    ESigma=EGamma./ELambda;
    save(OutputFile, 'EGamma', 'ELambda', 'ESigma', '-append');
    if AUCInterval>0
        deltas=AUCInterval;
        aEGamma=(sum(EGamma)-sum(EGamma([1 end]))/2)*deltas;
        aELambda=(sum(ELambda)-sum(ELambda([1 end]))/2)*deltas;
        aESigma=(sum(ESigma)-sum(ESigma([1 end]))/2)*deltas;
        save(OutputFile, 'aEGamma', 'aELambda', 'aESigma', '-append');
    end
end

function [Eloc, Eg]=RandEfficiency(A, NType)
if NType==1
    Eloc=cellfun(@(a) gretna_node_local_efficiency(a), A,...
        'UniformOutput', false);
    Eg=cellfun(@(a) gretna_node_global_efficiency(a), A,...
        'UniformOutput', false);
elseif NType==2
    Eloc=cellfun(@(a) gretna_node_local_efficiency_weight(a), A,...
        'UniformOutput', false);
    Eg=cellfun(@(a) gretna_node_global_efficiency_weight(a), A,...
        'UniformOutput', false);
end
Eloc=cell2mat(Eloc);
Eg=cell2mat(Eg);