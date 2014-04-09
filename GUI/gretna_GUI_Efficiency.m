function gretna_GUI_Efficiency(SegMat, RandMat, NType, Thres, TempDir)
SegMat=load(SegMat);
A=SegMat.A;
if ~isempty(RandMat)
    RandMat=load(RandMat);
    Rand=RandMat.Rand;
else
    Rand=[];
end

if strcmpi(NType, 'w')
    [Eloc, nodalEloc]=cellfun(@(a) gretna_node_local_efficiency_weight(a), A,...
        'UniformOutput', false);
    [Eg, nodalEg]=cellfun(@(a) gretna_node_global_efficiency_weight(a), A,...
        'UniformOutput', false);
elseif strcmpi(NType, 'b')
    [Eloc, nodalEloc]=cellfun(@(a) gretna_node_local_efficiency(a), A,...
        'UniformOutput', false);
    [Eg, nodalEg]=cellfun(@(a) gretna_node_global_efficiency(a), A,...
        'UniformOutput', false);
end
Eloc=cell2mat(Eloc);
nodalEloc=cell2mat(nodalEloc');
Eg=cell2mat(Eg);
nodalEg=cell2mat(nodalEg');

EFFMat=fullfile(TempDir, 'EFFMat.mat');
if exist(EFFMat, 'file')~=2
    save(EFFMat, 'Eloc', 'nodalEloc', 'Eg', 'nodalEg');
else
    save(EFFMat, 'Eloc', 'nodalEloc', 'Eg', 'nodalEg', '-append');
end

Thres=str2num(Thres);
if numel(Thres)>1
    deltas=Thres(2)-Thres(1);
    aEloc= (sum(Eloc)-sum(Eloc([1 end]))/2)*deltas;
    anodalEloc=(sum(nodalEloc,2)-sum(nodalEloc(:,[1 end]),2)/2)*deltas;
    aEg=(sum(Eg)-sum(Eg([1 end]))/2)*deltas;
    anodalEg=(sum(nodalEg,2)-sum(nodalEg(:,[1 end]),2)/2)*deltas;
    save(EFFMat, 'aEloc', 'anodalEloc', 'aEg', 'anodalEg', '-append');
end

if ~isempty(Rand)
    [Elocrand, Egrand]=cellfun(@(r) RandEfficiency(r, NType), Rand,...
        'UniformOutput', false);
    Elocrand=cell2mat(Elocrand);
    Egrand=cell2mat(Egrand);
    Eloczscore=(Eloc-mean(Elocrand))./std(Elocrand);
    Egzscore=(Eg-mean(Egrand))./std(Egrand);
    EGamma=Eloc./mean(Elocrand);
    ELambda=Eg./mean(Egrand);
    ESigma=EGamma./ELambda;
    save(EFFMat, 'Eloczscore', 'Egzscore',...
        'EGamma', 'ELambda', 'ESigma', '-append');
    if numel(Thres)>1
        deltas=Thres(2)-Thres(1);
        aEloczscore=(sum(Eloczscore)-sum(Eloczscore([1 end]))/2)*deltas;
        aEgzscore=(sum(Egzscore)-sum(Egzscore([1 end]))/2)*deltas;
        aEGamma=(sum(EGamma)-sum(EGamma([1 end]))/2)*deltas;
        aELambda=(sum(ELambda)-sum(ELambda([1 end]))/2)*deltas;
        aESigma=(sum(ESigma)-sum(ESigma([1 end]))/2)*deltas;
        save(EFFMat, 'aEloczscore', 'aEgzscore',...
            'aEGamma', 'aELambda', 'aESigma', '-append');
    end
end

function [Eloc, Eg]=RandEfficiency(A, NType)
if strcmpi(NType, 'w')
    [Eloc, nodalEloc]=cellfun(@(a) gretna_node_local_efficiency_weight(a), A,...
        'UniformOutput', false);
    [Eg, nodalEg]=cellfun(@(a) gretna_node_global_efficiency_weight(a), A,...
        'UniformOutput', false);
elseif strcmpi(NType, 'b')
    [Eloc, nodalEloc]=cellfun(@(a) gretna_node_local_efficiency(a), A,...
        'UniformOutput', false);
    [Eg, nodalEg]=cellfun(@(a) gretna_node_global_efficiency(a), A,...
        'UniformOutput', false);
end
Eloc=cell2mat(Eloc);
Eg=cell2mat(Eg);
