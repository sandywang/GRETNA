function Process=gretna_GEN_ChkNorm(NormSoFile, SubjLab, FunPath)
%-------------------------------------------------------------------------%
%   Generate psom-used struct for Check Normalization
%   Input:
%   NormSoFile  - The normalized source image, 1x1 cell (1x1 cell for 4D NIfTI)
%   SubjLab    - The lab of subject for outputing.
%   FunPath    - The directory of functional dataset
%
%   Output:
%   Process    - The output process structure used by psom
%-------------------------------------------------------------------------%
%   Written by Sandy Wang (sandywang.rest@gmail.com) 20161013.
%   Copyright (C) 2013-2016
%   State Key Laboratory of Cognitive Neuroscience and Learning &
%   IDG/McGovern Institute of Brain Research, 
%   Beijing Normal University,
%   Beijing, PR China.

Process.command='gretna_RUN_ChkNorm(opt.NormSoFile, opt.SubjLab, opt.FunPath)';

% Options
Process.opt.NormSoFile=NormSoFile;
Process.opt.SubjLab=SubjLab;
Process.opt.FunPath=FunPath;
% Input Files
Process.files_in=NormSoFile;
% Output Files
PPath=fileparts(FunPath);
SubjLab=strrep(SubjLab, filesep, '_');
SubjLab=strrep(SubjLab, '.nii', '');

TIFFile={fullfile(PPath, 'GretnaLogs', 'NormalizationInfo',...
    ['NormChk_', SubjLab, '.tif'])};
Process.files_out=TIFFile;
