function Process=gretna_GEN_RegressOut(InputFile, GSMsk, WMMsk, CSFMsk, HMInd, HMFile)
%-------------------------------------------------------------------------%
%   Generate psom-used struct for Regress Out Covariates
%   Input:
%   InputFile    - The input file list, Nx1 cell (1x1 cell for 4D NIfTI)
%   GSMsk        - The mask to extract global signal, skip if empty
%   WMMsk        - The mask to extract white matter signal, skip if empty
%   CSFMsk       - The mask to extract csf signal, skip if empty
%   HMInd        - The head motion regression index
%                  1: Origin - 6 parameter
%                  2: Origin+Relative - 12 parameter
%                  3: Krison - 24 parameter
%   HMFile       - Head Motion Parameter File, 1x1 cell and [] if HMInd==0
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

Process.command='gretna_RUN_RegressOut(opt.InputFile, opt.GSMsk, opt.WMMsk, opt.CSFMsk, opt.HMInd, opt.HMFile)';
if ~isempty(GSMsk)
    OutputFile=cellfun(@(f) gretna_FUN_GetOutputFile(f, 'cWGS'), InputFile,...
        'UniformOutput', false);
else
    OutputFile=cellfun(@(f) gretna_FUN_GetOutputFile(f, 'cNGS'), InputFile,...
        'UniformOutput', false);    
end

% Options
Process.opt.InputFile=InputFile;
Process.opt.GSMsk=GSMsk;
Process.opt.WMMsk=WMMsk;
Process.opt.CSFMsk=CSFMsk;
Process.opt.HMInd=HMInd;
Process.opt.HMFile=HMFile;

% Input Files
Process.files_in=[InputFile; HMFile];
% Output Files
Process.OutputImgFile=OutputFile;
Process.files_out=OutputFile;