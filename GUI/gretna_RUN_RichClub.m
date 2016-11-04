function gretna_RUN_RichClub(InputFile, RandNetFile, OutputFile, NType)
%-------------------------------------------------------------------------%
%   RUN Global - RichClub
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

if NType==1
    phi_real=cellfun(@(a) gretna_rich_club(a), A,...
        'UniformOutput', false);
elseif NType==2
    phi_real=cellfun(@(a) gretna_rich_club_weight(a), A,...
        'UniformOutput', false);
end
phi_real=cell2mat(phi_real')';

SPath=fileparts(OutputFile);
if exist(SPath, 'dir')~=7
    mkdir(SPath);
end
save(OutputFile, 'phi_real');

if ~isempty(Rand)
    % Overall phi from random networks
    phi_rand=cellfun(@(r) RandRichClub(r, NType), Rand,...
        'UniformOutput', false);
    phi_rand=cell2mat(phi_rand')';
    phi_norm=phi_real./phi_rand;
    save(OutputFile, 'phi_norm', '-append');
end

function phi=RandRichClub(A, NType)
if NType==1
    phi=cellfun(@(a) gretna_rich_club(a), A,...
        'UniformOutput', false);
elseif NType==2
    phi=cellfun(@(a) gretna_rich_club_weight(a), A,...
        'UniformOutput', false);
end
phi=cell2mat(phi);
phi=mean(phi);