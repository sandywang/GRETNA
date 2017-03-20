% The cell of input's fullpath, *.txt or *.mat 
InputFileList={'/data/CourseData_20160409/fMRIRawData/GretnaSFCMatrixR/rN0001.txt';...
    '/data/CourseData_20160409/fMRIRawData/GretnaSFCMatrixR/rN0002.txt'
    };

% The directory of results, if inexist, use pwd. so need be created before
% runing
OutputDir='/data/CourseData_';

StepTag_Global={...    
    'Global - Small-World';...
    'Global - Efficiency';...
    'Global - Rich-Club';...
    'Global - Hierarchy';...
    'Global - Assortativity';...
    'Global - Synchronization'...
    };
StepTag_Nodal={};

% The path to parameter file
ParaFile='/data/CourseData_20160409/fMRIRawData/TestNonRandom';

% Option
Opt.mode               = 'batch'; % qsub session
Opt.max_queued         = 6;
Opt.flag_verbose       = true;
Opt.flag_pause         = true;
Opt.flag_update        = false;
Opt.time_between_checks=5;

LogFid=1;
%% -------------------------------Check--------------------------------- %%
fid=LogFid;

FileS=cellfun(@(f) gretna_PIPE_GenMatFileS(f) , InputFileList, 'UniformOutput', false);
InputS=[];
for i=1:numel(FileS)
    if iscell(FileS{i})
       tmp=FileS{i};
    else
       tmp=FileS(i);
    end
    InputS=[InputS; tmp];
end

if exist(ParaFile, 'file')~=2
    GRETNAPath=fileparts(which('gretna.m'));
    ParaFile=fullfile(GRETNAPath, 'PipeScript', 'NetAnalysisPara.mat');
    warning('Cannot find parameter file, use the default (%s).', ParaFile);
end
load(ParaFile);
fprintf(fid, 'Using parameter file -> %s\n', ParaFile);

AllStr=[StepTag_Global; StepTag_Nodal];
fprintf(fid, 'The following steps will be executed:\n');
for i=1:numel(AllStr)
    fprintf(fid, '\t%s\n', AllStr{i});
end

Thres=Para.Thres{1};
if ~isnumeric(Thres)
    Thres=str2num(Thres);
end
% Generate Interval
AUCInterval=0;
if numel(Thres)>1
    AUCInterval=Thres(2)-Thres(1);
end

if exist(OutputDir, 'dir')~=7
    OutputDir=pwd;
end
fprintf(fid, 'Output to %s\n', OutputDir);
%% ---------------------------Generate PSOM----------------------------- %%

MatList=cellfun(@(S) S.Mat, InputS, 'UniformOutput', false);
AList=cellfun(@(S) S.Alias, InputS, 'UniformOutput', false);
IndList=arrayfun(@(d) sprintf('%.5d', d), (1:numel(AList))',...
    'UniformOutput', false);
Map=[IndList, AList];
Pl=[];

% Network Construction
% Thresholding Connectivity Matrix to Construct Network
FileList=cellfun(@(S) S.File, InputS, 'UniformOutput', false);
GrpID=cellfun(@(S) S.GrpID, InputS);
OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'RealNet.mat'),...
    AList, 'UniformOutput', false);
PCell=cellfun(@(mat, in, out)...
    gretna_GEN_ThresMat(mat, in, out, Para.NetSign{1}, Para.ThresType{1}, Thres, Para.NetType{1}),...
    MatList, FileList, OutputMatList,...
    'UniformOutput', false);
TList=cellfun(@(i) sprintf('ThresMat%s', i), IndList,...
    'UniformOutput', false);
Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);
RealNetList=cellfun(@(S) S.OutputMatFile, PCell, 'UniformOutput', false);
RandNetList=cellfun(@(S) '', PCell, 'UniformOutput', false);

if ~isempty(StepTag_Global) && Para.RandNum{1}>0
    OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'RandNet.mat'),...
        AList, 'UniformOutput', false);
    PCell=cellfun(@(in, out)...
        gretna_GEN_GenRandNet(in, out, Para.NetType{1}, Para.RandNum{1}),...
        RealNetList, OutputMatList,...
        'UniformOutput', false);
    
    TList=cellfun(@(i) sprintf('GenRandNet%s', i), IndList,...
        'UniformOutput', false);
    Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);
    RandNetList=cellfun(@(S) S.OutputMatFile, PCell, 'UniformOutput', false);
end
% Network Metric Estimation
AllIndiMatList=cell(numel(AllStr), 1);
AllInteMatList=cell(numel(AllStr), 1);
for n=1:numel(AllStr)
    ModeName=AllStr{n};
    switch upper(ModeName)
        case 'GLOBAL - SMALL-WORLD'
            OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'SW.mat'),...
                AList, 'UniformOutput', false);
            InterMat=gretna_PIPE_GenInterMat(OutputDir, 'SmallWorld', GrpID);
            PCell=cellfun(@(in, rnd, out)...
                gretna_GEN_SmallWorld(in, rnd, out, Para.NetType{1}, Para.ClustAlgor{1}, AUCInterval),...
                RealNetList, RandNetList, OutputMatList,...
                'UniformOutput', false);
    
            TList=cellfun(@(i) sprintf('SmallWorld%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);
        case 'GLOBAL - EFFICIENCY'
            OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'EFF.mat'),...
                AList, 'UniformOutput', false);
            InterMat=gretna_PIPE_GenInterMat(OutputDir, 'NetworkEfficiency', GrpID);
            PCell=cellfun(@(in, rnd, out)...
                gretna_GEN_GEfficiency(in, rnd, out, Para.NetType{1}, AUCInterval),...
                RealNetList, RandNetList, OutputMatList,...
                'UniformOutput', false);
    
            TList=cellfun(@(i) sprintf('GEfficiency%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);
%         case 'GLOBAL - MODULARITY'
%             OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'MOD.mat'),...
%                 AList, 'UniformOutput', false);
%             InterMat=fullfile(OutputDir, 'Modularity', 'Modularity.mat');                        
%             PCell=cellfun(@(in, rnd, out)...
%                 gretna_GEN_Modularity(in, rnd, out, Para.NetType{1}, Para.ModulAlgor{1}),...
%                 RealNetList, RandNetList, OutputMatList,...
%                 'UniformOutput', false);
%     
%             TList=cellfun(@(i) sprintf('Modularity%s', i), IndList,...
%                 'UniformOutput', false);
%             Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);
        case 'GLOBAL - RICH-CLUB'
            OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'RC.mat'),...
                AList, 'UniformOutput', false);
            InterMat=gretna_PIPE_GenInterMat(OutputDir, 'RichClub', GrpID);
            PCell=cellfun(@(in, rnd, out)...
                gretna_GEN_RichClub(in, rnd, out, Para.NetType{1}),...
                RealNetList, RandNetList, OutputMatList,...
                'UniformOutput', false);
    
            TList=cellfun(@(i) sprintf('RichClub%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);
        case 'GLOBAL - ASSORTATIVITY'
            OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'ASS.mat'),...
                AList, 'UniformOutput', false);
            InterMat=gretna_PIPE_GenInterMat(OutputDir, 'Assortativity', GrpID);
            PCell=cellfun(@(in, rnd, out)...
                gretna_GEN_Assortativity(in, rnd, out, Para.NetType{1}, AUCInterval),...
                RealNetList, RandNetList, OutputMatList,...
                'UniformOutput', false);
    
            TList=cellfun(@(i) sprintf('Assortativity%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);
        case 'GLOBAL - SYNCHRONIZATION'
            OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'SYN.mat'),...
                AList, 'UniformOutput', false);
            InterMat=gretna_PIPE_GenInterMat(OutputDir, 'Synchronization', GrpID);
            PCell=cellfun(@(in, rnd, out)...
                gretna_GEN_Synchronization(in, rnd, out, Para.NetType{1}, AUCInterval),...
                RealNetList, RandNetList, OutputMatList,...
                'UniformOutput', false);
    
            TList=cellfun(@(i) sprintf('Synchronization%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);            
        case 'GLOBAL - HIERARCHY'
            OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'HIE.mat'),...
                AList, 'UniformOutput', false);
            InterMat=gretna_PIPE_GenInterMat(OutputDir, 'Hierarchy', GrpID);
            PCell=cellfun(@(in, rnd, out)...
                gretna_GEN_Hierarchy(in, rnd, out, Para.NetType{1}, AUCInterval),...
                RealNetList, RandNetList, OutputMatList,...
                'UniformOutput', false);
    
            TList=cellfun(@(i) sprintf('Hierarchy%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);   
        case 'NODAL - COMMUNITY INDEX'
            OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'CI.mat'),...
                AList, 'UniformOutput', false);
            InterMat=gretna_PIPE_GenInterMat(OutputDir, 'CommunityIndex', GrpID);
            PCell=cellfun(@(in, out)...
                gretna_GEN_CommunityIndex(in, out, Para.NetType{1}, Para.ModulAlgor{1}, Para.DDPcFlag{1}),...
                RealNetList, OutputMatList,...
                'UniformOutput', false);
    
            TList=cellfun(@(i) sprintf('CommunityIndex%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);
        case 'NODAL - PARTICIPANT COEFFICIENT'
            OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'PC.mat'),...
                AList, 'UniformOutput', false);
            InterMat=gretna_PIPE_GenInterMat(OutputDir, 'ParticipantCoefficient', GrpID);
            PCell=cellfun(@(in, out)...
                gretna_GEN_ParticipantCoefficient(in, out, Para.CIndex{1}),...
                RealNetList, OutputMatList,...
                'UniformOutput', false);
    
            TList=cellfun(@(i) sprintf('CommunityIndex%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);  
        case 'MODULAR - INTERACTION'
            OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'MI.mat'),...
                AList, 'UniformOutput', false);
            InterMat=gretna_PIPE_GenInterMat(OutputDir, 'ModularInteraction', GrpID);
            PCell=cellfun(@(in, out)...
                gretna_GEN_ModularInteraction(in, out, Para.NetType{1}, Para.CIndex{1}),...
                RealNetList, OutputMatList,...
                'UniformOutput', false);
    
            TList=cellfun(@(i) sprintf('ModularInteraction%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);
        case 'NODAL - DEGREE CENTRALITY'
            OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'DC.mat'),...
                AList, 'UniformOutput', false);
            InterMat=gretna_PIPE_GenInterMat(OutputDir, 'DegreeCentrality', GrpID);
            PCell=cellfun(@(in, out)...
                gretna_GEN_DegreeCentrality(in, out, Para.NetType{1}, AUCInterval),...
                RealNetList, OutputMatList,...
                'UniformOutput', false);
    
            TList=cellfun(@(i) sprintf('DegreeCentrality%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);             
        case 'NODAL - BETWEENNESS CENTRALITY'
            OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'BC.mat'),...
                AList, 'UniformOutput', false);
            InterMat=gretna_PIPE_GenInterMat(OutputDir, 'BetweennessCentrality', GrpID);
            PCell=cellfun(@(in, out)...
                gretna_GEN_BetweennessCentrality(in, out, Para.NetType{1}, AUCInterval),...
                RealNetList, OutputMatList,...
                'UniformOutput', false);
    
            TList=cellfun(@(i) sprintf('BetweennessCentrality%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);             
        case 'NODAL - EIGENVECTOR CENTRALITY'
        case 'NODAL - SUBGRAPH CENTRALITY'
        case 'NODAL - PAGE-RANK CENTRALITY'
        case 'NODAL - K-CORE CENTRALITY'
        case 'NODAL - PARTICIPANT CENTRALITY'
        case 'NODAL - EFFICIENCY'
            OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'NE.mat'),...
                AList, 'UniformOutput', false);
            InterMat=gretna_PIPE_GenInterMat(OutputDir, 'NodalEfficiency', GrpID);
            PCell=cellfun(@(in, out)...
                gretna_GEN_NodalEfficiency(in, out, Para.NetType{1}, AUCInterval),...
                RealNetList, OutputMatList,...
                'UniformOutput', false);
    
            TList=cellfun(@(i) sprintf('NodalEfficiency%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);
    end
    AllIndiMatList{n, 1}=gretna_PIPE_GenIndiMat(OutputMatList, GrpID);
    AllInteMatList{n, 1}=InterMat;
end
Pl.ResultIntegrating=gretna_GEN_ResultIntegrating(AllIndiMatList, AllInteMatList);

%% --------------------------------Run---------------------------------- %%
PPath=fileparts(OutputDir);
PipeLogPath=fullfile(PPath, 'GretnaLogs', 'NetAnalysis');

if exist(PipeLogPath, 'dir')==7
    ans=rmdir(PipeLogPath, 's');
end
mkdir(PipeLogPath);
Opt.path_logs=PipeLogPath;

psom_run_pipeline(Pl, Opt);
PipeStatus=load(fullfile(PipeLogPath, 'PIPE_status.mat'));
PipeLogs=load(fullfile(PipeLogPath, 'PIPE_logs.mat'));

FStatus=structfun(@(s) strcmpi(s, 'failed'), PipeStatus);
if any(FStatus)
    FN=fieldnames(PipeLogs);
    FFN=FN(FStatus);
    Str=[];
    for i=1:numel(FFN)
        if strcmpi(FFN{i}, 'DartelNormT1')
            SubjString=[];
        else
            Ind=FFN{i}(end-4:end);
            SubjLab=SList(strcmpi(IndList, Ind));
            SubjString=SubjLab{1};
        end
        Str=[Str,'\n', SubjString, '\n',...
            psom_pipeline_visu(PipeLogPath, 'log', FFN{i}, false)];
    end
    error(Str);
end