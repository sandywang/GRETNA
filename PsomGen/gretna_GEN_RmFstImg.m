function Process=gretna_GEN_RmFstImg(InputFile, DelImg)
%-------------------------------------------------------------------------%
%   Generate psom-used struct for Remove First Images
%   Input:
%   InputFile  - The input file list, 1x1 cell,to indicate the first DICOM file.
%   DelImg     - The number of time points should be removed
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

Process.command='gretna_RUN_RmFstImg(opt.InputFile, opt.DelImg)';
OutputFile=cellfun(@(f) gretna_FUN_GetOutputFile(f, 'n'), InputFile,...
    'UniformOutput', false);

% Options
Process.opt.InputFile=InputFile;
Process.opt.DelImg=DelImg;
% Input Files
Process.files_in=InputFile;
% Output Files
Process.OutputImgFile=OutputFile;
Process.files_out=OutputFile;
