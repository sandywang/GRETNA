function gretna_RUN_CommunityIndex(InputFile, OutputFile, NType, MType, DDPcInd)
%-------------------------------------------------------------------------%
%   RUN Nodal - Community Index
%   Input:
%   InputFile   - The input file, string
%   OutputFile  - The output file, string
%   NType       - The type of network
%                 1: Binary
%                 2: Weighted
%   MType       - The algorthim of modularity
%                 1: Modified Greedy Optimization, Danon et al., 2006
%                 2: Spectral Optimization, Newman et al., 2006
%   DDPcInd     - Estimating data-driven participant coefficient
%                 1: Do
%                 2: Not Do
%-------------------------------------------------------------------------%
%   Written by Sandy Wang (sandywang.rest@gmail.com) 20161013.
%   Copyright (C) 2013-2016
%   State Key Laboratory of Cognitive Neuroscience and Learning &
%   IDG/McGovern Institute of Brain Research, 
%   Beijing Normal University,
%   Beijing, PR China.

RealNet=load(InputFile);
A=RealNet.A;

[mod_num, ci, Q]=...
    cellfun(@(a) Modularity(a, NType, MType, false), A, 'UniformOutput', false);

mod_num=cell2mat(mod_num);
ci=cell2mat(ci);
Q=cell2mat(Q);

SPath=fileparts(OutputFile);
if exist(SPath, 'dir')~=7
    mkdir(SPath);
end
save(OutputFile, 'mod_num', 'ci', 'Q');
if DDPcInd==1 % Estimate Participant Coefficient
    CIndex=num2cell(ci, 1);
    [DataDrivenPc, DataDrivenPc_normalized]=...
    cellfun(@(a, c) ParticipantCoefficient(a, c), A, CIndex, 'UniformOutput', false);

    DataDrivenPc=cell2mat(DataDrivenPc);
    DataDrivenPc_normalized=cell2mat(DataDrivenPc_normalized);
    save(OutputFile, 'DataDrivenPc', 'DataDrivenPc_normalized', '-append');
end

function [PcOriginal, PcNormalized]=ParticipantCoefficient(Matrix, Ci)
N=size(Matrix, 1);
CompIndex=Ci>0;
TmpMatrix=Matrix(CompIndex, CompIndex);

ModNum=size(unique(Ci), 1);
ModCell=cell(1, ModNum);
for m=1:ModNum
    ModCell{1, m}=find(Ci==m);
end

PcStruct=gretna_parcoeff(TmpMatrix, ModCell);
TmpPcOriginal=PcStruct.original';
TmpPcNormalized=PcStruct.normalized';

PcOriginal=zeros(N, 1);
PcOriginal(CompIndex, 1)=TmpPcOriginal;
PcNormalized=zeros(N, 1);
PcNormalized(CompIndex, 1)=TmpPcNormalized;

function [ModNum, Ci, Q]=Modularity(Matrix, NType, MType, RealFlag)
SizeOfMaxComp=[];
ModStruct=[];

N=size(Matrix, 1);
[CompIndex, Sizes]=components(sparse(Matrix));
[SizeOfMaxComp, CompPos]=max(Sizes);
CompIndex=CompIndex==CompPos;
TmpMatrix=Matrix(CompIndex, CompIndex);

if ~RealFlag
    if MType==1
        [TmpCi, Q]=gretna_modularity_Danon(TmpMatrix);
    elseif MType==2
        [TmpCi, Q]=gretna_modularity_Newman(TmpMatrix);
    end
    Ci=zeros(N, 1);
    Ci(CompIndex, 1)=TmpCi;
    ModNum=max(Ci);
    return
end


function [ModNumRand, QRand]=RandModularity(A, NType, MType)
[ModNumRand, CiRand, QRand]=cellfun(@(a) Modularity(a, NType, MType, false), A,...
    'UniformOutput', false);
ModNumRand=cell2mat(ModNumRand);
QRand=cell2mat(QRand);