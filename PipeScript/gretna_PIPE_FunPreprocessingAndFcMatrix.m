% Functional Directory, e.g /Data/Analysis/GretnaNifti
FunPDir = '/data/CourseData_20160409';

% Input Files Prefix
Prefix='*';

% The tag of preprocessing step you want to execute, orderly
StepTag={...    
    'DICOM to NIfTI';...
    'Remove First Images';...
    'Slice Timing';...
    'Realign';...
    'Normalize';...
    'Spatially Smooth';...
    'Regress Out Covariates';...
    'Temporally Detrend';...
    'Temporally Filter';...
    'Scrubbing';...
    'Static Correlation';...
    'Dynamical Correlation'};

% The path to parameter file
ParaFile='Path-to-Para/Para.mat';

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
if isempty(Prefix)
    warning('Empty input files prefix! Set it to *!');
    Prefix='*';
end

AllStr=StepTag;
fprintf(fid, 'The following steps will be executed:\n');
for i=1:numel(AllStr)
    fprintf(fid, '\t%s\n', AllStr{i});
end

if isempty(FunPDir)
    error('Invalid Functional Data Directory: Empty');
elseif exist(FunPDir, 'dir')~=7
    error('Invalid Functional Data Directory: %s', FunPDir);    
end

if exist(ParaFile, 'file')~=2
    GRETNAPath=fileparts(which('gretna.m'));
    ParaFile=fullfile(GRETNAPath, 'PipeScript', 'PreprocessAndFCMatrixPara.mat');
    warning('Cannot find parameter file, use the default (%s).', ParaFile);
end
load(ParaFile);

% Create Input Files Struct
SubStruct=dir(FunPDir);
SubInd=cellfun(...
    @ (NotDot) (~strcmpi(NotDot, '.') && ~strcmpi(NotDot, '..') && ~strcmpi(NotDot, '.DS_Store')),...
    {SubStruct.name});
SubStruct=SubStruct(SubInd);

SubDirInd=cell2mat({SubStruct.isdir});
SubFileInd=~SubDirInd;

SubDirStr=cellfun(@(s) fullfile(FunPDir, s), {SubStruct(SubDirInd).name}',...
    'UniformOutput', false);
SubFileStr=cellfun(@(s) fullfile(FunPDir, s), {SubStruct(SubFileInd).name}',...
    'UniformOutput', false);

SubDirS=cellfun(@(p) gretna_PIPE_GenSubDirS(p, Prefix), SubDirStr,...
    'UniformOutput', false);
SubFileS=cellfun(@(p) gretna_PIPE_GenSubFileS(p, Prefix), SubFileStr,...
    'UniformOutput', false);

TmpInd=cellfun(@isempty, SubDirS);
SubDirS=SubDirS(~TmpInd);
TmpInd=cellfun(@isempty, SubFileS);
SubFileS=SubDirS(~TmpInd);

InputS=[SubDirS; SubFileS];

FileList=cellfun(@(S) S.FileList, InputS, 'UniformOutput', false);
SList=cellfun(@(S) gretna_PIPE_GenSubjLab(S.Lab), InputS,...
    'UniformOutput', false);
IndList=arrayfun(@(d) sprintf('%.5d', d), (1:numel(SList))',...
    'UniformOutput', false);
fprintf(fid, 'The following subjects were added:\n');
for i=1:numel(SList)
    fprintf(fid, '\tIndex: %s -> Name: %s\n', IndList{i}, SList{i});
end
Map=[IndList, SList];

%% ---------------------------Generate PSOM----------------------------- %%
Pl=[];
InputSoFileList={};
InputFDFileList={};
InputHMFileList={};
for i=1:numel(AllStr)
    ModeName=AllStr{i};
    switch upper(ModeName)
        case 'DICOM TO NIFTI'
            PPath=fileparts(FunPDir);
            OutputFileList=cellfun(...
                @(s) {fullfile(PPath, 'GretnaFunNIfTI', s, 'rest.nii')},...
                SList, 'UniformOutput', false);
            PCell=cellfun(@(in, out) gretna_GEN_EpiDcm2Nii(in, out),...
                FileList, OutputFileList, 'UniformOutput', false);
            
            TList=cellfun(@(i) sprintf('EpiDcm2Nii%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);
        case 'REMOVE FIRST IMAGES'
            PCell=cellfun(@(in) gretna_GEN_RmFstImg(in, Para.DelImg{1}),...
                FileList, 'UniformOutput', false);
            
            TList=cellfun(@(i) sprintf('RmFstImg%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);            
        case 'SLICE TIMING'
            PCell=cellfun(...
                @(in) gretna_GEN_SliTim(in, Para.TR{1}, Para.SliOrd{1}, Para.RefSli{1}),...
                FileList, 'UniformOutput', false);
            
            TList=cellfun(@(i) sprintf('SliTim%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);   
        case 'REALIGN'
            PCell=cellfun(...
                @(in) gretna_GEN_Realign(in, Para.NumPasses{1}),...
                FileList, 'UniformOutput', false);
            TList=cellfun(@(i) sprintf('Realign%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell); 
            
            InputSoFileList=cellfun(@(S) S.SoFile, PCell,...
                'UniformOutput', false);
            InputHMFileList=cellfun(@(S) S.HMFile, PCell,...
                'UniformOutput', false);
            InputFDFileList=cellfun(@(S) S.FDFile, PCell,...
                'UniformOutput', false);
            
            ChkCell=cellfun(...
                @(in, lab) gretna_GEN_ChkHM(in, lab, FunPDir),...
                FileList, SList, 'UniformOutput', false);
            
            TList=cellfun(@(i) sprintf('ChkHM%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, ChkCell); 
        case 'NORMALIZE'
            SourPrefix=Para.SourPrefix{1};            
            if isempty(InputSoFileList);    
                InputSoFileList=cellfun(...
                    @(in) GenSoFile(in, SourPrefix),...
                    FileList, 'UniformOutput', false);
                if any(cellfun(@isempty, InputSoFileList))
                    errordlg('Cannot find source image (e.g. mean*.nii in Functional Directory), Please Check again OR add ''Realign'' step!');
                    return;
                end
            end 
            
            if Para.NormSgy{1}==1 % EPI
                PCell=cellfun(...
                    @(in, inSo) gretna_GEN_EpiNorm(...
                    in, inSo, Para.EPITpm{2},...
                    Para.BBox{1}, Para.VoxSize{1}...
                    ),...
                    FileList, InputSoFileList,...
                    'UniformOutput', false);
                
                TList=cellfun(@(i) sprintf('EpiNorm%s', i), IndList,...
                    'UniformOutput', false);
                Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell); 
            else
                % T1 Dicom to NIfTI
                T1Path=Para.T1Path{2};
                T1Prefix=Para.T1Prefix{1};
                T1Dcm2NiiFlag=Para.T1Dcm2NiiFlag{1};
                InputT1FileList=[];
                if T1Dcm2NiiFlag==1; 
                    PPath=fileparts(handles.FunPDir);
                    InputT1DirList=cellfun(...
                        @(s) fullfile(T1Path, s),...
                        SList, 'UniformOutput', false);
                    InputT1FileList=cellfun(...
                        @(p) GenT1Dcm(p, T1Prefix), InputT1DirList,...
                        'UniformOutput', false);
                    
                    if any(cellfun(@isempty, InputT1FileList))
                        errordlg('Cannot find T1 image (e.g. *.dcm in T1 Directory), Please Check again!');
                        return;
                    end
                    
                    OutputT1FileList=cellfun(...
                        @(s) {fullfile(PPath, 'GretnaT1NIfTI', s, 'T1.nii')},...
                        SList, 'UniformOutput', false);
                    TDNCell=cellfun(@(in, out) gretna_GEN_T1Dcm2Nii(in, out),...
                        InputT1FileList, OutputT1FileList, 'UniformOutput', false);
            
                    TList=cellfun(@(i) sprintf('T1Dcm2Nii%s', i), IndList,...
                        'UniformOutput', false);
                    Pl=gretna_FUN_Cell2Pipe(Pl, TList, TDNCell);

                    InputT1FileList=OutputT1FileList;
                end
                
                % Normalize
                if isempty(InputT1FileList)
                    InputT1DirList=cellfun(...
                        @(s) fullfile(T1Path, s),...
                        SList, 'UniformOutput', false);
                    InputT1FileList=cellfun(...
                        @(p) GenT1Nii(p, T1Prefix), InputT1DirList,...
                        'UniformOutput', false);
                    if any(cellfun(@isempty, InputT1FileList))
                        errordlg(sprintf('Cannot find T1 image (e.g. %s.nii in T1 Directory), Please Check again!', T1Prefix));
                        return;
                    end
                end
                
                if Para.NormSgy{1}==2 % T1 Unified Segmentation
                    PCell=cellfun(...
                        @(in, inSo, inT1) gretna_GEN_T1CoregSegNorm(...
                        in, inSo,...
                        inT1,...
                        Para.GMTpm{2}, Para.WMTpm{2}, Para.CSFTpm{2},...
                        Para.BBox{1}, Para.VoxSize{1}...
                        ),...
                        FileList, InputSoFileList, InputT1FileList,...
                        'UniformOutput', false);
                    
                    TList=cellfun(@(i) sprintf('T1CoregSegNorm%s', i), IndList,...
                        'UniformOutput', false);
                    Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell); 
                else % DARTEL
                    % Coregister and New Segment
                    CNSCell=cellfun(...
                        @(in, inSo, inT1) gretna_GEN_T1CoregNewSeg(...
                        in, inSo, inT1,...
                        Para.TPMTpm{2}...
                        ),...
                        FileList, InputSoFileList, InputT1FileList,...
                        'UniformOutput', false);
                    TList=cellfun(@(i) sprintf('T1CoregNewSeg%s', i), IndList,...
                        'UniformOutput', false);
                    Pl=gretna_FUN_Cell2Pipe(Pl, TList, CNSCell);
                    
                    C1FileList=cellfun(@(S) S.C1File, CNSCell,...
                        'UniformOutput', false);
                    C2FileList=cellfun(@(S) S.C2File, CNSCell,...
                        'UniformOutput', false);
                    C3FileList=cellfun(@(S) S.C3File, CNSCell,...
                        'UniformOutput', false);
                    RC1FileList=cellfun(@(S) S.RC1File, CNSCell,...
                        'UniformOutput', false);
                    RC2FileList=cellfun(@(S) S.RC2File, CNSCell,...
                        'UniformOutput', false);
                    
                    Pl.DartelNormT1=gretna_GEN_DartelNormT1(...
                        RC1FileList, RC2FileList,...
                        C1FileList, C2FileList, C3FileList...
                        );
                    % Dartel Template List
                    DTFile=Pl.DartelNormT1.DTFile;
                    FFFileList=Pl.DartelNormT1.FFFileList;
            
                    PCell=cellfun(...
                        @(in, inSo, inFF) gretna_GEN_DartelNormEpi(in, inSo, inFF, DTFile,...
                        Para.BBox{1}, Para.VoxSize{1}...
                        ),...
                        FileList, InputSoFileList, FFFileList, 'UniformOutput', false);
            
                    TList=cellfun(@(i) sprintf('DartelNormEpi%s', i), IndList,...
                        'UniformOutput', false);
                    Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell); 
                end
            end
            OutputSoFileList=cellfun(@(S) S.OutputSoFile, PCell, 'UniformOutput', false);
            ChkCell=cellfun(...
                @(normSo, lab) gretna_GEN_ChkNorm(normSo, lab, FunPDir),...
                OutputSoFileList, SList, 'UniformOutput', false);
            
            TList=cellfun(@(i) sprintf('ChkNorm%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, ChkCell);         
        case 'SPATIALLY SMOOTH'
            PCell=cellfun(...
                @(in) gretna_GEN_Smooth(in, Para.FWHM{1}),...
                FileList, 'UniformOutput', false);
            
            TList=cellfun(@(i) sprintf('Smooth%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell); 
        case 'REGRESS OUT COVARIATES'
            % Global Signal
            GSMsk='';
            if Para.GSFlag{1}==1  % TRUE
                GSMsk=Para.GSMsk{1, 2};
            end
            % White Matter
            WMMsk='';
            if Para.WMFlag{1}==1  % TRUE
                WMMsk=Para.WMMsk{1, 2};
            end 
            % CSF
            CSFMsk='';
            if Para.CSFFlag{1}==1 % TRUE
                CSFMsk=Para.CSFMsk{1, 2};
            end
            % HeadMotion
            if Para.HMFlag{1}==1  % TRUE
                HMInd=Para.HMSgy{1};
                if isempty(InputHMFileList)
                    InputHMFileList=cellfun(...
                        @(in) GenHMFile(in),...
                        FileList, 'UniformOutput', false);
                    if any(cellfun(@isempty, InputHMFileList))
                        errordlg('Cannot find head motion parameter file (e.g. HeadMotionParameter.txt in Functional Directory), Please Check again OR add ''Realign'' step!');
                        return;
                    end
                end
            else
                HMInd=0;
                % Do Not Used
                InputHMFileList=cellfun(@(in) [],...
                    FileList, 'UniformOutput', false);
            end
            
            PCell=cellfun(...
                @(in, inHM) gretna_GEN_RegressOut(in, GSMsk, WMMsk, CSFMsk, HMInd, inHM),...
                FileList, InputHMFileList, 'UniformOutput', false);
            
            TList=cellfun(@(i) sprintf('RegressOut%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell); 
        case 'TEMPORALLY DETREND'
            PCell=cellfun(...
                @(in) gretna_GEN_Detrend(in, Para.PolyOrd{1, 1}),...
                FileList, 'UniformOutput', false);
            
            TList=cellfun(@(i) sprintf('Detrend%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell); 
        case 'TEMPORALLY FILTER'
            PCell=cellfun(...
                @(in) gretna_GEN_Filter(in, Para.TR{1}, Para.Band{1}),...
                FileList, 'UniformOutput', false);
            
            TList=cellfun(@(i) sprintf('Filter%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell); 
        case 'SCRUBBING'
            if isempty(InputFDFileList);    
                InputFDFileList=cellfun(...
                    @(in) GenFDFile(in),...
                    FileList, 'UniformOutput', false);
                if any(cellfun(@isempty, InputFDFileList))
                    errordlg('Cannot find source image (e.g. PowerFD.txt in Functional Directory), Please Check again OR add ''Realign'' step!');
                    return;
                end
            end            
            PCell=cellfun(...
                @(in, inFD) gretna_GEN_Scrubbing(...
                in, inFD, Para.InterSgy{1}, Para.FDTrd{1},...
                Para.PreNum{1}, Para.PostNum{1}...
                ),...
                FileList, InputFDFileList, 'UniformOutput', false); 
            
            TList=cellfun(@(i) sprintf('Scrubbing%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell); 
        case 'STATIC CORRELATION'
            PCell=cellfun(...
                @(in, lab) gretna_GEN_StaticFC(...
                in, lab, FunPDir,...
                Para.FCAtlas{2}, Para.FZTFlag{1}...
                ),...
                FileList, SList, 'UniformOutput', false);
            TList=cellfun(@(i) sprintf('StaticFC%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell); 
        case 'DYNAMICAL CORRELATION'
            PCell=cellfun(...
                @(in, lab) gretna_GEN_DynamicalFC(...
                in, lab, FunPDir,...
                Para.FCAtlas{2}, Para.FZTFlag{1},...
                Para.SWL{1}, Para.SWS{1}...
                ),...
                FileList, SList, 'UniformOutput', false);
            TList=cellfun(@(i) sprintf('DynamicalFC%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);
    end
    % Update Input    
    FileList=cellfun(@(S) S.OutputImgFile, PCell, 'UniformOutput', false);
end

%% --------------------------------Run---------------------------------- %%
PPath=fileparts(FunPDir);
PipeLogPath=fullfile(PPath, 'GretnaLogs', 'FunPreproAndNetCon');

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