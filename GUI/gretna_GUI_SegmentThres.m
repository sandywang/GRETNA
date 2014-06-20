function gretna_GUI_SegmentThres(Matrix, PType, NType, TType, Thres, TempDir)
if ischar(Matrix)
    Matrix=load(Matrix);
end

Matrix=Matrix-diag(diag(Matrix));
if strcmpi(PType, 'p')
    Matrix=Matrix.*(Matrix > 0);
elseif strcmpi(PType, 'a')
    Matrix=abs(Matrix);
elseif strcmpi(PType, 'n')
    Matrix=abs(Matrix.*(Matrix < 0));
else
    error('gretna_GUI_SegmentThres: cannot tell Pos or Abs');
end
Thres=str2num(Thres);

[A, rthres]=arrayfun(@(thres) gretna_R2b(Matrix, TType, thres), Thres,...
    'UniformOutput', false);
if strcmpi(NType, 'w')
    A=cellfun(@(bin) bin.*Matrix, A, 'UniformOutput', false);
end

if exist(TempDir, 'dir')~=7
    mkdir(TempDir);
end

SegMat=fullfile(TempDir, 'SegMat.mat');
if exist(SegMat, 'file')~=2
    save(SegMat, 'A');
else
    save(SegMat, 'A', '-append');
end