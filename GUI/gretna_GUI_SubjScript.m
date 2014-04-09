function gretna_GUI_SubjScript(Subj, Alias, TempDir)
if ischar(Subj)
    Matrix=load(Subj);
else
    Matrix=Subj;
end

%Network Type
NType='w';

%Threshold List
Thres='0.05:0.01:0.4';
%Threshold Type
TType='s';

TempDir=fullfile(TempDir, Alias);
if exist(TempDir, 'dir')~=7
    mkdir(TempDir);
end
SegMat=fullfile(TempDir, 'SegMat.mat');

%Pos or Abs Raw Matrix
PType='a';

%Methods to Generate Random Network
RType='1';
%Number of Random Networks
RandNum=100;
%Random Network Data
RandMat=fullfile(TempDir, 'RandMat.mat');

%For weighted Network, Method for clustercoeff
SType='2';
%Modularity Type
MType='2';%Newman

%Begin
% gretna_GUI_SegmentThres(Matrix, PType, NType, TType, Thres, TempDir);
% fprintf('%s: Segment Thresholds -> Finished.\n', Alias);
% gretna_GUI_GenerateRandNet(SegMat, NType, RType, RandNum, TempDir);
% fprintf('%s: Generate Random Networks -> Finished.\n', Alias);
% gretna_GUI_SmallWorld(SegMat, RandMat, SType, NType, Thres, TempDir);
% fprintf('%s: Network - Small World -> Finished.\n', Alias);
% gretna_GUI_Efficiency(SegMat, RandMat, NType, Thres, TempDir);
% fprintf('%s: Network - Efficiency -> Finished.\n', Alias);
% gretna_GUI_Assortativity(SegMat, RandMat, NType, TempDir);
% fprintf('%s: Network - Assortativity -> Finished.\n', Alias);
% gretna_GUI_Hierarchy(SegMat, RandMat, NType, TempDir);
% fprintf('%s: Network - Hierarchy -> Finished.\n', Alias);
% gretna_GUI_Synchronization(SegMat, RandMat, TempDir);
% fprintf('%s: Network - Synchronization -> Finished.\n', Alias);
gretna_GUI_Modularity(SegMat, RandMat, MType, TempDir);
fprintf('%s: Network - Modularity -> Finished.\n', Alias);
gretna_GUI_NodeDegree(SegMat, NType, Thres, TempDir);
fprintf('%s: Node - Degree -> Finished.\n', Alias);
gretna_GUI_NodeEfficiency(SegMat, NType, Thres, TempDir);
fprintf('%s: Node - Efficiency -> Finished.\n', Alias);
gretna_GUI_NodeBetweenness(SegMat, NType, Thres, TempDir);
fprintf('%s: Node - Betweenness -> Finished.\n', Alias);
%End