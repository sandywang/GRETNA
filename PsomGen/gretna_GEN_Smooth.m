function Process=gretna_GEN_Smooth(InputFile, FWHM)
%-------------------------------------------------------------------------%
%   Generate psom-used struct for Smooth
%   Input:
%   InputFile    - The input file list, Nx1 cell (1x1 cell for 4D NIfTI)
%   FWHM         - Full width at half maximum (mm), e.g., [4 4 4] 
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

Process.command='gretna_RUN_Smooth(opt.InputFile, opt.FWHM)';
OutputFile=cellfun(@(f) gretna_FUN_GetOutputFile(f, 's'), InputFile,...
    'UniformOutput', false);

% Options
Process.opt.InputFile=InputFile;
Process.opt.FWHM=FWHM;
% Input Files
Process.files_in=InputFile;
% Output Files
Process.OutputImgFile=OutputFile;
Process.files_out=OutputFile;