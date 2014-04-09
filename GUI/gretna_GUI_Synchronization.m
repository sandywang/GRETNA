function gretna_GUI_Synchronization(SegMat, RandMat, TempDir)
SegMat=load(SegMat);
A=SegMat.A;
if ~isempty(RandMat)
    RandMat=load(RandMat);
    Rand=RandMat.Rand;
else
    Rand=[];
end

s=cellfun(@(a) Synchronization(a), A,...
    'UniformOutput', false);
s=cell2mat(s);

SYNMat=fullfile(TempDir, 'SYNMat.mat');
if exist(SYNMat, 'file')~=2
    save(SYNMat, 's');
else
    save(SYNMat, 's', '-append');
end

if ~isempty(Rand)
    srand=cellfun(@(rn) RandSynchronization(rn), Rand,...
        'UniformOutput', false);
    szscore=(s-cell2mat(cellfun(@(m) Mean(m), srand, 'UniformOutput', false)))...
        ./cell2mat(cellfun(@(m) Std(m), srand, 'UniformOutput', false)); 
    save(SYNMat, 'szscore', '-append');
end

function s=Synchronization(Matrix)
deg=sum(Matrix);
D=diag(deg, 0);
G=D-Matrix;
Eigenvalue=sort(eig(G));
        
s=Eigenvalue(2)/Eigenvalue(end);

function srand=RandSynchronization(A)
srand=cellfun(@(a) Synchronization(a), A,...
    'UniformOutput', false);
srand=cell2mat(srand);

function out=Mean(in)
out=mean(in(~isnan(in)));

function out=Std(in)
out=std(in(~isnan(in)));