function gretna_GUI_GenerateRandNet(SegMat, NType, RType, RandNum, TempDir)
SegMat=load(SegMat);
A=SegMat.A;
Rand=cellfun(@(a) GenerateRandCell(a, NType, RType, RandNum), A,...
    'UniformOutput', false);
RandMat=fullfile(TempDir, 'RandMat.mat');
if exist(RandMat, 'file')~=2
    save(RandMat, 'Rand');
else
    save(RandMat, 'Rand', '-append');
end



function Rand=GenerateRandCell(A, NType, RType, RandNum)
Rand=cell(RandNum, 1);
if strcmpi(NType, 'w')
    if strcmpi(RType, '1')
        Rand=cellfun(@(r) gretna_gen_random_network1_weight(A), Rand,...
            'UniformOutput', false);
    elseif strcmpi(RType, '2')
        Rand=cellfun(@(r) gretna_gen_random_network2_weight(A), Rand,...
            'UniformOutput', false);
    end
elseif strcmpi(NType, 'b')
    if strcmpi(RType, '1')
        Rand=cellfun(@(r) gretna_gen_random_network1(A), Rand,...
            'UniformOutput', false);
    elseif strcmpi(RType, '2')
        Rand=cellfun(@(r) gretna_gen_random_network2(A), Rand,...
            'UniformOutput', false);
    end
end