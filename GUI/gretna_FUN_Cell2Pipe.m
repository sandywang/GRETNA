function Pipeline=gretna_FUN_Cell2Pipe(Pipeline, TList, PCell)
% Just Convert Process Cell To Struct
for i=1:numel(TList)
    Pipeline.(TList{i})=PCell{i};
end