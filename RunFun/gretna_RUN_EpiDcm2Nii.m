function gretna_RUN_EpiDcm2Nii(InputFile, OutputFile)
%-------------------------------------------------------------------------%
%   Run EPI's DICOM to NIfTI
%   Input:
%   InputFile  - The input file list, 1x1 cell,to indicate the first DICOM file.
%   OutputFile - The output file list, 1x1 cell, to indicate the output
%                NIfTI file, as usual rest.nii (4D NIfTI)
%-------------------------------------------------------------------------%
%   Written by Sandy Wang (sandywang.rest@gmail.com) 20161013.
%   Copyright (C) 2013-2016
%   State Key Laboratory of Cognitive Neuroscience and Learning &
%   IDG/McGovern Institute of Brain Research,
%   Beijing Normal University,
%   Beijing, PR China.

OutputPath=fileparts(OutputFile{1});
if exist(OutputPath, 'dir')==7
    rmdir(OutputPath, 's');
end
mkdir(OutputPath);

OldPath=pwd;

GRETNAPath=fileparts(which('gretna.m'));
cd(fullfile(GRETNAPath, 'Dcm2Nii'));

OutputOpt=['-o ', OutputPath];
if ispc
    IniOpt='-b dcm2nii.ini';
    Cmd='dcm2nii.exe';
elseif ismac
    IniOpt='-b ./dcm2nii.ini';
    Cmd='./dcm2nii_mac';
else %Linux
    IniOpt='-b ./dcm2nii.ini';
    Cmd='./dcm2nii';
end

if ismac
    Str = sprintf('%s','chmod +x ./dcm2nii_mac');
    ExitCode=system(Str);
    if ExitCode
        error('Error when DICOM to NIfTI');
    end
end

Str=sprintf('%s %s %s %s', Cmd, IniOpt, OutputOpt, InputFile{1});
ExitCode=system(Str);
if ExitCode
    error('Error when DICOM to NIfTI');
end
D=dir(fullfile(OutputPath, '*.nii'));
D={D.name};
movefile(fullfile(OutputPath, D{1}), OutputFile{1});
cd(OldPath);