function [TTest1_T, TTest1_P] = gretna_TTestPaired(DependentFiles, Covariates)
% TTest1_T = gretna_TTestPaired(DependentDirs, OutputName, OtherCovariates, Base)
% Perform paired sample t test.
% Input:
%   DependentFiles - the metric file of dependent variable. 1 by 1 cell
%   OutputName - the output name.
%   Covariates - The other covariates. 1 by 1 cell 
% Output:
%   TTest1_T - the T value, also write image file out indicated by OutputName
%___________________________________________________________________________
% Written by Wang Xindi 140615.
% State Key Laboratory of Cognitive Neuroscience and Learning, Beijing Normal University, China
% Modified from y_TTest2_Image in DPABI.

DependentMatrix=[];
CovariatesMatrix=[];

for i=1:2
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

NumOfSample=size(DependentMatrix, 1);
NumOfSub=NumOfSample/2;

Regressors = [ones(NumOfSub,1);-1*ones(NumOfSub,1)];

SubjectRegressors=zeros(NumOfSample, NumOfSub);
for i=1:NumOfSub
    SubjectRegressors(i:NumOfSub:NumOfSample,i) = 1;
end

Regressors = [Regressors,SubjectRegressors,CovariatesMatrix];

Contrast=zeros(1, size(Regressors, 2));
Contrast(1)=1;

[b_OLS_metric, t_OLS_metric, TTest1_T, r_OLS_metric] = gretna_GroupAnalysis(DependentMatrix, Regressors, Contrast, 'T');

DOF=NumOfSample-size(Regressors, 2);
TTest1_P=2*(1-tcdf(TTest1_T, DOF));

fprintf('\n\tPaired T Test Calculation finished.\n');