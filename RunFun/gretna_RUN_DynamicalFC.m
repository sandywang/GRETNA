function Process=gretna_RUN_DynamicalFC(InputFile, SubjLab, FunPath, FCAtlas, FZTInd, SWL, SWS)
%-------------------------------------------------------------------------%
%   RUN Dynamical Functional Connectivity
%   Input:
%   InputFile  - The input file list, Nx1 cell (1x1 cell for 4D NIfTI)
%   SubjLab    - The lab of subject for outputing.
%   FunPath    - The directory of functional dataset
%   FCAtlas    - The atlas file to generate functional connectivity
%                matrix, string
%   FZTInd     - Execute Fisher's z transformation or not
%                1: Do
%                2: Do not
%   SWL        - Sliding window length (time point)
%   SWS        - Sliding window step (time point)
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

PPath=fileparts(FunPath);
TCFile=fullfile(PPath, 'GretnaTimeCourse', [SubjLab, '.txt']);
if exist(TCFile, 'file')~=2
    gretna_RUN_StaticFC(InputFile, SubjLab, FunPath, FCAtlas, FZTInd)
end

TC=load(TCFile);
TP=size(TC, 1);
DRStruct=[];
if FZTInd==1 % Fisher's Z
    DZStruct=[];
end
for s=1:floor((TP-SWL)/SWS)+1
    First=(s-1)*SWS+1;
    Last=(s-1)*SWS+SWL;
    WinInd=(First:Last)';
    Tag=sprintf('W_%.4d_%.4d', First, Last);
    DTC=TC(WinInd, :);
    DR=corr(DTC, 'type', 'Pearson');
    DR=(DR+DR')/2;%Add by Sandy
    DR(isnan(DR))=0;
    DRStruct.(Tag)=DR;
    if FZTInd==1
        DR(DR>=1)=1-1e-16;
        DZ=(0.5 * log((1 + DR)./(1 - DR)));
            
        DZStruct.(Tag)=DZ;
    end
end

% Save
DRFCPath=fullfile(PPath, 'GretnaDFCMatrixR');
if exist(DRFCPath, 'dir')~=7
    mkdir(DRFCPath);
end
DRFCFile=fullfile(DRFCPath, ['r', SubjLab, '.mat']);
save(DRFCFile, 'DRStruct');

if FZTInd==1
    DZFCPath=fullfile(PPath, 'GretnaDFCMatrixZ');
    if exist(DZFCPath, 'dir')~=7
        mkdir(DZFCPath);
    end
    DZFCFile=fullfile(DZFCPath, ['z', SubjLab, '.mat']);
    save(DZFCFile, 'DZStruct');    
end