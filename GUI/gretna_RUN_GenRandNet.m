function gretna_RUN_GenRandNet(InputFile, OutputFile, NType, RandNum)
%-------------------------------------------------------------------------%
%   RUN Generating Random Networks
%   Input:
%   InputFile  - The input file, string
%   OutputFile - The output file, string
%   NType      - The type of network
%                1: Binary
%                2: Weighted
%   RandNum    - The number of random network
%-------------------------------------------------------------------------%
%   Written by Sandy Wang (sandywang.rest@gmail.com) 20161013.
%   Copyright (C) 2013-2016
%   State Key Laboratory of Cognitive Neuroscience and Learning &
%   IDG/McGovern Institute of Brain Research, 
%   Beijing Normal University,
%   Beijing, PR China.

RealNetS=load(InputFile);
A=RealNetS.A;
Rand=cellfun(@(a) GenerateRandCell(a, NType, RandNum), A,...
    'UniformOutput', false);

SPath=fileparts(OutputFile);
if exist(SPath, 'dir')~=7
    mkdir(SPath);
end

save(OutputFile, 'Rand', '-v7.3'); %Fixed a bug when Rand Mat were huge!

function Rand=GenerateRandCell(A, NType, RandNum)
RType='1';
Rand=cell(RandNum, 1);
if NType==1
    if strcmpi(RType, '1')
        Rand=cellfun(@(r) sparse(gretna_gen_random_network1(A)), Rand,...
            'UniformOutput', false);
    elseif strcmpi(RType, '2')
        Rand=cellfun(@(r) sparse(gretna_gen_random_network2(A)), Rand,...
            'UniformOutput', false);
    end
elseif NType==2
    if strcmpi(RType, '1')
        Rand=cellfun(@(r) sparse(gretna_gen_random_network1_weight(A)), Rand,...
            'UniformOutput', false);
    elseif strcmpi(RType, '2')
        Rand=cellfun(@(r) sparse(gretna_gen_random_network2_weight(A)), Rand,...
            'UniformOutput', false);
    end
end