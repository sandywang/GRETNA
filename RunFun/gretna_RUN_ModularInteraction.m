function Process=gretna_RUN_ModularInteraction(InputFile, OutputFile, NType, CIndex)
%-------------------------------------------------------------------------%
%   RUN Modular - Interaction
%   Input:
%   InputFile   - The input file, string
%   OutputFile  - The output file, string
%   NType       - The type of network
%                 1: Binary
%                 2: Weighted
%   CIndex      - Community Index
%-------------------------------------------------------------------------%
%   Written by Sandy Wang (sandywang.rest@gmail.com) 20161013.
%   Copyright (C) 2013-2016
%   State Key Laboratory of Cognitive Neuroscience and Learning &
%   IDG/McGovern Institute of Brain Research, 
%   Beijing Normal University,
%   Beijing, PR China.

RealNet=load(InputFile);
A=RealNet.A;

ICell=cellfun(@(a) ModularInteraction(a, NType, CIndex), A, 'UniformOutput', false);

FN=fieldnames(ICell{1});
S=[];
for i=1:numel(FN)
    S.(FN{i})=cellfun(@(I) I.(FN{i}), ICell);
end

SPath=fileparts(OutputFile);
if exist(SPath, 'dir')~=7
    mkdir(SPath);
end
save(OutputFile, '-struct', 'S');

function I=ModularInteraction(Matrix, NType, Ci)
Ci=Ci(:);
N=size(Matrix, 1);
ModNum=max(Ci);
CompIndex=Ci>0;
TmpCi=Ci(CompIndex);
TmpMatrix=Matrix(CompIndex, CompIndex);

I=[];
for i=1:ModNum
    ind_i=TmpCi==i;
    WithinSubNet=TmpMatrix(ind_i, ind_i);
    if NType==1
        WithinSumEdgeNum=sum(WithinSubNet(:))./2;
        I.(sprintf('SumEdgeNum_Within_Module%.2d', i))=WithinSumEdgeNum;
    elseif NType==2
        WithinSumStrength=sum(WithinSubNet(:))./2;
        WithinB=logical(WithinSubNet);
        WithinSumEdgeNum=sum(WithinB(:))./2;
        WithinAvgStrength=WithinSumStrength./WithinSumEdgeNum;
        WithinAvgStrength(isnan(WithinAvgStrength))=0;
        I.(sprintf('SumStrength_Within_Module%.2d', i))=WithinSumStrength;
        I.(sprintf('AvgStrength_Within_Module%.2d', i))=WithinAvgStrength;    
    end
    if i~=ModNum
        for j=i+1:ModNum
            ind_j=TmpCi==j;
            BetweenSubNet=TmpMatrix(ind_i, ind_j);
            if NType==1
                BetweenSumEdgeNum=sum(BetweenSubNet(:));
                I.(sprintf('SumEdgeNum_Between_Module%.2d_%.2d', i, j))=BetweenSumEdgeNum;            
            elseif NType==2
                BetweenSumStrength=sum(BetweenSubNet(:));
                BetweenB=logical(BetweenSubNet);
                BetweenSumEdgeNum=sum(BetweenB(:));
                BetweenAvgStrength=BetweenSumStrength./BetweenSumEdgeNum;
                BetweenAvgStrength(isnan(BetweenAvgStrength))=0;
                I.(sprintf('SumStrength_Between_Module%.2d_%.2d', i, j))=BetweenSumStrength;
                I.(sprintf('AvgStrength_Between_Module%.2d_%.2d', i, j))=BetweenAvgStrength;
            end
        end
    end
end