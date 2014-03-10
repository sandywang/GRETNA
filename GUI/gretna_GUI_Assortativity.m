function gretna_GUI_Assortativity(SegMat, RandMat, NType, TempDir)
SegMat=load(SegMat);
A=SegMat.A;
if ~isempty(RandMat)
    RandMat=load(RandMat);
    Rand=RandMat.Rand;
else
    Rand=[];
end

r=cellfun(@(a) Assortativity(a, NType), A,...
    'UniformOutput', false);
r=cell2mat(r);

ASSMat=fullfile(TempDir, 'ASSMat.mat');
if exist(ASSMat, 'file')~=2
    save(ASSMat, 'r');
else
    save(ASSMat, 'r', '-append');
end

if ~isempty(Rand)
    rrand=cellfun(@(rn) RandAssortativity(rn, NType), Rand,...
        'UniformOutput', false);
    rrand=cell2mat(rrand);
    rzscore=(r-mean(rrand))./std(rrand);
    save(ASSMat, 'rzscore', '-append');
end

function r=Assortativity(Matrix, NType)
if strcmpi(NType, 'w')
    H=sum(sum(Matrix))/2;
    Mat=Matrix;
    Mat(Mat~=0) = 1;
    deg=sum(Mat);
    [i, j, v] = find(triu(Matrix, 1));
    if issparse(deg)
        degi=spfun(@(ii) deg(ii), i);
        degj=spfun(@(jj) deg(jj), j);
    else
        degi=arrayfun(@(ii) deg(ii), i);
        degj=arrayfun(@(jj) deg(jj), j);
    end

    r=((sum(v.*degi.*degj)/H - (sum(0.5*(v.*(degi+degj)))/H)^2)...
        /(sum(0.5*(v.*(degi.^2+degj.^2)))/H - (sum(0.5*(v.*(degi+degj)))/H)^2));
elseif strcmpi(NType, 'b')
	deg=sum(Matrix);
    K=sum(deg)/2;
    [i, j]=find(triu(Matrix, 1));
    if issparse(deg)
        degi=spfun(@(ii) deg(ii), i);
        degj=spfun(@(jj) deg(jj), j);
    else
        degi=arrayfun(@(ii) deg(ii), i);
        degj=arrayfun(@(jj) deg(jj), j);
    end                     

    r=((sum(degi.*degj)/K - (sum(0.5*(degi+degj))/K)^2)...
        /(sum(0.5*(degi.^2+degj.^2))/K - (sum(0.5*(degi+degj))/K)^2));
end

function rrand=RandAssortativity(A, NType)
rrand=cellfun(@(a) Assortativity(a, NType), A,...
    'UniformOutput', false);
rrand=cell2mat(rrand);
