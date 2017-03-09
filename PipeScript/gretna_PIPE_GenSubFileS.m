function S=gretna_PIPE_GenSubFileS(File, Prefix)
S=[];
[PPath, Name, Ext]=fileparts(File);

if strncmpi(Name, Prefix(1:end-1), length(Prefix(1:end-1))) &&...
        (strcmpi(Ext, '.nii') || strcmpi(Ext, '.img'))
    Nii=nifti(File);
    S.Num=size(Nii.dat, 4);
    S.FileList={File};
    S.Alias='NII4D';
    S.Lab=[Name, Ext];
end