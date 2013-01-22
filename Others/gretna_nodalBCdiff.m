function [Matrix, NodeBC] = gretna_nodalBCdiff(group1, group2, sparsity, num_rand)

% *************************************************************************
% The function is used to calculate the differences in nodal betweenness
% centrality between the groups at a given sparsity threshold. For
% example, when selecting a sparsity threshold of 0.1 for the two groups,
% we can calculate regional BC of each node of each network and compare
% the between-group difference using random permutation methods. If there
% is significant differences in nodal BC, so we can conclude that
% these nodes show significant different ablities in managing information
% flow in the networks.
%
% function [Matrix, NodeBC] = gretna_nodalBCdiff(group1, group2, sparsity,
% num_rand)
%
% input:
%           group1:
%                   cortical thickness matrix of group1 (s*N ). s: the
%                   number of subjects in group1; N: the number of brain
%                   regions (54 cortical regions in the jacob template).
%           group2:
%                   cortical thickness matrix of group1 (s*N ). s: the
%                   number of subjects in group2; N: the number of brain
%                   regions.
%               sparsity:
%                   The sparsity threshold of the graphs. 0<sparsity<1.
%                   sparsity = 0.1(default);
%           num_rand:
%                   The number of permutation tests (default = 400).
%
% output:
%           Matrix.bmatrix1:
%                   the binarized matrix of group1 at the sparsity
%                   threshold (s);
%           Matrix.bmatrix2:
%                   the binarized matrix of group2 at the sparsity
%                   threshold (s);
%           NodeBC.w.hub1:
%                   the regional efficiency of each node of the group1
%                   network
%           NodeBC.w.hub2:
%                   the regional efficiency of each node of the group2
%                   network
%           NodeBC.w.diff_p:
%                   the significance of differences in regional efficiency
%                   of each node between the networks.
%           NodeBC.w.rand_diff_mean, NodeBC.w.diff_upper95,
%           NodeBC.w.diff_lower95;
%                   the mean, 95% confidence interval of distribution in
%                   differences regional efficiency of each node
%           NodeBC.b.bhub1:
%                   the regional efficiency of each node of the group1
%                   network (averaged over two hemispheres)
%           NodeBC.b.bhub2:
%                   the regional efficiency of each node of the group2
%                   network (averaged over two hemispheres)
%
% example:
%
% [Matrix, NodeBC] = gretna_nodalBCdiff(group1, group2, sparsity, num_rand)
%
% Yong HE, BIC,MNI, McGill 2006/09/12
% *************************************************************************


if nargin < 2
    error('No input parameters');end

if nargin == 2
    N1 = size(group1,2);
    sparsity = 0.10;  num_rand = 400;end

if nargin == 3
    N1 = size(group1,2);
    num_rand = 400;end

if nargin > 4
    error('The number of parameters: <5'); end


N1 = size(group1,1);
N2 = size(group2,1);
N_tgroup = N1 + N2;
tgroup_Reg = [group1;group2];

R_matrix1 = corrcoef(group1);
R_matrix2 = corrcoef(group2);

N_region = size(R_matrix1,1);
R_matrix1 = abs(R_matrix1);
R_matrix2 = abs(R_matrix2);
R_matrix1 = R_matrix1 - diag(diag(R_matrix1));
R_matrix2 = R_matrix2 - diag(diag(R_matrix2));

% caluculate the Cp, Lp of nc, ad group at different average degree <K> and
% compare the between-group significance of Cp, Lp  by a randomized
% procedure


% nodal efficiency in the group1 network
[corrmatrix1, r] = gretna_R2b(R_matrix1, 's', sparsity);
% [eff] = gretna_efficiency (corrmatrix1);
[node_betweeness edge_betweeness] = gretna_betweeness(corrmatrix1,0);

Matrix.bmatrix1 = corrmatrix1;
NodeBC.w.hub1 = node_betweeness.ncen;
NodeBC.b.bhub1 = mean(...
    [NodeBC.w.hub1(2*(1:length(corrmatrix1)/2)) ...
    NodeBC.w.hub1(2*(1:length(corrmatrix1)/2)-1)], 2);
tmp1 = corrcoef( NodeBC.w.hub1(2*(1:length(corrmatrix1)/2)),...
    NodeBC.w.hub1(2*(1:length(corrmatrix1)/2)-1));
NodeBC.hemR.R1 = tmp1(2);

% nodal efficiency in the group2 network
[corrmatrix2, r] = gretna_R2b(R_matrix2, 's', sparsity);
% [eff] = gretna_efficiency (corrmatrix2);
[node_betweeness edge_betweeness] = gretna_betweeness(corrmatrix2,0);
Matrix.bmatrix2 = corrmatrix2;
NodeBC.w.hub2 = node_betweeness.ncen;
NodeBC.b.bhub2 = mean([NodeBC.w.hub2(2*(1:length(corrmatrix2)/2)) NodeBC.w.hub2(2*(1:length(corrmatrix2)/2)-1)],2);
tmp2 = corrcoef( NodeBC.w.hub2(2*(1:length(corrmatrix2)/2)),...
    NodeBC.w.hub2(2*(1:length(corrmatrix2)/2)-1));
NodeBC.hemR.R2 =tmp2(2);

NodeBC.w.diff =  NodeBC.w.hub1 - NodeBC.w.hub2 ;
NodeBC.hemR.Rdiff = NodeBC.hemR.R1-NodeBC.hemR.R2;

% a randomization procedure is used to detect the significance of the
%     % difference in regionally shortest path length of each node.
fprintf('\n');
ncount=1;
for i = 1: num_rand
    %     fprintf('-')
    i
    rp = randperm(N_tgroup);
    rerand_Reg1 = tgroup_Reg(rp(1:N1),:);
    rerand_Reg2 = tgroup_Reg(rp ((N1+1):N_tgroup),:);
    rerand_corr_1 = corrcoef(rerand_Reg1);
    rerand_corr_2 = corrcoef(rerand_Reg2);
    rerand_corr_1 = abs(rerand_corr_1) ;
    rerand_corr_2 = abs(rerand_corr_2) ;

    rerand_corr_1 = rerand_corr_1 - diag(diag(rerand_corr_1));
    rerand_corr_2 = rerand_corr_2 - diag(diag(rerand_corr_2));

    [randcorrmatrix, r] = gretna_R2b(rerand_corr_1, 's', sparsity);
    %     [randeff1] = gretna_efficiency (randcorrmatrix);
    [randnode_betweeness1 edge_betweeness] = gretna_betweeness(randcorrmatrix,0);
    randtmp1 = corrcoef( randnode_betweeness1.ncen(2*(1:length(randcorrmatrix)/2)),...
        randnode_betweeness1.ncen(2*(1:length(randcorrmatrix)/2)-1));
    rand.hemR.R1 =randtmp1(2);

    [randcorrmatrix, r] = gretna_R2b(rerand_corr_2, 's', sparsity);
    %     [randeff2] = gretna_efficiency (randcorrmatrix);
    [randnode_betweeness2 edge_betweeness] = gretna_betweeness(randcorrmatrix,0);
    randtmp2 = corrcoef( randnode_betweeness2.ncen(2*(1:length(randcorrmatrix)/2)),...
        randnode_betweeness2.ncen(2*(1:length(randcorrmatrix)/2)-1));
    rand.hemR.R2 =randtmp2(2);

    rerand_hub_diff(:,i) = ...
        randnode_betweeness1.ncen - ...
        randnode_betweeness2.ncen;

    rerand_hemR_diff(:,i) =...
        rand.hemR.R1-rand.hemR.R2;
end

[sortmaxminhemRdiff sortmaxminhemRdiffindex] = sort(rerand_hemR_diff);
NodeBC.hemR.rand_diff_mean = mean(rerand_hemR_diff);
NodeBC.hemR.diff_lower95  = sortmaxminhemRdiff(ceil((num_rand+1)*0.05));
NodeBC.hemR.diff_upper95  = sortmaxminhemRdiff(end-ceil((num_rand+1)*0.05)-1);
if NodeBC.hemR.Rdiff>=0
    NodeBC.hemR.Rdiff_p = ...
        length(find(rerand_hemR_diff>NodeBC.hemR.Rdiff))/(length(rerand_hemR_diff)+1);
else
    NodeBC.hemR.Rdiff_p = ...
        length(find(rerand_hemR_diff<NodeBC.hemR.Rdiff))/(length(rerand_hemR_diff)+1);
end


for i = 1:length(NodeBC.w.diff)
    [sortmaxminhubdiff sortmaxminhubdiffindex] = sort(rerand_hub_diff(i,:));
    NodeBC.w.rand_diff_mean(i,1) = mean(rerand_hub_diff(i,:));
    NodeBC.w.diff_lower95 (i,1) = sortmaxminhubdiff(ceil((num_rand+1)*0.05));
    NodeBC.w.diff_upper95 (i,1) = sortmaxminhubdiff(end-ceil((num_rand+1)*0.05)-1);
    if NodeBC.w.diff(i)>=0
        NodeBC.w.diff_p(i,1) = ...
            length(find(rerand_hub_diff(i,:)>NodeBC.w.diff(i)))/(length(rerand_hub_diff(i,:))+1);
    else
        NodeBC.w.diff_p(i,1) = ...
            length(find(rerand_hub_diff(i,:)<NodeBC.w.diff(i)))/(length(rerand_hub_diff(i,:))+1);
    end
end

fprintf('finished!\n')




% 
% 
% labels = {'SFG.R','SFG.L','MFG.R','MFG.L','IFG.R','IFG.L','MdFG.R','MdFG.L','PrCG.R','PrCG.L','LOFG.R','LOFG.L','MOFG.R','MOFG.L','SPL.R','SPL.L',...
%     'SMG.R','SMG.L','ANG.R','ANG.L','PCU.R','PCU.L','PoCG.R','PoCG.L','STG.R','STG.L','MTG.R','MTG.L','ITG.R','ITG.L','UNC.R','UNC.L','MOTG.R','MOTG.L',...
%     'LOTG.R','LOTG.L','PHG.R','PHG.L','OP.R','OP.L','SOG.R','SOG.L','MOG.R','MOG.L','IOG.R','IOG.L','CUN.R','CUN.L','LING.R','LING.L','CING.R','CING.L','INS.R','INS.L'}';
% 
% %figure 1:
% subplot(1,2,1);%nodal efficiency within group1
% [v ind] = sort(NodeBC.w.hub1);
% labels1 = labels((1:length(NodeBC.w.hub1)));
% for i =1:length(labels1)
%     labels1{i} = labels1{i};
% end
% bar(v ,0.5);ylabel('NEI')
% set(gca,'XTick',1:length(NodeBC.w.hub1))
% set(gca,'XTickLabel',labels1(ind),'FontSize',6)
% axis([0.5 54.5 0 4])
% view([90 270])
% 
% subplot(1,2,2);%nodal efficiency within group2
% [v ind] = sort(NodeBC.w.hub2);
% labels2 = labels((1:length(NodeBC.w.hub2)));
% for i =1:length(labels2)
%     labels2{i} = labels2{i};
% end
% bar(v ,0.5);ylabel('NEI')
% set(gca,'XTick',1:length(NodeBC.w.hub2))
% set(gca,'XTickLabel',labels2(ind),'FontSize',6)
% axis([0.5 54.5 0 4])
% view([90 270])
% colormap([ 1 1 1])
% 
% % figure 2: the differences in nodal efficiency between two groups
% figure;rcoplot(NodeBC.w.rand_diff_mean,[NodeBC.w.diff_upper95 NodeBC.w.diff_lower95 ]);
% xlabel('');ylabel('\Delta relative betweenness centrality');title('')
% hold on;plot(NodeBC.w.diff,'rs','MarkerSize',2,'MarkerFaceColor','r')
% set(gca,'XTick',1:1:54)
% set(gca,'XTickLabel',labels,'FontSize',6)
% axis([0.5 54.5 -4.2 4.2])
% view([90 90])
% 




%
%
% symnode1 = 0.5*abs((NodeBC.w.hub1(2*(1:27)) -NodeBC.w.hub1(2*(1:27)-1))./(NodeBC.w.hub1(2*(1:27)) +NodeBC.w.hub1(2*(1:27)-1)));
% symnode2 = 0.5*abs((NodeBC.w.hub2(2*(1:27)) -NodeBC.w.hub2(2*(1:27)-1))./(NodeBC.w.hub2(2*(1:27)) +NodeBC.w.hub2(2*(1:27)-1)));







