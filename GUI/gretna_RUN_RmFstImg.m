function gretna_RUN_RmFstImg(InputFile, DelImg)
%-------------------------------------------------------------------------%
%   Run Remove First Images
%   Input:
%   InputFile  - The input file list, Nx1 cell (1x1 cell for 4D NIfTI)
%   DelImg     - The number of time points should be removed
%-------------------------------------------------------------------------%
%   Written by Sandy Wang (sandywang.rest@gmail.com) 20161013.
%   Copyright (C) 2013-2016
%   State Key Laboratory of Cognitive Neuroscience and Learning &
%   IDG/McGovern Institute of Brain Research, 
%   Beijing Normal University,
%   Beijing, PR China.

OutputFile=cellfun(@(f) gretna_FUN_GetOutputFile(f, 'n'), InputFile,...
    'UniformOutput', false);
if numel(InputFile)==1 %4D
    Nii=nifti(InputFile{1});
    TP=size(Nii.dat, 4);
    InputCell=arrayfun(@(t) sprintf('%s,%d', InputFile{1}, t),...
        (1:TP)', 'UniformOutput', false);
    InputCell=InputCell(DelImg+1:end, 1);
else %3D
    InputCell=InputFile;
    InputCell=InputCell(DelImg+1:end, 1);
end
V_in=spm_vol(InputCell);
V_out=gretna_FUN_GetOutputStruct(V_in, OutputFile);

cellfun(@(in, out) WriteByVolume(in, out), V_in, V_out);

function WriteByVolume(in, out)
Y=spm_read_vols(in);
spm_write_vol(out, Y);
