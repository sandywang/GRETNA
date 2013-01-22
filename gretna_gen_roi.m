function gretna_gen_roi(Center, Shape, ParaOfShape, Ref_img, Output_file)

%==========================================================================
% This function is used to generate a Sphere or Box shaped ROI.
%
%
% Syntax: function gretna_gen_roi(Center, Shape, ParaOfShape, Ref_img, Output_file)
%
% Inputs:
%        Center:
%               Center coordinates of the ROIs (# of ROIs*3 array).
%        Shape:
%               'Sphere' for spherical ROIs;
%               'Box'    for box-type  ROIs.
%        ParaOfShape:
%               Radium for Sphere;
%               3-value vector for Box.
%        Ref_img:
%               Directory & filename of the reference image.
%        Output_file:
%               Directory & filename of the generated image.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
% Modified according to Robert C. Welsh, Ann Arbor, MICHIGAN, 2006.09.26 
%==========================================================================

Vref = spm_vol(Ref_img);
[~, xyz] = spm_read_vols(Vref);

maskIMG = zeros(Vref.dim(1:3));

maskHDR = Vref;

[pn fn en] = fileparts(Output_file);
maskHDR.fname = ([fn en]);

maskHDR.pinfo = [1;0;0];

maskHDR.descrip = [Shape blanks(1) 'ROI mask: center = [' num2str(reshape(Center, 1, size(Center,1)*size(Center,2))) '], Para = ' num2str(ParaOfShape)];

nROIS = size(Center,1);
roiINFO = cell(nROIS,1);

% loop and get the information for the ROI.
for iROI = 1:nROIS
    roiINFO{iROI}.center_mm = Center(iROI,:)';
    
    tmp = Vref.mat\([roiINFO{iROI}.center_mm ;1]);
    roiINFO{iROI}.center_vox = tmp(1:3);
    
    roiINFO{iROI}.type = Shape;
    
    roiINFO{iROI}.size = ParaOfShape;
end

mmCoords = xyz;

boxBIT = zeros(4,size(mmCoords,2));

% loop on the ROI definitions and drop them into the mask image volume matrix.
for iROI = 1:nROIS
    % Found the center of this ROI in voxels
    % and then build it.
    xs = mmCoords(1,:) - roiINFO{iROI}.center_mm(1);
    ys = mmCoords(2,:) - roiINFO{iROI}.center_mm(2);
    zs = mmCoords(3,:) - roiINFO{iROI}.center_mm(3);
    switch roiINFO{iROI}.type
        case 'Sphere'
            radii = sqrt(xs.^2+ys.^2+zs.^2);
            VOXIdx = find(radii<=roiINFO{iROI}.size);
        case 'Box'
            xsIDX = abs(xs)<=roiINFO{iROI}.size(1);
            ysIDX = abs(ys)<=roiINFO{iROI}.size(2);
            zsIDX = abs(zs)<=roiINFO{iROI}.size(3);
            boxBIT  = 0*boxBIT;
            boxBIT(1,xsIDX) = 1;
            boxBIT(2,ysIDX) = 1;
            boxBIT(3,zsIDX) = 1;
            boxBIT(4,:) = boxBIT(1,:).*boxBIT(2,:).*boxBIT(3,:);
            VOXIdx = find(boxBIT(4,:));
    end
    maskIMG(VOXIdx) = iROI;
end

% write out the image.
cd (pn)
spm_write_vol(maskHDR,maskIMG);

fprintf('\nBuilding ROI Mask Is Done.\n');