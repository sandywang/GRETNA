function IndiCell=gretna_PIPE_GenIndiMat(OutputMatList, GrpID)
U=unique(GrpID);
if numel(U)==1
    IndiCell={OutputMatList};
else
    IndiCell=cell(numel(U), 1);
    for i=1:numel(U)
        IndiCell{i, 1}=OutputMatList(GrpID==U(i), 1);
    end
end