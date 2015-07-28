function gretna_GUI_Modularity(SegMat, RandMat, NType, MType, TempDir)
SegMat=load(SegMat);
A=SegMat.A;
if ~isempty(RandMat)
    RandMat=load(RandMat);
    Rand=RandMat.Rand;
else
    Rand=[];
end

[number_of_module, community_index, modularity, size_of_maximum_component, module_property]=...
    cellfun(@(a) Modularity(a, NType, MType, true), A, 'UniformOutput', false);
number_of_module=cell2mat(number_of_module);
community_index=cell2mat(community_index);
modularity=cell2mat(modularity);
size_of_maximum_component=cell2mat(size_of_maximum_component);

MODMat=fullfile(TempDir, 'MODMat.mat');
if exist(MODMat, 'file')~=2
    save(MODMat, 'number_of_module', 'community_index', 'modularity', 'size_of_maximum_component', 'module_property');
else
    save(MODMat, 'number_of_module', 'community_index', 'modularity', 'size_of_maximum_component', 'module_property', '-append');
end

if ~isempty(Rand)
    [number_of_module_rand, modularity_rand]=cellfun(@(rn) RandModularity(rn, NType, MType), Rand,...
        'UniformOutput', false);
    number_of_module_rand=cell2mat(number_of_module_rand);
    modularity_rand=cell2mat(modularity_rand);
    number_of_module_zscore=(number_of_module-mean(number_of_module_rand))./std(number_of_module_rand);
    modularity_zscore=(modularity-mean(modularity_rand))./std(modularity_rand);
    save(MODMat, 'number_of_module_zscore', 'modularity_zscore', '-append');
end

function [ModNum, Ci, Q, SizeOfMaxComp, ModStruct]=Modularity(Matrix, NType, MType, RealFlag)
SizeOfMaxComp=[];
ModStruct=[];
if ~RealFlag
    if strcmpi(MType, '1')
        [Ci, Q]=gretna_modularity_Danon(Matrix);
    elseif strcmpi(MType, '2')
        [Ci, Q]=gretna_modularity_Newman(Matrix);
    end
    ModNum=max(Ci);
    return
end
N=size(Matrix, 1);
[CompIndex, Sizes]=components(sparse(Matrix));
[SizeOfMaxComp, CompPos]=max(Sizes);
CompIndex=CompIndex==CompPos;
TmpMatrix=Matrix(CompIndex, CompIndex);

if strcmpi(MType, '1')
    [TmpCi, Q]=gretna_modularity_Danon(TmpMatrix);
elseif strcmpi(MType, '2')
    [TmpCi, Q]=gretna_modularity_Newman(TmpMatrix);
end
Ci=zeros(N, 1);
Ci(CompIndex, 1)=TmpCi;
ModNum=max(Ci);
% Degree in module and degree between modules
for i=1:ModNum
    ind_i=TmpCi==i;
    WithinSubNet=TmpMatrix(ind_i, ind_i);
    if strcmpi(NType, 'b')
        WithinSumEdgeNum=sum(WithinSubNet(:))./2;
        ModStruct.(sprintf('SumEdgeNum_Within_Module%.2d', i))=WithinSumEdgeNum;
    elseif strcmpi(NType, 'w')
        WithinSumStrength=sum(WithinSubNet(:))./2;
        WithinB=logical(WithinSubNet);
        WithinSumEdgeNum=sum(WithinB(:))./2;
        WithinAvgStrength=WithinSumStrength./WithinSumEdgeNum;
        WithinAvgStrength(isnan(WithinAvgStrength))=0;
        ModStruct.(sprintf('SumStrength_Within_Module%.2d', i))=WithinSumStrength;
        ModStruct.(sprintf('AvgStrength_Within_Module%.2d', i))=WithinAvgStrength;    
    end
    if i~=ModNum
        for j=i+1:ModNum
            ind_j=TmpCi==j;
            BetweenSubNet=TmpMatrix(ind_i, ind_j);
            if strcmpi(NType, 'b')
                BetweenSumEdgeNum=sum(BetweenSubNet(:));
                ModStruct.(sprintf('SumEdgeNum_Between_Module%.2d_%.2d', i, j))=BetweenSumEdgeNum;            
            elseif strcmpi(NType, 'w')
                BetweenSumStrength=sum(BetweenSubNet(:));
                BetweenB=logical(BetweenSubNet);
                BetweenSumEdgeNum=sum(BetweenB(:));
                BetweenAvgStrength=BetweenSumStrength./BetweenSumEdgeNum;
                BetweenAvgStrength(isnan(BetweenAvgStrength))=0;
                ModStruct.(sprintf('SumStrength_Between_Module%.2d_%.2d', i, j))=BetweenSumStrength;
                ModStruct.(sprintf('AvgStrength_Between_Module%.2d_%.2d', i, j))=BetweenAvgStrength;
            end
        end
    end
end


function [ModNumRand, QRand]=RandModularity(A, NType, MType)
[ModNumRand, CiRand, QRand]=cellfun(@(a) Modularity(a, NType, MType, false), A,...
    'UniformOutput', false);
ModNumRand=cell2mat(ModNumRand);
QRand=cell2mat(QRand);
