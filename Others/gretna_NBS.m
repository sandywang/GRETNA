function [T P NumofEdge_real Comnet max_NumofEdge_rand P_com] = gretna_NBS(Mat_Group1, Mat_Group2, P_thr, Tail, M, Mask_net, Path_covariate)

%==========================================================================
% This function is used to perform NBS algorithm to search connected
% components that show significant between-group differences. NOTE, the
% current version is only applicable to two groups.
%
%
% Syntax: function [T P NumofEdge_real Comnet max_NumofEdge_rand P_com] = gretna_NBS(Mat_Group1, Mat_Group2, P_thr1, Tail, M, Mask_Net, Path_covariate)
%
% Inputs:
%       Mat_Group1:
%                   The 3D (N*N*m1) connectivity matrices of subjects in
%                   group 1 with the last dimensionality being subjects.
%       Mat_Group2:
%                   The 3D (N*N*m2) connectivity matrices of subjects in
%                   group 2 with the last dimensionality being subjects.
%       P_thr:
%                   The p-value threshold used to determine suprathreshold
%                   connectivity matrix.
%       Tail:
%                   The same to functions of ttest2 in matlab:
%                   'right' for Group1 >  Group2;
%                   'left'  for Group1 <  Group2;
%                   'both'  for Group1 ~= Group2.
%       M:
%                   The number of permutation.
%       Mask_net:
%                   The matrix mask containing 0 and 1 and only connections
%                   corresponding to 1 are entered in the NBS computation.
%       Path_covariate:
%                   The directory & filename of a .txt file that contains
%                   multiple column vectors of covariates. NOTE, the length
%                   of each column vector should be m1+m2 and the order of
%                   each column vector should be the same to the order of
%                   subjects in gorup1 and then group2.
%
% Outputs:
%       T:
%                   T values of between-group differences for each
%                   connection.
%       P:
%                   Significance level of between-group differences for
%                   each connection.
%       NumofEdge_real:
%                   The number of edges in each component as listed in Comnet.
%       Comnet:
%                   A n*1 cell with each cell containing a component
%                   identified. The components are listed in the descend
%                   order of number of edges.
%       max_NumofEdge_rand:
%                   The null distribution of maximum component size.
%       P_com:
%                   The corrected p-value for each component as listed in
%                   Comnet.
%
% Reference
% 1.Zalesky et al. (2010): Network-based statistic: Identifying differences
%   in brain networks. Neuroimage.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2010/12/28, Jinhui.Wang.1982@gmail.com
%==========================================================================

dim1  = size(Mat_Group1);
dim2  = size(Mat_Group2);

T = zeros(dim1(1)); P = zeros(dim1(1));

Vec_Group1 = reshape(Mat_Group1,dim1(1)*dim1(2),dim1(3));
Vec_Group2 = reshape(Mat_Group2,dim2(1)*dim2(2),dim2(3));

index = find(triu(Mask_net,1));

Vec_Group1 = Vec_Group1(index,:);
Vec_Group2 = Vec_Group2(index,:);

if nargin == 6
    [~,significance,~,stats] = ttest2(Vec_Group1, Vec_Group2, 0.05, Tail, 'unequal', 2);
    T(index) = stats.tstat; P(index) = significance;
else
    Covariate = load(Path_covariate);
    group_ind = [ones(dim1(3),1); zeros(dim2(3),1)];
    predic = [group_ind Covariate];
    
    [stats] = gretna_glm([Vec_Group1'; Vec_Group2'], predic, 't', 1);
    T(index) = stats.t;
    if strcmpi(Tail, 'right')
        significance = tcdf(-stats.t,stats.df);
    elseif strcmpi(Tail, 'left')
        significance = tcdf(stats.t,stats.df);
    else
        significance = 2 .* tcdf(-abs(stats.t),stats.df);
    end
    P(index) = significance;
end

T = T + T'; P = P + P';

Mat_suprathres = P;
Mat_suprathres(Mat_suprathres > P_thr) = 0;
Mat_suprathres(logical(Mat_suprathres)) = 1;

if sum(Mat_suprathres(:))/2 > 2
    [ci_real sizes_real] = components(sparse(Mat_suprathres));
    
    Ind_com = find(sizes_real > 1);
    N_com = length(Ind_com);
    
    Comnet = cell(N_com,1);
    NumofEdge_real = zeros(N_com,1);
    P_com = zeros(N_com,1);
    
    % number of links in each component
    for i = 1:N_com
        index_subn = find(ci_real == Ind_com(i));
        subn = Mat_suprathres(index_subn, index_subn);
        NumofEdge_real(i) = sum(sum(subn))/2;
        
        Comnet{i,1} = zeros(dim1(1));
        Comnet{i,1}(index_subn,index_subn) = subn;
    end
    
    [NumofEdge_real,IX] = sort(NumofEdge_real, 'descend');
    Comnet = Comnet(IX,1);
    
    % Permutation test
    RandMat = cat(2, Vec_Group1, Vec_Group2);
    max_NumofEdge_rand = zeros(M,1);
    
    for num = 1:M

        rand_index = randperm(dim1(3) + dim2(3));
        rand_group1 = RandMat(:,rand_index(1:dim1(3)));
        rand_group2 = RandMat(:,rand_index(dim1(3)+1:end));
        
        P_rand = zeros(dim1(1));
        
        if nargin == 6
            [~,significance,~,~] = ttest2(rand_group1, rand_group2, 0.05, Tail, 'unequal', 2);
            P_rand(index) = significance;   P_rand = P_rand + P_rand';
        else
            rand_predic = [group_ind Covariate(rand_index,:)];
            
            [stats] = gretna_glm([rand_group1'; rand_group2'], rand_predic, 't', 1);
            if strcmpi(Tail, 'right')
                significance = tcdf(-stats.t,stats.df);
            elseif strcmpi(Tail, 'left')
                significance = tcdf(stats.t,stats.df);
            else
                significance = 2 .* tcdf(-abs(stats.t),stats.df);
            end
            P_rand(index) = significance;   P_rand = P_rand + P_rand';
        end
        
        P_rand(P_rand > P_thr) = 0;
        P_rand(logical(P_rand)) = 1;
        
        [ci_rand sizes_rand] = components(sparse(P_rand));
        NumofEdge_rand = zeros(length(sizes_rand),1);
        
        for j = 1:length(sizes_rand)
            index_subn = find(ci_rand == j);
            if length(index_subn) == 1
                NumofEdge_rand(j) = 0;
            else
                subn = P_rand(index_subn, index_subn);
                NumofEdge_rand(j) = sum(sum(subn))/2;
            end
        end
        max_NumofEdge_rand(num) = max(NumofEdge_rand);
    end
    
    for i = 1:N_com
        P_com(i) = length(find(max_NumofEdge_rand > NumofEdge_real(i)))/M;
    end
    
else
    fprintf('There is no or only one suprathreshold connection at the specified threshold of %d, please relax the threshold. \n', P_thr);
    NumofEdge_real = [];
    Comnet = [];
    max_NumofEdge_rand = [];
    P_com = [];
end

return