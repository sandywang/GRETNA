function [Comnet, Comnet_P] = gretna_TTest1_NBS(GroupMatrix, NMsk, CovCells, Base, PThr, PThr_Comp, TMap, PMap, M)
% Reference
% 1.Zalesky et al. (2010): Network-based statistic: Identifying differences
%   in brain networks. Neuroimage.
%
% Written by Xindi WANG
% State Key Laboratory of Cognitive Neuroscience and Learning & IDG/McGovern 
% Institute for Brain Research, Beijing Normal University, Beijing, China
% sandywang.rest@gmail.com
%==========================================================================
N=size(TMap, 1);
    
% Permutation test
NumOfSample=size(GroupMatrix{1}, 1);
RandMat=GroupMatrix{1};
RandMat=cat(3, RandMat, Base*ones([NumOfSample, size(RandMat, 2)]));
max_PosNumofEdge_rand = zeros(M,1);
max_NegNumofEdge_rand = zeros(M,1);

MIndex=triu(true(N), 1);
MIndex=MIndex(:);
for num = 1:M
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
    TMap_rand=zeros(N*N, 1);
    PMap_rand=zeros(N*N, 1);
    TMap_rand(MIndex)=T_rand;
    PMap_rand(MIndex)=P_rand;
    TMap_rand=reshape(TMap_rand, [N, N]);
    PMap_rand=reshape(PMap_rand, [N, N]);
    TMap_rand=TMap_rand+TMap_rand';
    PMap_rand=PMap_rand+PMap_rand';
    PMap_rand=PMap_rand.*logical(NMsk);
    
    % Positive Component
    PosMap_rand=(PMap_rand<PThr).*(TMap_rand>0);
    [pos_ci_rand, pos_sizes_rand] = components(sparse(PosMap_rand));
    [pos_sort, pos_sort_ix]=sort(pos_sizes_rand, 'descend');
    max_edge=0;
    for i=pos_sort_ix'
        if pos_sizes_rand(i)==1
            break
        end
        index_subn=find(pos_ci_rand == i);
        subn=PosMap_rand(index_subn, index_subn);
        tmp_max_edge=sum(sum(subn))/2;
        max_edge=max([max_edge, tmp_max_edge]);
    end
    max_PosNumofEdge_rand(num, 1)=max_edge;
    
    % Negative Component
    NegMap_rand=(PMap_rand<PThr).*(TMap_rand<0);
    [neg_ci_rand, neg_sizes_rand] = components(sparse(NegMap_rand));
    neg_u=unique(neg_sizes_rand(neg_sizes_rand>1));

    [neg_sort, neg_sort_ix]=sort(neg_sizes_rand, 'descend');
    max_edge=0;
    for i=neg_sort_ix'
        if neg_sizes_rand(i)==1
            break
        end        
        index_subn=find(neg_ci_rand == i);
        subn=NegMap_rand(index_subn, index_subn);
        tmp_max_edge=sum(sum(subn))/2;
        max_edge=max([max_edge, tmp_max_edge]);
    end
    max_NegNumofEdge_rand(num, 1)=max_edge;    
end
Comnet=[];
Comnet_P=[];

PosMap_real=(PMap<PThr).*(TMap>0);    
[pos_ci_real, pos_sizes_real] = components(sparse(PosMap_real));
[pos_sort, pos_sort_ix]=sort(pos_sizes_real, 'descend');
for i=pos_sort_ix'
    if pos_sizes_real(i)==1
        break
    end
    index_subn=find(pos_ci_real == i);
    subn=PosMap_real(index_subn, index_subn);
    num_edge_real=sum(sum(subn))/2;
    
    cp=(1+length(find(max_PosNumofEdge_rand >= num_edge_real)))/(1+M);
    if cp<PThr_Comp
        msk=zeros(N);
        msk(:, index_subn)=1;
        msk(index_subn, :)=1;        
        
        Comnet=[Comnet; {'Pos', TMap.*(PMap<PThr).*(TMap>0).*msk, sprintf('P=%g', cp)}];
        Comnet_P=[Comnet_P; cp];
    end
end

NegMap_real=(PMap<PThr).*(TMap<0);
[neg_ci_real, neg_sizes_real] = components(sparse(NegMap_real));
[neg_sort, neg_sort_ix]=sort(neg_sizes_real, 'descend');
for i=neg_sort_ix'
    if neg_sizes_real(i)==1
        break
    end
    index_subn=find(neg_ci_real == i);
    subn=NegMap_real(index_subn, index_subn);
    num_edge_real=sum(sum(subn))/2;
    
    cp=(1+length(find(max_NegNumofEdge_rand >= num_edge_real)))/(1+M);
    if cp<PThr_Comp
        msk=zeros(N);
        msk(:, index_subn)=1;
        msk(index_subn, :)=1;        
        
        Comnet=[Comnet; {'Neg', TMap.*(PMap<PThr).*(TMap<0).*msk, sprintf('P=%g', cp)}];
        Comnet_P=[Comnet_P; cp];
    end
end

function V=Flip(V, Flag)
if Flag==-1
    V=flipdim(V, 3);
end