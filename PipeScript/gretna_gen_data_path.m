function gretna_gen_data_path(Data_path, Output_path, Output_filename)

%=========================================================================
% This function is used to generate a .txt file that contains the
% directories of those dataset to be processed. Of note, the outputed .txt file will be
% a input variable for many functions in the GRETNA toolbox.
%
%
% Syntax: function gretna_gen_data_path(Data_path, Output_path, Output_filename)
%
% Inputs:
%       Data_path:
%                   The directory where all individual dataset are sorted
%                   (see the following example).
%       Output_path:
%                   The directory where the generated .txt file will be
%                   sorted.
%       Output_filename:
%                   The filename of the generated .txt file.
%
% E.g., Your data are sorted as follows:
%         C:\Data\ADstudy\AD\sub1
%         C:\Data\ADstudy\AD\sub2
%         C:\Data\ADstudy\AD\sub3
%         ...
%         C:\Data\ADstudy\NC\sub1
%         C:\Data\ADstudy\NC\sub2
%         C:\Data\ADstudy\NC\sub3
%         ...
% Then, you can perform the function as follows:
% gretna_gen_data_path({'C:\Data\ADstudy\AD','C:\Data\ADstudy\NC'}, 'C:\Data\ADstudy', 'data_path.txt')
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

cd (Output_path)
fid = fopen(Output_filename,'wt');

NumGroup = length(Data_path);
for g = 1:NumGroup
    cd (Data_path{g})
    files = dir;
    if g ~= NumGroup
        for i = 3:length(files)
            fprintf(fid, '%s\n', [Data_path{g} filesep files(i).name]);
        end
    else
        for i = 3:length(files)
            if i ~= length(files)
                fprintf(fid, '%s\n', [Data_path{g} filesep files(i).name]);
            else
                fprintf(fid, '%s', [Data_path{g} filesep files(i).name]);
            end
        end
    end
end

fclose(fid);

return