function [TTest2_T, TTest2_P] = gretna_TTest2(DependentFiles, Covariates)
% TTest1_T = gretna_TTest1(DependentDirs, OutputName, OtherCovariates, Base)
% Perform two sample t test.
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

GroupNumber=length(DependentFiles);
GroupLabel=[];

DependentMatrix=[];
CovariatesMatrix=[];

for i=1:GroupNumber
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
    
    GroupLabel=cat(1, GroupLabel, ones(size(Matrix, 1), 1)*i);
end

GroupLabel(GroupLabel==2)=-1;

NumOfSample=size(DependentMatrix, 1);

Regressors=[GroupLabel, ones(NumOfSample, 1), CovariatesMatrix];

Contrast=zeros(1, size(Regressors, 2));
Contrast(1)=1;

[b_OLS_metric, t_OLS_metric, TTest2_T, r_OLS_metric] = gretna_GroupAnalysis(DependentMatrix, Regressors, Contrast, 'T');

DOF=NumOfSample-size(Regressors, 2);
TTest2_P=2*(1-tcdf(TTest2_T, DOF));

fprintf('\n\tTwo Sample T Test Calculation finished.\n');