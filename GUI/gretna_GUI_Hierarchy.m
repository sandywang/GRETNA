function gretna_GUI_Hierarchy(SegMat, RandMat, NType, TempDir)
SegMat=load(SegMat);
A=SegMat.A;
if ~isempty(RandMat)
    RandMat=load(RandMat);
    Rand=RandMat.Rand;
else
    Rand=[];
end

b=cellfun(@(a) Hierarchy(a, NType), A,...
    'UniformOutput', false);
b=cell2mat(b);

HIEMat=fullfile(TempDir, 'HIEMat.mat');
if exist(HIEMat, 'file')~=2
    save(HIEMat, 'b');
else
    save(HIEMat, 'b', '-append');
end

if ~isempty(Rand)
    brand=cellfun(@(rn) RandHierarchy(rn, NType), Rand,...
        'UniformOutput', false);
    bzscore=(b-cell2mat(cellfun(@(m) Mean(m), brand, 'UniformOutput', false)))...
        ./cell2mat(cellfun(@(m) Std(m), brand, 'UniformOutput', false));
    save(HIEMat, 'bzscore', '-append');
end

function b=Hierarchy(Matrix, NType)
if strcmpi(NType, 'w')
    [deg, ki]=gretna_node_degree_weight(Matrix);
    [Cp, nodalCp]=gretna_node_clustcoeff_weight(Matrix, 2);   
elseif strcmpi(NType, 'b')
    [deg, ki]=gretna_node_degree(Matrix);
    [Cp, nodalCp]=gretna_node_clustcoeff(Matrix);
end

if all(nodalCp == 0) || all(ki == 0)
    b=nan;
else
    index1=find(ki==0);
    index2=find(nodalCp==0);
    ki([index1 index2]) = [];
    nodalCp([index1 index2]) = [];

    stats=regstats(log(nodalCp),log(ki),'linear','beta');
    b=-stats.beta(2);
end     

function brand=RandHierarchy(A, NType)
brand=cellfun(@(a) Hierarchy(a, NType), A,...
    'UniformOutput', false);
brand=cell2mat(brand);

function out=Mean(in)
out=mean(in(~isnan(in)));

function out=Std(in)
out=std(in(~isnan(in)));