function [b_OLS_metric, t_OLS_metric, TF_ForContrast_metric, r_OLS_metric] =gretna_GroupAnalysis(DependentMatrix, Predictor, Contrast, TF_Flag)
% function y_GroupAnalysis_Image(DependentDir,Predictor,OutputName,MaskFile)
% Perform regression analysis 
% Input:
% 	DependentMatrix		-	2D data matrix (Samples*Metric)
%   Predictor - the Predictors M (subjects) by N (traits). SHOULD INCLUDE the CONSTANT column if needed. The program will not add constant column automatically.
%   Contrast [optional] - Contrast for T-test for F-test. 1*ncolX matrix.
%   TF_Flag [optional] - 'T' or 'F'. Specify if T-test or F-test need to be performed for the contrast

% Output:
%   b_OLS_metric, t_OLS_metric, TF_ForContrast_metric, r_OLS_metric
%___________________________________________________________________________
% y_GroupAnalysis_Image
% Written by YAN Chao-Gan 120823.
% The Nathan Kline Institute for Psychiatric Research, 140 Old Orangeburg Road, Orangeburg, NY 10962, USA
% Child Mind Institute, 445 Park Avenue, New York, NY 10022, USA
% The Phyllis Green and Randolph Cowen Institute for Pediatric Neuroscience, New York University Child Study Center, New York, NY 10016, USA
% ycg.yan@gmail.com
%___________________________________________________________________________
% Modified by Wang Xindi 140614 from y_GroupAnalysis_Image 
% National Key Laboratory of Cognitive Neuroscience and Learning, Beijing Normal University, China
NumOfSample=size(DependentMatrix, 1);
NumOfMetric=size(DependentMatrix, 2);

b_OLS_metric=zeros(NumOfMetric, size(Predictor,2));
t_OLS_metric=zeros(NumOfMetric, size(Predictor,2));

TF_ForContrast_metric=zeros(NumOfMetric, 1);

%YAN Chao-Gan, 130227

r_OLS_metric=zeros(NumOfMetric, NumOfSample);


fprintf('\n\tRegression Calculating...\n');
for i=1:NumOfMetric
    DependentVariable=DependentMatrix(:,i);
            
    if exist('Contrast','var') && ~isempty(Contrast)                   
        [b,r,SSE,SSR, T, TF_ForContrast] = gretna_regress_ss(DependentVariable, Predictor, Contrast, TF_Flag);
                    
        b_OLS_metric(i,:)=b;
        t_OLS_metric(i,:)=T;
        TF_ForContrast_metric(i, 1)=TF_ForContrast;                    
    else
        [b,r,SSE,SSR,T] = y_regress_ss(DependentVariable, Predictor);
                    
        b_OLS_metric(i,:)=b;
        t_OLS_metric(i,:)=T;    
    end            
    r_OLS_metric(i,:)=r;
    
    fprintf('.');
end

b_OLS_metric(isnan(b_OLS_metric))=0;
t_OLS_metric(isnan(t_OLS_metric))=0;
TF_ForContrast_metric(isnan(TF_ForContrast_metric))=0;

fprintf('\n\tRegression Calculation finished.\n');
