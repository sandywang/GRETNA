function gretna_RUN_Scrubbing(InputFile, FDFile, InterInd, FDTrd, PreNum, PostNum)
%-------------------------------------------------------------------------%
%   Generate psom-used struct for Temporally Filter
%   Input:
%   InputFile  - The input file list, Nx1 cell (1x1 cell for 4D NIfTI)
%   FDFile     - The Power's FD file, 1x1 cell;
%   InterInd   - The index of interpolation
%                1: Remove
%                2: Nearest
%                3: Linear
%                4: Spine
%   FDTrd      - FD Threshold 
%   PreNum     - The time point number removed before bad time point 
%   PostNum    - The time point number removed after bad time point
%-------------------------------------------------------------------------%
%   Written by Sandy Wang (sandywang.rest@gmail.com) 20161013.
%   Copyright (C) 2013-2016
%   State Key Laboratory of Cognitive Neuroscience and Learning &
%   IDG/McGovern Institute of Brain Research, 
%   Beijing Normal University,
%   Beijing, PR China.

OutputFile=cellfun(@(f) gretna_FUN_GetOutputFile(f, 'x'), InputFile,...
    'UniformOutput', false);

FstFile=InputFile{1};
Path=fileparts(FstFile);

Nii=nifti(FstFile);
if numel(InputFile)==1
    TP=size(Nii.dat, 4);     
    InputCell=arrayfun(@(t) sprintf('%s,%d', InputFile{1}, t),...
        (1:TP)', 'UniformOutput', false);
else
    TP=numel(InputFile);
    InputCell=InputFile;    
end

% FD Mask
FD=load(FDFile{1});

FDMsk=FD>FDTrd;
FDInd=find(FDMsk);
PreMsk=false(TP, 1);
for i=1:PreNum
    PreInd=FDInd-i;
    PreInd(PreInd<1)=[];
    PreMsk(PreInd)=true; 
end

PostMsk=false(TP, 1);
for i=1:PostNum
    PostInd=FDInd+i;
    PostInd(PostInd>TP)=[];
    PostMsk(PostInd)=true; 
end

FDMsk=FDMsk | PreMsk | PostMsk;
FDInd=find(FDMsk);
% Scrubbing Perctage
SPFile=fullfile(Path, 'ScrubbingPerctage.txt');
ScrubPerc=length(find(FDMsk))/TP;
save(SPFile, 'ScrubPerc', '-ASCII', '-DOUBLE','-TABS');
SMFile=fullfile(Path, 'ScrubbingMask.txt');
FDMsk_Double=double(FDMsk);
save(SMFile, 'FDMsk_Double', '-ASCII', '-DOUBLE','-TABS');
% Cal
if InterInd==1 || isempty(FDInd) % Remove OR Skip
    InputCell=InputCell(~FDMsk);
    V_in=spm_vol(InputCell);
    V_out=gretna_FUN_GetOutputStruct(V_in, OutputFile);
    cellfun(@(in, out) WriteByVolume(in, out), V_in, V_out);
else
    switch InterInd
        case 2
            InterSgy='nearest';
        case 3
            InterSgy='linear';
        case 4
            InterSgy='spline';
    end
    NumSli=size(Nii.dat, 3);
    NumRow=size(Nii.dat, 1);
    NumCol=size(Nii.dat, 2);
    
    % Generate Output Structure
    V_in=spm_vol(InputCell);
    V_out=gretna_FUN_GetOutputStruct(V_in, OutputFile);
    
    InputCell=InputCell(~FDMsk);
    V_in2=spm_vol(InputCell);
    TP2=numel(V_in2);
    
    for t=1:TP
        V_out{t}=spm_create_vol(V_out{t});    
    end

    for k=1:NumSli
        RawSliData=zeros(NumRow, NumCol, TP2);
        for t=1:TP2
            RawSliData(:, :, t)=spm_slice_vol(V_in2{t}, spm_matrix([0 0 k]),...
                [NumRow, NumCol], 0);        
        end
        RawSliData=double(reshape(RawSliData , [] , TP2));
    
        ScrSliData=interp1(find(~FDMsk), RawSliData', (1:TP)', InterSgy)';
        NanMsk=isnan(ScrSliData(:, end));
        if any(NanMsk)
            ScrSliData(NanMsk, end)=ScrSliData(NanMsk, end-1);
        end
        ScrSliData=reshape(ScrSliData, [NumRow, NumCol, TP]);
            
        for t=1:TP
            V_out{t}=spm_write_plane(V_out{t}, ScrSliData(:, :, t), k);
        end
    end 

end

function WriteByVolume(in, out)
Y=spm_read_vols(in);
spm_write_vol(out, Y);