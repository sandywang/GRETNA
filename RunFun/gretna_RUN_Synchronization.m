function gretna_RUN_Synchronization(InputFile, RandNetFile, OutputFile, NType, AUCInterval)
%-------------------------------------------------------------------------%
%   RUN Global - Synchronization
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

s=cellfun(@(a) Synchronization(a, NType), A,...
    'UniformOutput', false);
s=cell2mat(s);

SPath=fileparts(OutputFile);
if exist(SPath, 'dir')~=7
    mkdir(SPath);
end
save(OutputFile, 's');

if AUCInterval>0
    deltas=AUCInterval;
    as= (sum(s)-sum(s([1 end]))/2)*deltas;
    save(OutputFile, 'as', '-append');
end

if ~isempty(Rand)
    srand=cellfun(@(rn) RandSynchronization(rn, NType), Rand,...
        'UniformOutput', false);
    szscore=(s-cell2mat(cellfun(@(m) Mean(m), srand, 'UniformOutput', false)))...
        ./cell2mat(cellfun(@(m) Std(m), srand, 'UniformOutput', false));
    save(OutputFile, 'szscore', '-append');
    if AUCInterval>0
        deltas=AUCInterval;
        aszscore= (sum(szscore)-sum(szscore([1 end]))/2)*deltas;
        save(OutputFile, 'aszscore', '-append');
    end    
end

function s=Synchronization(Matrix, NType)
deg=sum(Matrix);
D=diag(deg, 0);
G=D-Matrix;
Eigenvalue=sort(eig(full(G)));
        
s=Eigenvalue(2)/Eigenvalue(end);

function srand=RandSynchronization(A, NType)
srand=cellfun(@(a) Synchronization(a, NType), A,...
    'UniformOutput', false);
srand=cell2mat(srand);

function out=Mean(in)
out=mean(in(~isnan(in)));

function out=Std(in)
out=std(in(~isnan(in)));