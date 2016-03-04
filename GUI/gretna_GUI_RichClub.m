function gretna_GUI_RichClub(SegMat, RandMat, NType, TempDir)
SegMat=load(SegMat);
A=SegMat.A;
if ~isempty(RandMat)
    RandMat=load(RandMat);
    Rand=RandMat.Rand;
else
    Rand=[];
end

if strcmpi(NType, 'w')
    phi_real=cellfun(@(a) gretna_rich_club_weight(a), A,...
        'UniformOutput', false);
elseif strcmpi(NType, 'b')
    phi_real=cellfun(@(a) gretna_rich_club(a), A,...
        'UniformOutput', false);
end
phi_real=cell2mat(phi_real')';

RCMat=fullfile(TempDir, 'RCMat.mat');
if exist(RCMat, 'file')~=2
    save(RCMat, 'phi_real');
else
    save(RCMat, 'phi_real', '-append');
end

if ~isempty(Rand)
    % Overall phi from random networks
    phi_rand=cellfun(@(r) RandRichClub(r, NType), Rand,...
        'UniformOutput', false);
    phi_rand=cell2mat(phi_rand')';
    phi_norm=phi_real./phi_rand;
    save(RCMat, 'phi_norm', '-append');
end

function phi=RandRichClub(A, NType)
if strcmpi(NType, 'w')
    phi=cellfun(@(a) gretna_rich_club_weight(a), A,...
        'UniformOutput', false);
elseif strcmpi(NType, 'b')
    phi=cellfun(@(a) gretna_rich_club(a), A,...
        'UniformOutput', false);
end
phi=cell2mat(phi);
phi=mean(phi);