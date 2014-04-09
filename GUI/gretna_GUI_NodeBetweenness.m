function gretna_GUI_NodeBetweenness(SegMat, NType, Thres, TempDir)
SegMat=load(SegMat);
A=SegMat.A;
[Be, nodalBe]=cellfun(@(a) Betweenness(a, NType), A,...
    'UniformOutput', false);
Be=cell2mat(Be);
nodalBe=cell2mat(nodalBe);

NodeBMat=fullfile(TempDir, 'NodeBMat.mat');
if exist(NodeBMat, 'file')~=2
    save(NodeBMat, 'Be', 'nodalBe');
else
    save(NodeBMat, 'Be', 'nodalBe', '-append');
end

Thres=str2num(Thres);
if numel(Thres)>1
    deltas=Thres(2)-Thres(1);
    aBe=(sum(Be, 2)-sum(Be(:,[1 end]), 2)/2)*deltas;
    anodalBe=(sum(nodalBe, 2)-sum(nodalBe(:,[1 end]), 2)/2)*deltas;
    save(NodeBMat, 'aBe', 'anodalBe', '-append');
end

function [Be, nodalBe]=Betweenness(Matrix, NType)
if strcmpi(NType, 'w')
    [Be, nodalBe]=gretna_node_betweenness_weight(Matrix);
elseif strcmpi(NType, 'b')
    [Be, nodalBe]=gretna_node_betweenness(Matrix);
end
nodalBe=nodalBe';