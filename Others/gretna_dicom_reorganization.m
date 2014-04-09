function gretna_dicom_reorganization(Data_path, File_filter, Output_path, Modality, Num_of_files)

%==========================================================================
% This function is used to reorganize the storage of raw dicom data in the
% order of: 1) modality; and then 2) subject instead of 1) subject; and 
% then 2) modality. For example, in "F\my_data", the data are sorted as
% F:\my_data
%           --sub001
%                --dti
%                --fun
%                --ana
%           --sub002
%                --dti
%                --fun
%                --ana
%           --sub003
%                --dti
%                --fun
%                --ana
%           ......
% The resultant catalogue after performing this function looks like as:
% F:\my_data
%           --func
%                --sub001
%                --sub002
%                ......
%           --dti
%                --sub001
%                --sub002
%                ......
%           --anat
%                --sub001
%                --sub002
%                ......
%
%
% Syntax: function gretna_dicom_reorganization(Data_path, File_filter, Output_path, Modality, Num_of_files)
%
% Inputs: 
%       Data_path:
%                   The directory that contains the files needed to be
%                   reorganized .
%       File_filter:
%                   The prefix of those files to be processed.
%       Output_path:
%                   The directory where the files will be sorted (e.g.,
%                   E:\Mydata).
%       Modality:
%                   A cell indicating which modalities will be reorganized
%                   (e.g., {'fun','dti','ana'}).
%       Num_of_files:
%                   Number of files of each modality as specified in
%                   'Modality' ([210 120 180] meaning that there are 210 
%                   functional, 120 dti and 180 anatomical dicom files for 
%                   each subject.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================


cd (Data_path)

% subjects
folders = dir;

for sub = 3:size(folders,1)
    
    fprintf('Searching DICOM-files in %s\n', fullfile(Data_path, folders(sub).name));
    
    cd (fullfile(Data_path, folders(sub).name))

    mod = dir;

    for i = 3:length(mod)
        cd (fullfile(Data_path, folders(sub).name, mod(i).name))
        dicom_files = dir(fullfile(pwd, [File_filter '*']));

        while isempty(dicom_files)
            tmp = dir;
            cd(fullfile(pwd,tmp(3).name))
            dicom_files = dir(fullfile(pwd, [File_filter '*']));
        end

        mod_det = size(dicom_files,1) == Num_of_files;
        if sum(mod_det) == 1
            index = find(mod_det == 1);
            mkdir(fullfile(Output_path, Modality{index}, folders(sub).name))
            copyfile([File_filter '*'],fullfile(Output_path, Modality{index}, folders(sub).name))
        end
    end
    
    fprintf('Searching DICOM-files in %s ...... is done \n', fullfile(Data_path, folders(sub).name));
        
end

return