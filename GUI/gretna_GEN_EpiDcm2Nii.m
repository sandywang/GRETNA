function Process=gretna_GEN_EpiDcm2Nii(InputFile, OutputFile)
%-------------------------------------------------------------------------%
%   Generate psom-used struct for EPI's DICOM to NIfTI
%   Input:
%   InputFile  - The input file list, 1x1 cell,to indicate the first DICOM file.
%   OutputFile - The output file list, 1x1 cell, to indicate the output
%                NIfTI file, as usual rest.nii (4D NIfTI)
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

Process.command='gretna_RUN_EpiDcm2Nii(opt.InputFile, opt.OutputFile)';
% Option 
Process.opt.InputFile=InputFile;
% Output Directory
Process.opt.OutputFile=OutputFile;
% Input Files
Process.files_in=InputFile;
% Output Files
Process.OutputImgFile=OutputFile;
Process.files_out=OutputFile;