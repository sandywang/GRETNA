function gretna_RUN_Assortativity(InputFile, RandNetFile, OutputFile, NType, AUCInterval)
%-------------------------------------------------------------------------%
%   RUN Global - Assortativity
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

r=cellfun(@(a) Assortativity(a, NType), A,...
    'UniformOutput', false);
r=cell2mat(r);

SPath=fileparts(OutputFile);
if exist(SPath, 'dir')~=7
    mkdir(SPath);
end
save(OutputFile, 'r');
if AUCInterval>0
    deltas=AUCInterval;
    ar= (sum(r)-sum(r([1 end]))/2)*deltas;
    save(OutputFile, 'ar', '-append');
end

if ~isempty(Rand)
    rrand=cellfun(@(rn) RandAssortativity(rn, NType), Rand,...
        'UniformOutput', false);
    rzscore=(r-cell2mat(cellfun(@(m) Mean(m), rrand, 'UniformOutput', false)))...
        ./cell2mat(cellfun(@(m) Std(m), rrand, 'UniformOutput', false));
    save(OutputFile, 'rzscore', '-append');
    if AUCInterval>0
        deltas=AUCInterval;
        arzscore= (sum(rzscore)-sum(rzscore([1 end]))/2)*deltas;
        save(OutputFile, 'arzscore', '-append');
    end
end

function r=Assortativity(Matrix, NType)
if NType==1
	deg=sum(Matrix);
    K=sum(deg)/2;
    [i, j]=find(triu(Matrix, 1));
    if issparse(deg)
        degi=spfun(@(ii) deg(ii), i);
        degj=spfun(@(jj) deg(jj), j);
    else
        degi=arrayfun(@(ii) deg(ii), i);
        degj=arrayfun(@(jj) deg(jj), j);
    end                     

    r=((sum(degi.*degj)/K - (sum(0.5*(degi+degj))/K)^2)...
        /(sum(0.5*(degi.^2+degj.^2))/K - (sum(0.5*(degi+degj))/K)^2));
elseif NType==2
    H=sum(sum(Matrix))/2;
    Mat=Matrix;
    Mat(Mat~=0) = 1;
    deg=sum(Mat);
    [i, j, v] = find(triu(Matrix, 1));
    if issparse(deg)
        degi=spfun(@(ii) deg(ii), i);
        degj=spfun(@(jj) deg(jj), j);
    else
        degi=arrayfun(@(ii) deg(ii), i);
        degj=arrayfun(@(jj) deg(jj), j);
    end

    r=((sum(v.*degi.*degj)/H - (sum(0.5*(v.*(degi+degj)))/H)^2)...
        /(sum(0.5*(v.*(degi.^2+degj.^2)))/H - (sum(0.5*(v.*(degi+degj)))/H)^2));
else
end

function rrand=RandAssortativity(A, NType)
rrand=cellfun(@(a) Assortativity(a, NType), A,...
    'UniformOutput', false);
rrand=cell2mat(rrand);

function out=Mean(in)
out=mean(in(~isnan(in)));

function out=Std(in)
out=std(in(~isnan(in)));