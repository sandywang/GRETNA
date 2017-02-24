function [Comnet, P_com, NumofEdge_real, max_NumofEdge_rand] = gretna_TTest1_NBS(GroupMatrix, NMsk, CovCells, Base, PThr, PThr_Comp, PMap, M)
% Reference
% 1.Zalesky et al. (2010): Network-based statistic: Identifying differences
%   in brain networks. Neuroimage.
%
% Written by Xindi WANG
% State Key Laboratory of Cognitive Neuroscience and Learning & IDG/McGovern 
% Institute for Brain Research, Beijing Normal University, Beijing, China
% sandywang.rest@gmail.com
%==========================================================================
I=PMap < PThr;
N=size(I, 1);    
[ci_real, sizes_real] = components(sparse(I));
    
Ind_com = find(sizes_real > 1);
N_com = length(Ind_com);
    
Comnet = cell(N_com,1);
NumofEdge_real = zeros(N_com,1);
P_com = zeros(N_com,1);
    
% number of links in each component
for i = 1:N_com
    index_subn = find(ci_real == Ind_com(i));
    subn = I(index_subn, index_subn);
    NumofEdge_real(i) = sum(sum(subn))/2;
        
    Comnet{i,1} = zeros(N);
    Comnet{i,1}(index_subn,index_subn) = subn;
end
    
[NumofEdge_real,IX] = sort(NumofEdge_real, 'descend');
Comnet = Comnet(IX,1);
    
% Permutation test
NumOfSample=size(GroupMatrix{1}, 1);
RandMat=GroupMatrix{1};
RandMat=cat(3, RandMat, Base*ones([NumOfSample, size(RandMat, 2)]));
max_NumofEdge_rand = zeros(M,1);

MIndex=triu(true(N), 1);
MIndex=MIndex(:);
parfor num = 1:M
    fprintf('NBS-->Iteration: %d\n', num);
    Flag=-1*ones(NumOfSample, 1);
    Flag=arrayfun(@(x) x^randi(NumOfSample), Flag);
    
    TmpRandMat=num2cell(RandMat, [2, 3]);
    Flag=num2cell(Flag, 2);
    
    TmpRandMat=cellfun(@(v, f) Flip(v, f), TmpRandMat, Flag, 'UniformOutput', false);
    TmpRandMat=cell2mat(TmpRandMat);
    
    RandGroup=cell(2, 1);
    RandGroup{1, 1} = TmpRandMat(:, :, 1);
    RandGroup{2, 1} = TmpRandMat(:, :, 2);
    
    [T_rand, P_rand]=gretna_TTestPaired(RandGroup, CovCells); 
    %TMap_rand=zeros(N*N, 1);
    PMap_rand=zeros(N*N, 1);
    %TMap_rand(MIndex(:))=T_rand;
    PMap_rand(MIndex)=P_rand;
    %TMap_rand=reshape(TMap_rand, [N, N]);
    PMap_rand=reshape(PMap_rand, [N, N]);
    %TMap_rand=TMap_rand+TMap_rand';
    PMap_rand=PMap_rand+PMap_rand';
    PMap_rand=PMap_rand.*logical(NMsk);
    PMap_rand=PMap_rand < PThr;
     
    [ci_rand, sizes_rand] = components(sparse(PMap_rand));
    NumofEdge_rand = zeros(length(sizes_rand), 1);
        
    for j = 1:length(sizes_rand)
        index_subn = find(ci_rand == j);
        if length(index_subn) == 1
            NumofEdge_rand(j) = 0;
        else
            subn = PMap_rand(index_subn, index_subn);
            NumofEdge_rand(j) = sum(sum(subn))/2;
        end
    end
    max_NumofEdge_rand(num) = max(NumofEdge_rand);
end
    
for i = 1:N_com
    P_com(i)=(1+length(find(max_NumofEdge_rand >= NumofEdge_real(i))))/(1+M);
end

RmInd=true(N_com, 1);
for i = 1:N_com
    if P_com(i)<PThr_Comp
        RmInd(i)=false;
    end
end
Comnet(RmInd)=[];
P_com(RmInd)=[];

function V=Flip(V, Flag)
if Flag==-1
    V=flipdim(V, 3);
end