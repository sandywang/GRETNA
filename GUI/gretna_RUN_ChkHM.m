function gretna_RUN_ChkHM(InputFile, SubjLab, FunPath)
%-------------------------------------------------------------------------%
%   RUN Check Head Motion
%   Input:
%   InputFile  - The input file list, Nx1 cell (1x1 cell for 4D NIfTI)
%   SubjLab    - The lab of subject for outputing.
%   FunPath    - The directory of functional dataset
%-------------------------------------------------------------------------%
%   Written by Sandy Wang (sandywang.rest@gmail.com) 20161013.
%   Copyright (C) 2013-2016
%   State Key Laboratory of Cognitive Neuroscience and Learning &
%   IDG/McGovern Institute of Brain Research, 
%   Beijing Normal University,
%   Beijing, PR China.

SubjLab=strrep(SubjLab, filesep, '_');
SubjLab=strrep(SubjLab, '.nii', '');
PPath=fileparts(FunPath);
FstFile=InputFile{1};
Path=fileparts(FstFile);
RpFile=fullfile(Path, 'HeadMotionParameter.txt');
FDFile=fullfile(Path, 'PowerFD.txt');

Rp=load(RpFile);
% Generate Check File
HMLogPath=fullfile(PPath, 'GretnaLogs', 'HeadMotionInfo');
if exist(HMLogPath, 'dir')~=7
    mkdir(HMLogPath);
end
MaxRp = max(abs(Rp));
MaxRp(4:6)=MaxRp(4:6)*180/pi;
% 3mm 3Degree
if any(MaxRp>3)
    CPath=fullfile(HMLogPath, 'MaxHeadMotionParameterLargerThan3mmOr3Degree');
    if exist(CPath, 'dir')~=7
        mkdir(CPath);
    end
    File=fullfile(CPath, SubjLab);
    save(File, 'MaxRp', '-ASCII', '-DOUBLE','-TABS');
end
% 2mm 2Degree
if any(MaxRp>2)
    CPath=fullfile(HMLogPath, 'MaxHeadMotionParameterLargerThan2mmOr2Degree');
    if exist(CPath, 'dir')~=7
        mkdir(CPath);
    end
    File=fullfile(CPath, SubjLab);
    save(File, 'MaxRp', '-ASCII', '-DOUBLE','-TABS');
end
% 1mm 1Degree
if any(MaxRp>1)
    CPath=fullfile(HMLogPath, 'MaxHeadMotionParameterLargerThan1mmOr1Degree');
    if exist(CPath, 'dir')~=7
        mkdir(CPath);
    end
    File=fullfile(CPath, SubjLab);
    save(File, 'MaxRp', '-ASCII', '-DOUBLE','-TABS');    
end
% All
CPath=fullfile(HMLogPath, 'MaxHeadMotionParameterAll');
if exist(CPath, 'dir')~=7
    mkdir(CPath);
end
File=fullfile(CPath, SubjLab);
save(File, 'MaxRp', '-ASCII', '-DOUBLE','-TABS');  

FDChkPath=fullfile(HMLogPath, 'PowerFD');
if exist(FDChkPath, 'dir')~=7
    mkdir(FDChkPath);
end
FDChkFile=fullfile(FDChkPath, [SubjLab, '.txt']);
copyfile(FDFile, FDChkFile);