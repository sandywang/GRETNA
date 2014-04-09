function gretna_GUI_Modularity(SegMat, RandMat, MType, TempDir)
SegMat=load(SegMat);
A=SegMat.A;
if ~isempty(RandMat)
    RandMat=load(RandMat);
    Rand=RandMat.Rand;
else
    Rand=[];
end

[number_of_module, community_index, modularity]=cellfun(@(a) Modularity(a, MType), A,...
    'UniformOutput', false);
number_of_module=cell2mat(number_of_module);
community_index=cell2mat(community_index);
modularity=cell2mat(modularity);

MODMat=fullfile(TempDir, 'MODMat.mat');
if exist(MODMat, 'file')~=2
    save(MODMat, 'number_of_module', 'community_index', 'modularity');
else
    save(MODMat, 'number_of_module', 'community_index', 'modularity', '-append');
end

if ~isempty(Rand)
    [number_of_module_rand, modularity_rand]=cellfun(@(rn) RandModularity(rn, MType), Rand,...
        'UniformOutput', false);
    number_of_module_rand=cell2mat(number_of_module_rand);
    modularity_rand=cell2mat(modularity_rand);
    number_of_module_zscore=(number_of_module-mean(number_of_module_rand))./std(number_of_module_rand);
    modularity_zscore=(modularity-mean(modularity_rand))./std(modularity_rand);
    save(MODMat, 'number_of_module_zscore', 'modularity_zscore', '-append');
end

function [ModNum, Ci, Q]=Modularity(Matrix, MType)
if strcmpi(MType, '1')
    [Ci, Q]=gretna_modularity_Danon(Matrix);
elseif strcmpi(MType, '2')
    [Ci, Q]=gretna_modularity_Newman(Matrix);
end
ModNum=max(Ci);

function [ModNumRand, QRand]=RandModularity(A, MType)
[ModNumRand, CiRand, QRand]=cellfun(@(a) Modularity(a, MType), A,...
    'UniformOutput', false);
ModNumRand=cell2mat(ModNumRand);
QRand=cell2mat(QRand);
