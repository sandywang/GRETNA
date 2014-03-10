function gretna_dicom_convert(Data_path)

%==========================================================================
% This function is used to convert dicom files to NIfTI format images. Of
% note, this functionality is based on dcm2nii.exe in MRIcroN.
%
%
% Syntax: function gretna_dicom_convert(Data_path)
%
% Input:
%       Data_path:
%                   The directory & filename of a .txt file that contains
%                   the directory of those files to be copied (can be
%                   obtained by gretna_gen_data_path.m).
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

fid = fopen(Data_path);
Dir_data = textscan(fid, '%s');
fclose(fid);

% determine the path of MRIcroN
Path_gretna = which ('gretna_dicom_convert.m');
[pathstr, ~, ~] = fileparts(Path_gretna);
cd ([pathstr filesep 'MRIcroN'])
fid = fopen('My_dcm2nii.bat','wt');
for i = 1:size(Dir_data{1},1)
    str = ['dcm2nii   -b' blanks(1) pathstr '\MRIcroN\dcm2niigui.ini' blanks(2) Dir_data{1}{i}];
    fprintf(fid, '%s', str);
    
    if i ~= size(Dir_data{1},1)
        fprintf(fid, '\n');
    end
end
fclose(fid);

winopen([pathstr '\MRIcroN\My_dcm2nii.bat']);