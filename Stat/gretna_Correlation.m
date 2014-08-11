function [Corr_R, Corr_P]=gretna_Correlation(DependentFiles, SeedSeries, Covariates)
% [rCorr,pCorr,Header]=y_Correlation_Image(DependentDir,SeedSeries,OutputName,MaskFile,CovariateDir,OtherCovariate)
% Perform correlation analysis with or without covariate.
% Input:
%   DependentFiles - the image directory of the group. 1 by 1 cell
%   SeedSeries - the seed series
%   Covariates - The covariate. 1 by 1 cell
% Output:
%   Corr_R - Pearson's Correlation Coefficient or partial correlation coeffcient, also write image file out indicated by OutputName
%___________________________________________________________________________
% Written by Wang Xindi 140615.
% State Key Laboratory of Cognitive Neuroscience and Learning, Beijing Normal University, China, 100875
%___________________________________________________________________________
% Modified from DPABI's y_TTest1_Image
% Written by YAN Chao-Gan 100411.
% State Key Laboratory of Cognitive Neuroscience and Learning, Beijing Normal University, China, 100875
% Core function re-written by YAN Chao-Gan 14011.
% The Nathan Kline Institute for Psychiatric Research, 140 Old Orangeburg Road, Orangeburg, NY 10962, USA
% Child Mind Institute, 445 Park Avenue, New York, NY 10022, USA
% The Phyllis Green and Randolph Cowen Institute for Pediatric Neuroscience, New York University Child Study Center, New York, NY 10016, USA
% ycg.yan@gmail.com


DependentMatrix=[];
CovariatesMatrix=[];
for i=1:1
    if ischar(DependentFiles{i})
        Matrix=load(DependentFiles{i});
        fprintf('\n\tGroup %.1d: Load File %s:\n', i, DependentFiles{i});        
    else
        Matrix=DependentFiles{i};
    end
    DependentMatrix=cat(1, DependentMatrix, Matrix);
    
    if exist('Covariates','var') && ~isempty(Covariates)
        CovariatesMatrix=cat(1, CovariatesMatrix, Covariates{i});
    end
end

[NumOfSample, NumOfMetric]=size(DependentMatrix);

Regressors = ones(NumOfSample, 1);
Regressors = [SeedSeries, Regressors, CovariatesMatrix];


Contrast = zeros(1,size(Regressors,2));
Contrast(1) = 1;

[b_OLS_brain, t_OLS_brain, TTest1_T, r_OLS_brain] = gretna_GroupAnalysis(DependentMatrix, Regressors, Contrast, 'T');

DOF=NumOfSample-size(Regressors, 2);

Corr_R=TTest1_T./(sqrt(Df_E+TTest1_T.*TTest1_T));
%r = t./(sqrt(Df_E+t.*t))
Corr_P=2*(1-tcdf(abs(TTest1_T), DOF));

fprintf('\n\tCorrelation Calculation finished.\n');