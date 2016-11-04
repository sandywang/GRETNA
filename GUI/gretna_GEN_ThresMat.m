function Process=gretna_GEN_ThresMat(Mat, InputFile, OutputFile, SType, TType, Thres, NType)
%-------------------------------------------------------------------------%
%   Generate psom-used struct for Thresholding Connectivity Matrix
%   Input:
%   Mat        - The connectivity matrix, NxN array, N is the number of
%                nodes
%   InputFile  - The input file, string
%   OutputFile - The output file, string
%   SType      - The type of matrix sign
%                1: Positive
%                2: Negative
%                3: Absolute
%   TType      - The method of thresholding
%                1: Sparity
%                2: Similarity
%   Thres      - Threshold Sequence
%   NType      - The type of network
%                1: Binary
%                2: Weighted
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

Process.command='gretna_RUN_ThresMat(opt.Mat, opt.OutputFile, opt.SType, opt.TType, opt.Thres, opt.NType)';
% Option 
Process.opt.Mat=Mat;
Process.opt.OutputFile=OutputFile;
Process.opt.SType=SType;
Process.opt.TType=TType;
Process.opt.Thres=Thres;
Process.opt.NType=NType;

% Output Directory
% Input Files
Process.files_in={InputFile};
% Output Files
Process.OutputMatFile=OutputFile;
Process.files_out={OutputFile};