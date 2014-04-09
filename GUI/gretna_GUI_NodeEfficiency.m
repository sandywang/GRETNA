function gretna_GUI_NodeEfficiency(SegMat, NType, Thres, TempDir)
SegMat=load(SegMat);
A=SegMat.A;
[Eg, nodalEg]=cellfun(@(a) Efficiency(a, NType), A,...
    'UniformOutput', false);
Eg=cell2mat(Eg);
nodalEg=cell2mat(nodalEg);

NodeEMat=fullfile(TempDir, 'NodeEMat.mat');
if exist(NodeEMat, 'file')~=2
    save(NodeEMat, 'Eg', 'nodalEg');
else
    save(NodeEMat, 'Eg', 'nodalEg', '-append');
end

Thres=str2num(Thres);
if numel(Thres)>1
    deltas=Thres(2)-Thres(1);
    aEg=(sum(Eg, 2)-sum(Eg(:,[1 end]), 2)/2)*deltas;
    anodalEg=(sum(nodalEg, 2)-sum(nodalEg(:,[1 end]), 2)/2)*deltas;
    save(NodeEMat, 'aEg', 'anodalEg', '-append');
end

function [Eg, nodalEg]=Efficiency(Matrix, NType)
if strcmpi(NType, 'w')
    [Eg, nodalEg]=gretna_node_global_efficiency_weight(Matrix);
elseif strcmpi(NType, 'b')
    [Eg, nodalEg]=gretna_node_global_efficiency(Matrix);
end
nodalEg=nodalEg';