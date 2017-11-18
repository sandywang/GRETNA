function gretna_RUN_ParticipantCoefficient(InputFile, OutputFile, CIndex)
%-------------------------------------------------------------------------%
%   RUN Nodal - Participant Coefficient
%   Input:
%   InputFile   - The input file, string
%   OutputFile  - The output file, string
%   CIndex      - Community Index
%
%-------------------------------------------------------------------------%
%   Written by Sandy Wang (sandywang.rest@gmail.com) 20161013.
%   Copyright (C) 2013-2016
%   State Key Laboratory of Cognitive Neuroscience and Learning &
%   IDG/McGovern Institute of Brain Research, 
%   Beijing Normal University,
%   Beijing, PR China.

RealNet=load(InputFile);
A=RealNet.A;

[CustomPc, CustomPc_normalized]=...
    cellfun(@(a) ParticipantCoefficient(a, CIndex), A, 'UniformOutput', false);

CustomPc=cell2mat(CustomPc);
CustomPc_normalized=cell2mat(CustomPc_normalized);

SPath=fileparts(OutputFile);
if exist(SPath, 'dir')~=7
    mkdir(SPath);
end
save(OutputFile, 'CustomPc', 'CustomPc_normalized');

function [PcOriginal, PcNormalized]=ParticipantCoefficient(Matrix, Ci)
Ci=Ci(:);
N=size(Matrix, 1);
CompIndex=Ci>0;
TmpCi=Ci(CompIndex);
TmpMatrix=Matrix(CompIndex, CompIndex);

ModNum=size(unique(TmpCi), 1);
ModCell=cell(1, ModNum);
for m=1:ModNum
    ModCell{1, m}=find(TmpCi==m);
end

PcStruct=gretna_parcoeff(TmpMatrix, ModCell);
TmpPcOriginal=PcStruct.original';
TmpPcNormalized=PcStruct.normalized';

PcOriginal=zeros(N, 1);
PcOriginal(CompIndex, 1)=TmpPcOriginal;
PcNormalized=zeros(N, 1);
PcNormalized(CompIndex, 1)=TmpPcNormalized;
