function Process=gretna_GEN_DartelNormT1(RC1FileList, RC2FileList, C1FileList, C2FileList, C3FileList)
%-------------------------------------------------------------------------%
%   Generate psom-used struct for DARTEL Normalizing T1 Image
%   Input:
%   RC1FileList   -
%   RC2FileList   -
%   C1FileList    - All subject GM list, Sx1 cell, Nx1 cell in each cell
%   C2FileList    - All subject WM list, Sx1 cell, Nx1 cell in each cell
%   C3FileList    - All subject CSF list, Sx1 cell, Nx1 cell in each cell
%
%   Output:
%   Process       - The output process structure used by psom
%-------------------------------------------------------------------------%
%   Written by Sandy Wang (sandywang.rest@gmail.com) 20161013.
%   Copyright (C) 2013-2016
%   State Key Laboratory of Cognitive Neuroscience and Learning &
%   IDG/McGovern Institute of Brain Research, 
%   Beijing Normal University,
%   Beijing, PR China.

Process.command='gretna_RUN_DartelNormT1(opt.RC1FileList, opt.RC2FileList, opt.C1FileList, opt.C2FileList, opt.C3FileList)';

Process.opt.RC1FileList=RC1FileList;
Process.opt.RC2FileList=RC2FileList;

Process.opt.C1FileList=C1FileList;
Process.opt.C2FileList=C2FileList;
Process.opt.C3FileList=C3FileList;

Process.files_in=[RC1FileList; RC2FileList; C1FileList; C2FileList; C3FileList];

FFFileList=cellfun(@(inRC1) GenFFFile(inRC1), RC1FileList, 'UniformOutput', false);
FstSubjFile=RC1FileList{1};
[FstSubjPath, File, Ext]=fileparts(FstSubjFile);
DTFile=fullfile(FstSubjPath, ['Template_6', Ext]);
Process.FFFileList=FFFileList;
Process.DTFile=DTFile;
Process.files_out=[{DTFile}; FFFileList];

function DTFile=GenDTFile(in)
[Path, Name, Ext]=fileparts(in);
DTFile=fullfile(Path, ['Template_6', Ext]);
    
function FFFile=GenFFFile(in)
[Path, Name, Ext]=fileparts(in);
FFFile=fullfile(Path, ['u_', Name, '_Template', Ext]);