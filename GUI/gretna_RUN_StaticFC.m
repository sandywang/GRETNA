function gretna_RUN_StaticFC(InputFile, SubjLab, FunPath, FCAtlas, FZTInd)
%-------------------------------------------------------------------------%
%   RUN Static Functional Connectivity
%   Input:
%   InputFile  - The input file list, Nx1 cell (1x1 cell for 4D NIfTI)
%   SubjLab    - The lab of subject for outputing.
%   FunPath    - The directory of functional dataset
%   FCAtlas    - The atlas file to generate functional connectivity
%                matrix, string
%   FZTInd     - Execute Fisher's z transformation or not
%                1: Do
%                2: Do not
%-------------------------------------------------------------------------%
%   Written by Sandy Wang (sandywang.rest@gmail.com) 20161013.
%   Copyright (C) 2013-2016
%   State Key Laboratory of Cognitive Neuroscience and Learning &
%   IDG/McGovern Institute of Brain Research, 
%   Beijing Normal University,
%   Beijing, PR China.

FstFile=InputFile{1};

Nii=nifti(FstFile);
NumSli=size(Nii.dat, 3);
NumRow=size(Nii.dat, 1);
NumCol=size(Nii.dat, 2);

if numel(InputFile)==1
    TP=size(Nii.dat, 4);     
    InputCell=arrayfun(@(t) sprintf('%s,%d', InputFile{1}, t),...
        (1:TP)', 'UniformOutput', false);
else
    InputCell=InputFile;    
end
V_in=spm_vol(InputCell);

V_Atlas=spm_vol(FCAtlas);
Y_RawAtlas=spm_read_vols(V_Atlas);
Y_RawAtlas=reshape(Y_RawAtlas, [], 1);

NonZerosMsk=Y_RawAtlas~=0;
Y_Atlas=Y_RawAtlas(NonZerosMsk);
U=unique(Y_Atlas);

TC=cellfun(@(in) GetOneTP(in, NonZerosMsk, U, Y_Atlas),...
    V_in, 'UniformOutput', false);
TC=cell2mat(TC);

PPath=fileparts(FunPath);
TCPath=fullfile(PPath, 'GretnaTimeCourse');
if exist(TCPath, 'dir')~=7
    mkdir(TCPath);
end
TCFile=fullfile(TCPath, [SubjLab, '.txt']);
save(TCFile, 'TC', '-ASCII', '-DOUBLE','-TABS');    

R=corr(TC, 'type', 'Pearson');
R=(R+R')/2;%Add by Sandy
R(isnan(R))=0;
R=R-diag(diag(R));
RPrefix='r';
FCPath=fullfile(PPath, 'GretnaSFCMatrixR');
if exist(FCPath, 'dir')~=7
    mkdir(FCPath);
end
FCFile=fullfile(FCPath, [RPrefix, SubjLab, '.txt']);
save(FCFile, 'R', '-ASCII', '-DOUBLE','-TABS');

if FZTInd==1
    R(R>=1)=1-1e-16;
    Z=(0.5*log((1 + R)./(1 - R)));
    ZPrefix='z';
    
    ZFCPath=fullfile(PPath, 'GretnaSFCMatrixZ');
    if exist(ZFCPath, 'dir')~=7
        mkdir(ZFCPath);
    end
    ZFCFile=fullfile(ZFCPath, [ZPrefix, SubjLab, '.txt']);
    save(ZFCFile, 'Z', '-ASCII', '-DOUBLE','-TABS'); 
end

% Node Index
UFile=fullfile(FCPath, 'NodalIndex.txt');
if exist(UFile, 'file')~=2
    save(UFile, 'U', '-ASCII', '-DOUBLE','-TABS')
end

% Node File
[APath, AName, AExt]=fileparts(FCAtlas);
NodeFile=fullfile(FCPath, ['Example_', AName,'.node']);
if exist(NodeFile, 'file')~=2
    NodePos=zeros(numel(U), 3);
    for n=1:numel(U)
        Ind=Y_RawAtlas==U(n);
        [I, J, K]=ind2sub([NumRow, NumCol, NumSli], find(Ind));
        I=mean(I);
        J=mean(J);
        K=mean(K);
        TmpIJK=[I; J; K; 1];
        
        TmpXYZ=V_Atlas.mat*TmpIJK;
        NodePos(n, :)=TmpXYZ(1:3);
    end
    
    NodeColor=ones(numel(U), 1);
    NodeSize=ones(numel(U), 1);
    NodeLab=cell(numel(U), 1);
    NodeLab=cellfun(@ (l) '-', NodeLab, 'UniformOutput', false);
    
    gretna_gen_node_file(NodePos, NodeColor, NodeSize, NodeLab, NodeFile);
end

function ROIs=GetOneTP(in, NonZerosMsk, U, Y_Atlas)
NumR=numel(U);
ROIs=zeros(1, NumR);
Y=spm_read_vols(in);
Y=reshape(Y, [], 1);
Y=Y(NonZerosMsk);
for i=1:NumR
    ROIs(1, i)=mean(Y(Y_Atlas==U(i)));
end