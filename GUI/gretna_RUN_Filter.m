function gretna_RUN_Filter(InputFile, TR, Band)
%-------------------------------------------------------------------------%
%   RUN Temporally Filter
%   Input:
%   InputFile  - The input file list, Nx1 cell (1x1 cell for 4D NIfTI)
%   TR         - TR
%   Band       - Frequency Band, 
%                e.g., band-pass: [0.01, 0.08] 
%                      high-pass: [0.01, Inf]
%                      low-pass : [0, 0.1]
%-------------------------------------------------------------------------%
%   Written by Sandy Wang (sandywang.rest@gmail.com) 20161013.
%   Copyright (C) 2013-2016
%   State Key Laboratory of Cognitive Neuroscience and Learning &
%   IDG/McGovern Institute of Brain Research, 
%   Beijing Normal University,
%   Beijing, PR China.

OutputFile=cellfun(@(f) gretna_FUN_GetOutputFile(f, 'b'), InputFile,...
    'UniformOutput', false);

FstFile=InputFile{1};
Nii=nifti(FstFile);
NumSli=size(Nii.dat, 3);
NumRow=size(Nii.dat, 1);
NumCol=size(Nii.dat, 2);

if numel(InputFile)==1
    TP=size(Nii.dat, 4);     
    InputCell=arrayfun(@(t) sprintf('%s,%d', InputFile{1}, t),...
        (1:TP)', 'UniformOutput', false);
else
    TP=numel(InputFile);
    InputCell=InputFile;    
end
V_in=spm_vol(InputCell);
V_out=gretna_FUN_GetOutputStruct(V_in, OutputFile);

for t=1:TP
    V_out{t}=spm_create_vol(V_out{t});    
end

for k=1:NumSli
    RawSliData=zeros(NumRow, NumCol, TP);
    for t=1:TP
        RawSliData(:, :, t)=spm_slice_vol(V_in{t}, spm_matrix([0 0 k]),...
            [NumRow, NumCol], 0);        
    end

    RawSliData=double(reshape(RawSliData , [] , TP));
    FltdSliData=zeros(size(RawSliData));
    
    NonZeroMsk=any(RawSliData, 2);
    if any(NonZeroMsk)
        RawData=RawSliData(NonZeroMsk, :);
    
        MeanData=mean(RawData, 2);
        MeanData=repmat(MeanData, [1, TP]);
        FltdData=gretna_filtering(RawData, TR , Band);
        FltdData=FltdData+MeanData;

        FltdSliData(NonZeroMsk, :)=FltdData;
    else
        FltdSliData=zeros(size(RawSliData));
    end
    FltdSliData=reshape(FltdSliData, [NumRow, NumCol, TP]);
            
    for t=1:TP
        V_out{t}=spm_write_plane(V_out{t}, FltdSliData(:, :, t), k);
    end
end 