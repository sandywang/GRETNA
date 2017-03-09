function S=gretna_PIPE_GenSubDirS(Path, Prefix)
S=[];
[PPath, SPath]=fileparts(Path);    
% NIfTI File
D=dir(fullfile(Path, [Prefix, '.nii'])); % Nii

if ~isempty(D)
    S.Alias='NII';
else
    D=dir(fullfile(Path, [Prefix, '.img']));
    if ~isempty(D)
        S.Alias='PAIRS';
    end
end

%   3D OR 4D
if ~isempty(D)
    C={D.name}';
    if numel(C)==1
        Nii=nifti(fullfile(Path, C{1}));
        S.Num=size(Nii.dat, 4);
        S.FileList={fullfile(Path, C{1})};
        S.Alias=[S.Alias, '4D'];
        S.Lab=fullfile(SPath, C{1});
    else
        S.Num=numel(C);
        S.FileList=cellfun(@(s) fullfile(Path, s), C, 'UniformOutput', false);
        S.Alias=[S.Alias, '3D'];
        S.Lab=SPath;
    end
    return
end

% DICOM
D=dir(fullfile(Path, [Prefix, '.dcm'])); % DCM
if ~isempty(D)
    C={D.name}';
    S.Num=numel(C);
    S.FileList={fullfile(Path, C{1})};
    S.Alias='DCM';
    S.Lab=SPath;
    return
end

D=dir(fullfile(Path, [Prefix, '.DCM'])); % DCM
if ~isempty(D)
    C={D.name}';
    S.Num=numel(C);
    S.FileList={fullfile(Path, C{1})};
    S.Alias='DCM';
    S.Lab=SPath;
    return
end

D=dir(fullfile(Path, [Prefix, '*.ima'])); % DCM
if ~isempty(D)
    C={D.name}';
    S.Num=numel(C);
    S.FileList={fullfile(Path, C{1})};
    S.Alias='IMA';
    S.Lab=SPath;
    return
end

D=dir(fullfile(Path, [Prefix, '*.IMA'])); % DCM
if ~isempty(D)
    C={D.name}';
    S.Num=numel(C);
    S.FileList={fullfile(Path, C{1})};
    S.Alias='IMA';
    S.Lab=SPath;
    return
end

D=dir(fullfile(Path, Prefix)); % Unknown
Ind=cellfun(...
    @(IsDir, IsDot) ~IsDir && (~strcmpi(IsDot, '.') && ~strcmpi(IsDot, '..') && ~strcmpi(IsDot, '.DS_Store')),...
    {D.isdir}', {D.name}');
D=D(Ind);
if ~isempty(D)
    C={D.name}';
    S.Num=numel(C);
    S.FileList={fullfile(Path, C{1})};
    S.Alias='UNKNOWN';
    S.Lab=SPath;
    return
end