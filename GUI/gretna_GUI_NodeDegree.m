function gretna_GUI_NodeDegree(SegMat, NType, Thres, TempDir)
SegMat=load(SegMat);
A=SegMat.A;
[Deg, nodalDeg]=cellfun(@(a) Degree(a, NType), A,...
    'UniformOutput', false);
Deg=cell2mat(Deg);
nodalDeg=cell2mat(nodalDeg);

NodeDMat=fullfile(TempDir, 'NodeDMat.mat');
if exist(NodeDMat, 'file')~=2
    save(NodeDMat, 'Deg', 'nodalDeg');
else
    save(NodeDMat, 'Deg', 'nodalDeg', '-append');
end

Thres=str2num(Thres);
if numel(Thres)>1
    deltas=Thres(2)-Thres(1);
    aDeg=(sum(Deg, 2)-sum(Deg(:,[1 end]), 2)/2)*deltas;
    anodalDeg=(sum(nodalDeg, 2)-sum(nodalDeg(:,[1 end]), 2)/2)*deltas;
    save(NodeDMat, 'aDeg', 'anodalDeg', '-append');
end

function [Deg, nodalDeg]=Degree(Matrix, NType)
if strcmpi(NType, 'w')
    [Deg, nodalDeg]=gretna_node_degree_weight(Matrix);
elseif strcmpi(NType, 'b')
    [Deg, nodalDeg]=gretna_node_degree(Matrix);
end