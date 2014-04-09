function gretna_GUI_SmallWorld(SegMat, RandMat, SType, NType, Thres, TempDir)
SegMat=load(SegMat);
A=SegMat.A;
if ~isempty(RandMat)
    RandMat=load(RandMat);
    Rand=RandMat.Rand;
else
    Rand=[];
end

if strcmpi(NType, 'w')
    if strcmpi(SType, '1')
        [Cp, nodalCp]=cellfun(@(a) gretna_node_clustcoeff_weight(a, '1'), A,...
            'UniformOutput', false);
    elseif strcmpi(SType, '2')
        [Cp, nodalCp]=cellfun(@(a) gretna_node_clustcoeff_weight(a, '2'), A,...
            'UniformOutput', false);
    end
    [Lp, nodalLp]=cellfun(@(a) gretna_node_shortestpathlength_weight(a), A,...
        'UniformOutput', false);
elseif strcmpi(NType, 'b')
    [Cp, nodalCp]=cellfun(@(a) gretna_node_clustcoeff(a), A,...
        'UniformOutput', false);
    [Lp, nodalLp]=cellfun(@(a) gretna_node_shortestpathlength(a), A,...
        'UniformOutput', false);
end
Cp=cell2mat(Cp);
nodalCp=cell2mat(nodalCp')';
Lp=cell2mat(Lp);
nodalLp=cell2mat(nodalLp')';

SWMat=fullfile(TempDir, 'SWMat.mat');
if exist(SWMat, 'file')~=2
    save(SWMat, 'Cp', 'nodalCp', 'Lp', 'nodalLp');
else
    save(SWMat, 'Cp', 'nodalCp', 'Lp', 'nodalLp', '-append');
end

Thres=str2num(Thres);
if numel(Thres)>1
    deltas=Thres(2)-Thres(1);
    aCp= (sum(Cp)-sum(Cp([1 end]))/2)*deltas;
    anodalCp=(sum(nodalCp,2)-sum(nodalCp(:,[1 end]),2)/2)*deltas;
    aLp=(sum(Lp)-sum(Lp([1 end]))/2)*deltas;
    anodalLp=(sum(nodalLp,2)-sum(nodalLp(:,[1 end]),2)/2)*deltas;
    save(SWMat, 'aCp', 'anodalCp', 'aLp', 'anodalLp', '-append');
end

if ~isempty(Rand)
    [Cprand, Lprand]=cellfun(@(r) RandSmallWorld(r, SType, NType), Rand,...
        'UniformOutput', false);
    Cprand=cell2mat(Cprand);
    Lprand=cell2mat(Lprand);
    Cpzscore=(Cp-mean(Cprand))./std(Cprand);
    Lpzscore=(Lp-mean(Lprand))./std(Lprand);
    Gamma=Cp./mean(Cprand);
    Lambda=Lp./mean(Lprand);
    Sigma=Gamma./Lambda;
    save(SWMat, 'Cpzscore', 'Lpzscore',...
        'Gamma', 'Lambda', 'Sigma', '-append');
    if numel(Thres)>1
        deltas=Thres(2)-Thres(1);
        aCpzscore=(sum(Cpzscore)-sum(Cpzscore([1 end]))/2)*deltas;
        aLpzscore=(sum(Lpzscore)-sum(Lpzscore([1 end]))/2)*deltas;
        aGamma=(sum(Gamma)-sum(Gamma([1 end]))/2)*deltas;
        aLambda=(sum(Lambda)-sum(Lambda([1 end]))/2)*deltas;
        aSigma=(sum(Sigma)-sum(Sigma([1 end]))/2)*deltas;
        save(SWMat, 'aCpzscore', 'aLpzscore',...
            'aGamma', 'aLambda', 'aSigma', '-append');
    end
end

function [Cp, Lp]=RandSmallWorld(A, SType, NType)
if strcmpi(NType, 'w')
    if strcmpi(SType, '1')
        [Cp, nodalCp]=cellfun(@(a) gretna_node_clustcoeff_weight(a, '1'), A,...
            'UniformOutput', false);
    elseif strcmpi(SType, '2')
        [Cp, nodalCp]=cellfun(@(a) gretna_node_clustcoeff_weight(a, '2'), A,...
            'UniformOutput', false);
    end
    [Lp, nodalLp]=cellfun(@(a) gretna_node_shortestpathlength_weight(a), A,...
        'UniformOutput', false);
elseif strcmpi(NType, 'b')
    [Cp, nodalCp]=cellfun(@(a) gretna_node_clustcoeff(a), A,...
        'UniformOutput', false);
    [Lp, nodalLp]=cellfun(@(a) gretna_node_shortestpathlength(a), A,...
        'UniformOutput', false);
end
Cp=cell2mat(Cp);
Lp=cell2mat(Lp);
