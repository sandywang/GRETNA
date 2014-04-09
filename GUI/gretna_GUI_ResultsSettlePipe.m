function Pipeline = gretna_GUI_ResultsSettlePipe(CalList,...
    AliasList, OutputDir,...
    Pipeline)

OutputDir=fullfile(OutputDir, 'GretnaNetworkResults');
%% Network - Small World
if any(strcmpi(CalList, 'Network - Small World'))
    MatList=cellfun(@(str) fullfile(OutputDir, str, 'SWMat.mat'), AliasList,...
        'UniformOutput', false);
    OutName='SmallWorld.mat';
    OutPath=fullfile(OutputDir, 'Results_NetworkSmallWorld', OutName);
    command='gretna_GUI_ResultsSettle(opt.MatList, opt.OutPath)';
    Pipeline.('ResultSettle_SmallWorld').command=command;
    Pipeline.('ResultSettle_SmallWorld').opt.MatList=MatList;
    Pipeline.('ResultSettle_SmallWorld').opt.OutPath=OutPath;
    Pipeline.('ResultSettle_SmallWorld').files_in=MatList;
    Pipeline.('ResultSettle_SmallWorld').files_out={OutPath};
end

%% Network - Efficiency
if any(strcmpi(CalList, 'Network - Efficiency'))
    MatList=cellfun(@(str) fullfile(OutputDir, str, 'EFFMat.mat'), AliasList,...
        'UniformOutput', false);
    OutName='Efficiency.mat';
    OutPath=fullfile(OutputDir, 'Results_NetworkEfficiency', OutName);
    command='gretna_GUI_ResultsSettle(opt.MatList, opt.OutPath)';
    Pipeline.('ResultSettle_Efficiency').command=command;
    Pipeline.('ResultSettle_Efficiency').opt.MatList=MatList;
    Pipeline.('ResultSettle_Efficiency').opt.OutPath=OutPath;
    Pipeline.('ResultSettle_Efficiency').files_in=MatList;
    Pipeline.('ResultSettle_Efficiency').files_out={OutPath};
end

%% Network - Assortativity
if any(strcmpi(CalList, 'Network - Assortativity'))
    MatList=cellfun(@(str) fullfile(OutputDir, str, 'ASSMat.mat'), AliasList,...
        'UniformOutput', false);
    OutName='Assortativity.mat';
    OutPath=fullfile(OutputDir, 'Results_NetworkAssortativity', OutName);
    command='gretna_GUI_ResultsSettle(opt.MatList, opt.OutPath)';
    Pipeline.('ResultSettle_Assortativity').command=command;
    Pipeline.('ResultSettle_Assortativity').opt.MatList=MatList;
    Pipeline.('ResultSettle_Assortativity').opt.OutPath=OutPath;
    Pipeline.('ResultSettle_Assortativity').files_in=MatList;
    Pipeline.('ResultSettle_Assortativity').files_out={OutPath};    
end

%% Network - Hierarchy
if any(strcmpi(CalList, 'Network - Hierarchy'))
    MatList=cellfun(@(str) fullfile(OutputDir, str, 'HIEMat.mat'), AliasList,...
        'UniformOutput', false);
    OutName='Hierarchy.mat';
    OutPath=fullfile(OutputDir, 'Results_NetworkHierarchy', OutName);
    command='gretna_GUI_ResultsSettle(opt.MatList, opt.OutPath)';
    Pipeline.('ResultSettle_Hierarchy').command=command;
    Pipeline.('ResultSettle_Hierarchy').opt.MatList=MatList;
    Pipeline.('ResultSettle_Hierarchy').opt.OutPath=OutPath;
    Pipeline.('ResultSettle_Hierarchy').files_in=MatList;
    Pipeline.('ResultSettle_Hierarchy').files_out={OutPath};    
end

%% Network - Synchronization
if any(strcmpi(CalList, 'Network - Synchronization'))
    MatList=cellfun(@(str) fullfile(OutputDir, str, 'SYNMat.mat'), AliasList,...
        'UniformOutput', false);
    OutName='Synchronization.mat';
    OutPath=fullfile(OutputDir, 'Results_NetworkSynchronization', OutName);
    command='gretna_GUI_ResultsSettle(opt.MatList, opt.OutPath)';
    Pipeline.('ResultSettle_Synchronization').command=command;
    Pipeline.('ResultSettle_Synchronization').opt.MatList=MatList;
    Pipeline.('ResultSettle_Synchronization').opt.OutPath=OutPath;
    Pipeline.('ResultSettle_Synchronization').files_in=MatList;
    Pipeline.('ResultSettle_Synchronization').files_out={OutPath};     
end

%% Network - Modularity
if any(strcmpi(CalList, 'Network - Modularity'))
    MatList=cellfun(@(str) fullfile(OutputDir, str, 'MODMat.mat'), AliasList,...
        'UniformOutput', false);
    OutName='Modularity.mat';
    OutPath=fullfile(OutputDir, 'Results_NetworkModularity', OutName);
    command='gretna_GUI_ResultsSettle(opt.MatList, opt.OutPath)';
    Pipeline.('ResultSettle_Modularity').command=command;
    Pipeline.('ResultSettle_Modularity').opt.MatList=MatList;
    Pipeline.('ResultSettle_Modularity').opt.OutPath=OutPath;
    Pipeline.('ResultSettle_Modularity').files_in=MatList;
    Pipeline.('ResultSettle_Modularity').files_out={OutPath};
end

%% Node - Degree
if any(strcmpi(CalList, 'Node - Degree'))
    MatList=cellfun(@(str) fullfile(OutputDir, str, 'NodeDMat.mat'), AliasList,...
        'UniformOutput', false);
    OutName='NodeDegree.mat';
    OutPath=fullfile(OutputDir, 'Results_NodeDegree', OutName);
    command='gretna_GUI_ResultsSettle(opt.MatList, opt.OutPath)';
    Pipeline.('ResultSettle_NodeDegree').command=command;
    Pipeline.('ResultSettle_NodeDegree').opt.MatList=MatList;
    Pipeline.('ResultSettle_NodeDegree').opt.OutPath=OutPath;
    Pipeline.('ResultSettle_NodeDegree').files_in=MatList;
    Pipeline.('ResultSettle_NodeDegree').files_out={OutPath};    
end

%% Node - Efficiency
if any(strcmpi(CalList, 'Node - Efficiency'))
    MatList=cellfun(@(str) fullfile(OutputDir, str, 'NodeEMat.mat'), AliasList,...
        'UniformOutput', false);
    OutName='NodeEfficiency.mat';
    OutPath=fullfile(OutputDir, 'Results_NodeEfficiency', OutName);
    command='gretna_GUI_ResultsSettle(opt.MatList, opt.OutPath)';
    Pipeline.('ResultSettle_NodeEfficiency').command=command;
    Pipeline.('ResultSettle_NodeEfficiency').opt.MatList=MatList;
    Pipeline.('ResultSettle_NodeEfficiency').opt.OutPath=OutPath;
    Pipeline.('ResultSettle_NodeEfficiency').files_in=MatList;
    Pipeline.('ResultSettle_NodeEfficiency').files_out={OutPath};      
end

%% Node - Betweenness
if any(strcmpi(CalList, 'Node - Betweenness'))
    MatList=cellfun(@(str) fullfile(OutputDir, str, 'NodeBMat.mat'), AliasList,...
        'UniformOutput', false);
    OutName='NodeBetweenness.mat';
    OutPath=fullfile(OutputDir, 'Results_NodeBetweenness', OutName);
    command='gretna_GUI_ResultsSettle(opt.MatList, opt.OutPath)';
    Pipeline.('ResultSettle_NodeBetweenness').command=command;
    Pipeline.('ResultSettle_NodeBetweenness').opt.MatList=MatList;
    Pipeline.('ResultSettle_NodeBetweenness').opt.OutPath=OutPath;
    Pipeline.('ResultSettle_NodeBetweenness').files_in=MatList;
    Pipeline.('ResultSettle_NodeBetweenness').files_out={OutPath};    
end