function gretna_RUN_GANNM(SampleCell, CovCell, NumPerm, OutPath, OutPrefix)
%-------------------------------------------------------------------------%
%   Generate the Null Model of Associated Network
%   Input:
%   SampleCell  - The cell of text file or array for two groups' samples.
%                 2x1 cell
%                 For each cell, the string of text file or a SxN array
%                 N is the number of nodes S is the number of subjects and
%   CovCell     - The cell of text file or array for two groups' covariates.
%                 2x1 cell
%   NumPerm     - The number of permutation
%   OutPath     - The directory of output files
%   OutPrefix   - The prefix of output files
%-------------------------------------------------------------------------%
%   Written by Sandy Wang (sandywang.rest@gmail.com) 20170217.
%   Copyright (C) 2013-2017
%   State Key Laboratory of Cognitive Neuroscience and Learning &
%   IDG/McGovern Institute of Brain Research, 
%   Beijing Normal University,
%   Beijing, PR China.

ResCell=cell(numel(SampleCell), 1);
for i=1:numel(SampleCell)
    if ischar(SampleCell{i})
        y=load(SampleCell{i});
    else
        y=SampleCell{i};
    end
    if isempty(CovCell)
        r=y;
    else
        if ischar(CovCell{i})
            c=load(CovCell{i});
        else
            c=CovCell{i};
        end
        r=zeros(size(y));
        for n=1:size(y, 2)
            [b, one_r]=gretna_regress_ss(y(:, n), c);
            r(:, n)=one_r;
        end
    end
    ResCell{i}=r;
end
NumS12=cellfun(@length, ResCell);
NumSum=sum(NumS12);
NumS1=NumS12(1);
NumS2=NumS12(2);
Res=cell2mat(ResCell);

NetCell1=cell(NumPerm, 1);
NetCell2=cell(NumPerm, 1);

for i=1:NumPerm
    RandInd=randperm(NumSum);
    Ind1=RandInd(1:NumS1);
    Ind2=RandInd(NumS1+1:NumSum);
    Net1=corr(Res(Ind1, :));
    Net1=(Net1+Net1')/2;
    Net1(Net1>=1)=1;
    
    Net2=corr(Res(Ind2, :));
    Net2=(Net2+Net2')/2;
    Net2(Net2>=1)=1;
    
    NetCell1{i}=Net1;
    NetCell2{i}=Net2;
end

Net=NetCell1;
Out1=fullfile(OutPath, [OutPrefix, '_PermNet1.mat']);
save(Out1, 'Net');
fprintf('%s saved\n', Out1);
Net=NetCell2;
Out2=fullfile(OutPath, [OutPrefix, '_PermNet2.mat']);
save(Out2, 'Net');
fprintf('%s saved\n', Out2);
fprintf('GANNM Finished\n');