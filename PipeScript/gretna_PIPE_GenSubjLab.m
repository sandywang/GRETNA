function SubjLab=gretna_PIPE_GenSubjLab(Lab)
if ~isempty(strfind(Lab, filesep))
    SubjLab=fileparts(Lab);
else
    if ~isempty(strfind(Lab, '.nii')) ||...
            ~isempty(strfind(Lab, '.img'))
        SubjLab=Lab(1:end-4);
    else
        SubjLab=Lab;
    end
end