function InterCell=gretna_PIPE_GenInterMat(OutputDir, Alias, GrpID)
U=unique(GrpID);
if numel(U)==1
    InterCell={fullfile(OutputDir, Alias, sprintf('%s.mat', Alias))};
else
    InterCell=cell(numel(U), 1);
    for i=1:numel(U)
        InterCell{i, 1}=fullfile(OutputDir, Alias, sprintf('Group%d', U(i)), sprintf('%s.mat', Alias));
    end
end