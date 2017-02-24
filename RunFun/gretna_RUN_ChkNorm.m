function gretna_RUN_ChkNorm(NormSoFile, SubjLab, FunPath)
%-------------------------------------------------------------------------%
%   RUN Check Normalization
%   Input:
%   NormSoFile  - The normalized source image, 1x1 cell (1x1 cell for 4D NIfTI)
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
%
FstFile=NormSoFile{1};
Path=fileparts(FstFile);
TIFFileInRaw=fullfile(Path, ['NormChk_', SubjLab, '.tif']);

GRETNAPath=fileparts(which('gretna.m'));
Ch2Filename=fullfile(GRETNAPath, 'Templates', 'ch2.nii');

% Follow Mingrui Xia's SeeCAT
ch2_hdr=spm_vol(Ch2Filename);
ch2_vol=spm_read_vols(ch2_hdr);
    
c_view_u=ch2_vol(:,ceil(end/2),:);
c_view_u=squeeze(c_view_u)';
c_view_u=c_view_u(end:-1:1,:);
c_view_u=c_view_u./max(c_view_u(:))*255;
c_view_u=imresize(c_view_u,217/181);
    
s_view_u=ch2_vol(ceil(end/2),:,:);
s_view_u=squeeze(s_view_u)';
s_view_u=s_view_u(end:-1:1,:);
s_view_u=s_view_u./max(s_view_u(:))*255;
s_view_u=imresize(s_view_u, 217/181);
    
a_view_u=ch2_vol(:,:,ceil(end/2));
a_view_u=squeeze(a_view_u)';
a_view_u=a_view_u(end:-1:1,:);
a_view_u=a_view_u./max(a_view_u(:))*255;
    
underlay=uint8([c_view_u, s_view_u, a_view_u]);
underlay=repmat(underlay, [1, 1, 3]);

mean_hdr=spm_vol(NormSoFile{1});
mean_vol=spm_read_vols(mean_hdr);
        
c_view_o=mean_vol(:,ceil(end/2),:);
c_view_o=squeeze(c_view_o)';
c_view_o=c_view_o(end:-1:1,:);
c_view_o=c_view_o./max(c_view_o(:))*255;
c_view_o=imresize(c_view_o, size(c_view_u));
        
s_view_o=mean_vol(ceil(end/2),:,:);
s_view_o=squeeze(s_view_o)';
s_view_o=s_view_o(end:-1:1,:);
s_view_o=s_view_o./max(s_view_o(:))*255;
s_view_o=imresize(s_view_o, size(s_view_u));
        
a_view_o=mean_vol(:,:,ceil(end/2));
a_view_o=squeeze(a_view_o)';
a_view_o=a_view_o(end:-1:1,:);
a_view_o=a_view_o./max(a_view_o(:))*255;
a_view_o=imresize(a_view_o, size(a_view_u));
        
overlay=uint8([c_view_o, s_view_o, a_view_o]);
overlay=repmat(overlay,[1,1,3]);
overlay(:,:,2:3)=overlay(:,:,2:3)/2;
outputimg=imresize(imadd(underlay./2,overlay./2),2);
        
imwrite(outputimg, TIFFileInRaw);

%
PPath=fileparts(FunPath);
TIFChkPath=fullfile(PPath, 'GretnaLogs', 'NormalizationInfo');
if exist(TIFChkPath, 'dir')~=7
    mkdir(TIFChkPath);
end
TIFFileInLog=fullfile(TIFChkPath, ['NormChk_', SubjLab, '.tif']);
copyfile(TIFFileInRaw, TIFFileInLog);