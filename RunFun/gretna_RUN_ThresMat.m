function gretna_RUN_ThresMat(Mat, OutputFile, SType, TType, Thres, NType)
%-------------------------------------------------------------------------%
%   RUN Thresholding Connectivity Matrix
%   Input:
%   Mat        - The connectivity matrix, NxN array, N is the number of
%                nodes
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
%-------------------------------------------------------------------------%
%   Written by Sandy Wang (sandywang.rest@gmail.com) 20161013.
%   Copyright (C) 2013-2016
%   State Key Laboratory of Cognitive Neuroscience and Learning &
%   IDG/McGovern Institute of Brain Research, 
%   Beijing Normal University,
%   Beijing, PR China.

if ischar(Mat)
    Mat=load(Mat);
end

Mat=Mat-diag(diag(Mat));
if SType==1
    Mat=Mat.*(Mat>0);
elseif SType==2
    Mat=abs(Mat.*(Mat<0));
elseif SType==3
    Mat=abs(Mat);
else
    error('Error: Invalid Matrix Sign');
end

A=arrayfun(@(t) logical(gretna_R2b(Mat, TType, t)), Thres,...
    'UniformOutput', false);
if NType==2
    A=cellfun(@(bin) bin.*single(Mat), A, 'UniformOutput', false);
end
A=cellfun(@(a) a, A, 'UniformOutput', false);

SPath=fileparts(OutputFile);
if exist(SPath, 'dir')~=7
    mkdir(SPath);
end
save(OutputFile, 'A');