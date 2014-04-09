function Pipeline = gretna_GUI_NetworkMetricPipe(Matrix,...
    Para, CalList, SubjName, OutputDir,...
    Pipeline)

%Temporary Directory
TempDir=fullfile(OutputDir, 'GretnaNetworkResults', SubjName);

%% Segment Thresholds' Network
if strcmp(Para.NetType , 'weighted')
    NType='w';
else
    NType='b';
end

Thres=Para.ThresRegion;
if strcmpi(Para.ThresType , 'correlation coefficient')
    TType='r';
elseif strcmpi(Para.ThresType, 'sparsity')
    TType='s';
end

if strcmpi(Para.CutType, 'positive')
    PType='p';
elseif strcmpi(Para.CutType, 'absolute')
    PType='a';
end
command='gretna_GUI_SegmentThres(opt.Matrix, opt.PType, opt.NType, opt.TType, opt.Thres, opt.TempDir)';
Pipeline.(sprintf('%s_SegmentThres', SubjName)).command=command;
Pipeline.(sprintf('%s_SegmentThres', SubjName)).opt.Matrix=Matrix;
Pipeline.(sprintf('%s_SegmentThres', SubjName)).opt.PType=PType;
Pipeline.(sprintf('%s_SegmentThres', SubjName)).opt.NType=NType;
Pipeline.(sprintf('%s_SegmentThres', SubjName)).opt.TType=TType;
Pipeline.(sprintf('%s_SegmentThres', SubjName)).opt.Thres=Thres;
Pipeline.(sprintf('%s_SegmentThres', SubjName)).opt.TempDir=TempDir;
%In
if ischar(Matrix)
    Pipeline.(sprintf('%s_SegmentThres', SubjName)).files_in={Matrix};
else
    Pipeline.(sprintf('%s_SegmentThres', SubjName)).files_in={};
end
%Out
SegMat=fullfile(TempDir, 'SegMat.mat');
Pipeline.(sprintf('%s_SegmentThres', SubjName)).files_out={SegMat};

%% Genegrate Random Network
RandNum=Para.NumRandNet;
RType='1';
if (any(strcmpi(CalList , 'Network - Small World')) || ...
    any(strcmpi(CalList , 'Network - Efficiency')) || ...
    any(strcmpi(CalList , 'Network - Modularity')) || ...
    any(strcmpi(CalList , 'Network - Assortativity')) || ...
    any(strcmpi(CalList , 'Network - Hierarchy')) || ...
    any(strcmpi(CalList , 'Network - Synchronization'))) && ...
    RandNum~=0
    command='gretna_GUI_GenerateRandNet(opt.SegMat, opt.NType, opt.RType, opt.RandNum, opt.TempDir)';
    Pipeline.(sprintf('%s_GenerateRandNet', SubjName)).command=command;
    Pipeline.(sprintf('%s_GenerateRandNet', SubjName)).opt.SegMat=SegMat;
    Pipeline.(sprintf('%s_GenerateRandNet', SubjName)).opt.NType=NType;
    Pipeline.(sprintf('%s_GenerateRandNet', SubjName)).opt.RType=RType;
    Pipeline.(sprintf('%s_GenerateRandNet', SubjName)).opt.RandNum=RandNum;
    Pipeline.(sprintf('%s_GenerateRandNet', SubjName)).opt.TempDir=TempDir;
    %In
    Pipeline.(sprintf('%s_GenerateRandNet', SubjName)).files_in={SegMat};
    %Out
    RandMat=fullfile(TempDir, 'RandMat.mat');
    Pipeline.(sprintf('%s_GenerateRandNet', SubjName)).files_out={RandMat};
else
    RandMat='';
end

%% Network - Small World
if any(strcmpi(CalList, 'Network - Small World'))
    if strcmpi(Para.ClustCoeffAlorithm, 'barrat')
        SType='1';
    elseif strcmpi(Para.ClustCoeffAlorithm, 'onnela')
        SType='2';
    end
    command='gretna_GUI_SmallWorld(opt.SegMat, opt.RandMat, opt.SType, opt.NType, opt.Thres, opt.TempDir)';
    Pipeline.(sprintf('%s_SmallWorld', SubjName)).command=command;
    Pipeline.(sprintf('%s_SmallWorld', SubjName)).opt.SegMat=SegMat;
    Pipeline.(sprintf('%s_SmallWorld', SubjName)).opt.RandMat=RandMat;
    Pipeline.(sprintf('%s_SmallWorld', SubjName)).opt.SType=SType;
    Pipeline.(sprintf('%s_SmallWorld', SubjName)).opt.NType=NType;
    Pipeline.(sprintf('%s_SmallWorld', SubjName)).opt.Thres=Thres;
    Pipeline.(sprintf('%s_SmallWorld', SubjName)).opt.TempDir=TempDir;
    %In
    if isempty(RandMat)
        Pipeline.(sprintf('%s_SmallWorld', SubjName)).files_in={SegMat};
    else
        Pipeline.(sprintf('%s_SmallWorld', SubjName)).files_in=[{SegMat};{RandMat}];
    end
    %Out
    SWMat=fullfile(TempDir, 'SWMat.mat');
    Pipeline.(sprintf('%s_SmallWorld', SubjName)).files_out={SWMat};
end

%% Network - Efficiency
if any(strcmpi(CalList, 'Network - Efficiency'))
    command='gretna_GUI_Efficiency(opt.SegMat, opt.RandMat, opt.NType, opt.Thres, opt.TempDir)';
    Pipeline.(sprintf('%s_Efficiency', SubjName)).command=command;
    Pipeline.(sprintf('%s_Efficiency', SubjName)).opt.SegMat=SegMat;
    Pipeline.(sprintf('%s_Efficiency', SubjName)).opt.RandMat=RandMat;
    Pipeline.(sprintf('%s_Efficiency', SubjName)).opt.NType=NType;
    Pipeline.(sprintf('%s_Efficiency', SubjName)).opt.Thres=Thres;
    Pipeline.(sprintf('%s_Efficiency', SubjName)).opt.TempDir=TempDir;
    %In
    if isempty(RandMat)
        Pipeline.(sprintf('%s_Efficiency', SubjName)).files_in={SegMat};
    else
        Pipeline.(sprintf('%s_Efficiency', SubjName)).files_in=[{SegMat};{RandMat}];
    end
    %Out
    EFFMat=fullfile(TempDir, 'EFFMat.mat');
    Pipeline.(sprintf('%s_Efficiency', SubjName)).files_out={EFFMat};
end

%% Network - Assortativity
if any(strcmpi(CalList, 'Network - Assortativity'))
    command='gretna_GUI_Assortativity(opt.SegMat, opt.RandMat, opt.NType, opt.TempDir)';
    Pipeline.(sprintf('%s_Assortativity', SubjName)).command=command;
    Pipeline.(sprintf('%s_Assortativity', SubjName)).opt.SegMat=SegMat;
    Pipeline.(sprintf('%s_Assortativity', SubjName)).opt.RandMat=RandMat;
    Pipeline.(sprintf('%s_Assortativity', SubjName)).opt.NType=NType;
    Pipeline.(sprintf('%s_Assortativity', SubjName)).opt.TempDir=TempDir;
    %In
    if isempty(RandMat)
        Pipeline.(sprintf('%s_Assortativity', SubjName)).files_in={SegMat};
    else
        Pipeline.(sprintf('%s_Assortativity', SubjName)).files_in=[{SegMat};{RandMat}];
    end
    %Out
    ASSMat=fullfile(TempDir, 'ASSMat.mat');
    Pipeline.(sprintf('%s_Assortativity', SubjName)).files_out={ASSMat};
end

%% Network - Hierarchy
if any(strcmpi(CalList, 'Network - Hierarchy'))
    command='gretna_GUI_Hierarchy(opt.SegMat, opt.RandMat, opt.NType, opt.TempDir)';
    Pipeline.(sprintf('%s_Hierarchy', SubjName)).command=command;
    Pipeline.(sprintf('%s_Hierarchy', SubjName)).opt.SegMat=SegMat;
    Pipeline.(sprintf('%s_Hierarchy', SubjName)).opt.RandMat=RandMat;
    Pipeline.(sprintf('%s_Hierarchy', SubjName)).opt.NType=NType;
    Pipeline.(sprintf('%s_Hierarchy', SubjName)).opt.TempDir=TempDir;
    %In
    if isempty(RandMat)
        Pipeline.(sprintf('%s_Hierarchy', SubjName)).files_in={SegMat};
    else
        Pipeline.(sprintf('%s_Hierarchy', SubjName)).files_in=[{SegMat};{RandMat}];
    end
    %Out
    HIEMat=fullfile(TempDir, 'HIEMat.mat');
    Pipeline.(sprintf('%s_Hierarchy', SubjName)).files_out={HIEMat};
end

%% Network - Synchronization
if any(strcmpi(CalList, 'Network - Synchronization'))
    command='gretna_GUI_Synchronization(opt.SegMat, opt.RandMat, opt.TempDir)';
    Pipeline.(sprintf('%s_Synchronization', SubjName)).command=command;
    Pipeline.(sprintf('%s_Synchronization', SubjName)).opt.SegMat=SegMat;
    Pipeline.(sprintf('%s_Synchronization', SubjName)).opt.RandMat=RandMat;
    Pipeline.(sprintf('%s_Synchronization', SubjName)).opt.TempDir=TempDir;
    %In
    if isempty(RandMat)
        Pipeline.(sprintf('%s_Synchronization', SubjName)).files_in={SegMat};
    else
        Pipeline.(sprintf('%s_Synchronization', SubjName)).files_in=[{SegMat};{RandMat}];
    end
    %Out
    SYNMat=fullfile(TempDir, 'SYNMat.mat');
    Pipeline.(sprintf('%s_Synchronization', SubjName)).files_out={SYNMat};
end

%% Network - Modularity
if any(strcmpi(CalList, 'Network - Modularity'))
    if strcmp(Para.ModulAlorithm , 'greedy optimization')
        MType='1';
    else
        MType='2';
    end
    command='gretna_GUI_Modularity(opt.SegMat, opt.RandMat, opt.MType, opt.TempDir)';
    Pipeline.(sprintf('%s_Modularity', SubjName)).command=command;
    Pipeline.(sprintf('%s_Modularity', SubjName)).opt.SegMat=SegMat;
    Pipeline.(sprintf('%s_Modularity', SubjName)).opt.RandMat=RandMat;
    Pipeline.(sprintf('%s_Modularity', SubjName)).opt.MType=MType;
    Pipeline.(sprintf('%s_Modularity', SubjName)).opt.TempDir=TempDir;
    %In
    if isempty(RandMat)
        Pipeline.(sprintf('%s_Modularity', SubjName)).files_in={SegMat};
    else
        Pipeline.(sprintf('%s_Modularity', SubjName)).files_in=[{SegMat};{RandMat}];
    end
    %Out
    MODMat=fullfile(TempDir, 'MODMat.mat');
    Pipeline.(sprintf('%s_Modularity', SubjName)).files_out={MODMat};
end

%% Node - Degree
if any(strcmpi(CalList, 'Node - Degree'))
    command='gretna_GUI_NodeDegree(opt.SegMat, opt.NType, opt.Thres, opt.TempDir)';
    Pipeline.(sprintf('%s_NodeDegree', SubjName)).command=command;
    Pipeline.(sprintf('%s_NodeDegree', SubjName)).opt.SegMat=SegMat;
    Pipeline.(sprintf('%s_NodeDegree', SubjName)).opt.NType=NType;
    Pipeline.(sprintf('%s_NodeDegree', SubjName)).opt.Thres=Thres;
    Pipeline.(sprintf('%s_NodeDegree', SubjName)).opt.TempDir=TempDir;
    %In
    Pipeline.(sprintf('%s_NodeDegree', SubjName)).files_in={SegMat};
    %Out
    NodeDMat=fullfile(TempDir, 'NodeDMat.mat');
    Pipeline.(sprintf('%s_NodeDegree', SubjName)).files_out={NodeDMat};
end

%% Node - Efficiency
if any(strcmpi(CalList, 'Node - Efficiency'))
    command='gretna_GUI_NodeEfficiency(opt.SegMat, opt.NType, opt.Thres, opt.TempDir)';
    Pipeline.(sprintf('%s_NodeEfficiency', SubjName)).command=command;
    Pipeline.(sprintf('%s_NodeEfficiency', SubjName)).opt.SegMat=SegMat;
    Pipeline.(sprintf('%s_NodeEfficiency', SubjName)).opt.NType=NType;
    Pipeline.(sprintf('%s_NodeEfficiency', SubjName)).opt.Thres=Thres;
    Pipeline.(sprintf('%s_NodeEfficiency', SubjName)).opt.TempDir=TempDir;
    %In
    Pipeline.(sprintf('%s_NodeEfficiency', SubjName)).files_in={SegMat};
    %Out
    NodeEMat=fullfile(TempDir, 'NodeEMat.mat');
    Pipeline.(sprintf('%s_NodeEfficiency', SubjName)).files_out={NodeEMat};
end

%% Node - Betweenness
if any(strcmpi(CalList, 'Node - Betweenness'))
    command='gretna_GUI_NodeBetweenness(opt.SegMat, opt.NType, opt.Thres, opt.TempDir)';
    Pipeline.(sprintf('%s_NodeBetweenness', SubjName)).command=command;
    Pipeline.(sprintf('%s_NodeBetweenness', SubjName)).opt.SegMat=SegMat;
    Pipeline.(sprintf('%s_NodeBetweenness', SubjName)).opt.NType=NType;
    Pipeline.(sprintf('%s_NodeBetweenness', SubjName)).opt.Thres=Thres;
    Pipeline.(sprintf('%s_NodeBetweenness', SubjName)).opt.TempDir=TempDir;
    %In
    Pipeline.(sprintf('%s_NodeBetweenness', SubjName)).files_in={SegMat};
    %Out
    NodeBMat=fullfile(TempDir, 'NodeBMat.mat');
    Pipeline.(sprintf('%s_NodeBetweenness', SubjName)).files_out={NodeBMat};
end