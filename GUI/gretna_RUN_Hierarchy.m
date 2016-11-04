function gretna_RUN_Hierarchy(InputFile, RandNetFile, OutputFile, NType)
%-------------------------------------------------------------------------%
%   RUN Global - Hierarchy
%   Input:
%   InputFile   - The input file, string
%   RandNetFile - The random network file, string
%   OutputFile  - The output file, string
%   NType       - The type of network
%                 1: Binary
%                 2: Weighted
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

b=cellfun(@(a) Hierarchy(a, NType), A,...
    'UniformOutput', false);
b=cell2mat(b);

SPath=fileparts(OutputFile);
if exist(SPath, 'dir')~=7
    mkdir(SPath);
end
save(OutputFile, 'b');

if ~isempty(Rand)
    brand=cellfun(@(rn) RandHierarchy(rn, NType), Rand,...
        'UniformOutput', false);
    bzscore=(b-cell2mat(cellfun(@(m) Mean(m), brand, 'UniformOutput', false)))...
        ./cell2mat(cellfun(@(m) Std(m), brand, 'UniformOutput', false));
    save(OutputFile, 'bzscore', '-append');
end

function b=Hierarchy(Matrix, NType)
if NType==1
    [deg, ki]=gretna_node_degree(Matrix);
    [Cp, nodalCp]=gretna_node_clustcoeff(Matrix);
elseif NType==2
    [deg, ki]=gretna_node_degree_weight(Matrix);
    [Cp, nodalCp]=gretna_node_clustcoeff_weight(Matrix, 2);   
end

if all(nodalCp == 0) || all(ki == 0)
    b=nan;
else
    index1=find(ki==0);
    index2=find(nodalCp==0);
    ki([index1 index2]) = [];
    nodalCp([index1 index2]) = [];

    stats=regstats(log(nodalCp),log(ki),'linear','beta');
    b=-stats.beta(2);
end     

function brand=RandHierarchy(A, NType)
brand=cellfun(@(a) Hierarchy(a, NType), A,...
    'UniformOutput', false);
brand=cell2mat(brand);

function out=Mean(in)
out=mean(in(~isnan(in)));

function out=Std(in)
out=std(in(~isnan(in)));