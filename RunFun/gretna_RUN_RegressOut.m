function gretna_RUN_RegressOut(InputFile, GSMsk, WMMsk, CSFMsk, HMInd, HMFile)
%-------------------------------------------------------------------------%
%   RUN Regress Out Covariates
%   Input:
%   InputFile    - The input file list, Nx1 cell (1x1 cell for 4D NIfTI)
%   GSMsk        - The mask to extract global signal, skip if empty
%   WMMsk        - The mask to extract white matter signal, skip if empty
%   CSFMsk       - The mask to extract csf signal, skip if empty
%   HMInd        - The head motion regression index
%                  0: Nothing
%                  1: Origin - 6 parameter
%                  2: Origin+Relative - 12 parameter
%                  3: Krison - 24 parameter
%   HMFile       - Head Motion Parameter File, 1x1 cell and [] if HMInd==0
%-------------------------------------------------------------------------%
%   Written by Sandy Wang (sandywang.rest@gmail.com) 20161013.
%   Copyright (C) 2013-2016
%   State Key Laboratory of Cognitive Neuroscience and Learning &
%   IDG/McGovern Institute of Brain Research, 
%   Beijing Normal University,
%   Beijing, PR China.

OutputFile=cellfun(@(f) gretna_FUN_GetOutputFile(f, 'c'), InputFile,...
    'UniformOutput', false);

FstFile=InputFile{1};
[Path, Name, Ext]=fileparts(FstFile);
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

% Global Signal Mask
if ~isempty(GSMsk)
    V_GSMsk=spm_vol(GSMsk);
    Y_GSMsk=spm_read_vols(V_GSMsk);
    Y_GSMsk=reshape(Y_GSMsk, [], 1);
else
    Y_GSMsk=[];
end

% White Matter Mask
if ~isempty(WMMsk)
    V_WMMsk=spm_vol(WMMsk);
    Y_WMMsk=spm_read_vols(V_WMMsk);
    Y_WMMsk=reshape(Y_WMMsk, [], 1);
else
    Y_WMMsk=[];
end

% CSF Mask
if ~isempty(CSFMsk)
    V_CSFMsk=spm_vol(CSFMsk);
    Y_CSFMsk=spm_read_vols(V_CSFMsk);
    Y_CSFMsk=reshape(Y_CSFMsk, [], 1);
else
    Y_CSFMsk=[];
end
% Image Covariates
Y_ImgCovMsk=logical([Y_GSMsk, Y_WMMsk, Y_CSFMsk]);

ImgCov=cellfun(@(in) GetImgCov(in, Y_ImgCovMsk), V_in,...
    'UniformOutput', false);
ImgCov=cell2mat(ImgCov);

% Head Motion
switch HMInd
    case 0 % Nothin
        HMCov=[];
    case 1 % 6
        Rp=load(HMFile{1});
        HMCov=Rp;
    case 2 % 12
        Rp=load(HMFile{1});
        Dif=diff(Rp);
        Dif=[zeros(1,6); Dif];
        HMCov=[Rp, Dif];
    case 3 %24
        Rp=load(HMFile{1});
        Pre=[zeros(1,6);Rp(1:end-1, :)];
        HMCov=[Rp, Pre, Rp.^2, Pre.^2];
end

% Regressor
Rgr=ones(TP, 1);
Rgr=[Rgr, ImgCov, HMCov];

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
    
    ResSliData=zeros(size(RawSliData));
    for i=1:NumRow*NumCol
        OneTc=RawSliData(i, :);
        if any(OneTc)
            [b, r]=gretna_regress_ss(OneTc', Rgr);
            ResSliData(i, :)=r';
        end
    end

    ResSliData=reshape(ResSliData, [NumRow, NumCol, TP]);
            
    for t=1:TP
        V_out{t}=spm_write_plane(V_out{t}, ResSliData(:, :, t), k);
    end
end 



function ImgCov=GetImgCov(in, Y_ImgCovMsk)
NumC=size(Y_ImgCovMsk, 2);
ImgCov=zeros(1, NumC);
Y=spm_read_vols(in);
Y=reshape(Y, [], 1);
for i=1:NumC
    ImgCov(1, i)=mean(Y(Y_ImgCovMsk(:, i)));
end
