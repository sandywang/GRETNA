function [Sparsity, Eff] = gretna_effdiff_sparsity (group1, group2, s1, s2, deltas, num_rand)

% *************************************************************************
% * The function is used to calculate the differences in the small-world
% efficiency between the groups (e.g. normal vs. patient) over a large
% range of sparsity threshold. For example, when selecting a given sparisty 
% threshold (e.g. 0.1) for the two groups, we can calculate the small-world
% efficiency (global and local efficiency) of each network and compare the
% between-group difference using random permutation methods. It should be
% noted that the edges of each thresholded network are those connections
% showing the top higher correlations (e.g. 0.1*(N*(N-1)/2), N is the
% number of brain regions) in each group. If there are significant
% differences in small-world efficiency, so we can conclude that the
% differences might reflect the different brain organization between the
% groups since the two networks have the same number of nodes and sparsity
% (corresponding to the same number of edges).
% 
% function [Sparsity, Eff] = gretna_effdiff_sparsity (group1, group2,
% s1, s2, deltas, num_rand)
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
%           s1,s2,deltas:
%                   The sparsity threshold of the graph. 0<s1<=s2<1. deltas
%                   = 0.1(default); 
%           num_rand: 
%                   The number of permutation tests (default = 400).
% output:
%           Eff.gE1; Eff.gE2:
%                   The global efficiency of the group1, group2 networks at
%                   a large range sparsity (s1<s<s2).
%           Eff.locE1; Eff.locE2:
%                   The local efficiency of the group1, group2 networks at
%                   a large range sparsity (s1<s<s2).
%           Eff.locE12_diff_z (Eff.locE12_diff_z):
%                   The difference in global (local) efficiency between the
%                   two groups at a large range of sparsity.
%           Sparsity:
%                   The sparsity of a network was defined as the number of
%                   connections divided by the maximum possible number of
%                   connections in the network. Here it should be the same
%                   for the two groups.
% 
% Examples: 
% 1. calculating the small-world efficiency differences between-group at a 
%     given sparsity threshold of  0.1; (1000 permutation test). 
% 
%     [Sparsity, Eff] = gretna_effdiff_sparsity (group1, group2, 0.1,
%     0.1, 0.2, 1000); 
% 
% 2. calculating the small-world differences between-group over a range of
%     sparsity threshold of 0.01~0.40 at an interval of 0.02; (1000
%     permutation test). 
% 
%     [Sparsity,Eff] = gretna_effdiff_sparsity (group1, group2, 0.01,
%     0.4, 0.02, 1000); 
% 
% Yong HE, BIC,MNI, McGill 2007/05/01
% *************************************************************************


if nargin < 2
    error('No parameters');end

if nargin == 2
    N1 = size(group1,2);
    s1 = 0.01; s2 = 0.40; deltas = 0.02; num_rand = 400;end

if nargin > 6
    error('The number of input parameters should be less than 7.'); end

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

% caluculate the global and local efficiency of nc and ad groups over a
% range of sparsity threshold, and compare the between-group significances
% by a randomized procedure.

Sparsity = s1:deltas:s2
ns = length(Sparsity);

for m = 1:ns
    fprintf('\nm = %d\n',m);

    % global and local efficiency in the group1
    [corrmatrix1, r] = gretna_R2b(R_matrix1, 's', Sparsity(m));
    [sw]  = gretna_efficiency(corrmatrix1);
    Eff.gE.gE1(m) = sw.gE; 
    Eff.locE.locE1(m) = sw.locE;

    % global and local efficiency in the group2
    [corrmatrix2, r] = gretna_R2b(R_matrix2, 's', Sparsity(m));
    [sw]  = gretna_efficiency(corrmatrix2);
    Eff.gE.gE2(m) = sw.gE; 
    Eff.locE.locE2(m) = sw.locE;
end

deltagE = Eff.gE.gE1-Eff.gE.gE2;
deltalocE = Eff.locE.locE1-Eff.locE.locE2;

% the area under the Cp, Lp curves of the two networks over a range of sparsity.
Eff.agE.agE1 = (sum(Eff.gE.gE1) -  sum(Eff.gE.gE1([1 end]))/2)*deltas;
Eff.agE.agE2 = (sum(Eff.gE.gE2) -  sum(Eff.gE.gE2([1 end]))/2)*deltas;
Eff.alocE.alocE1 =  (sum(Eff.locE.locE1) -  sum(Eff.locE.locE1([1 end]))/2)*deltas;
Eff.alocE.alocE2 =  (sum(Eff.locE.locE2) -  sum(Eff.locE.locE2([1 end]))/2)*deltas;
deltaagE = Eff.agE.agE1 - Eff.agE.agE2;
deltaalocE = Eff.alocE.alocE1 - Eff.alocE.alocE2;

% a randomization procedure is used to detect the significance of the
% difference of Cp Lp
fprintf('\n\nCalculating the network parameters of randomized groups.\n')
rerand_locE12_diff = zeros(num_rand,length(Sparsity));
rerand_gE12_diff = zeros(num_rand,length(Sparsity));
for i = 1: num_rand
    fprintf('\n i = %d\n',i);
    %fprintf('-');
    rp = randperm(N_tgroup);
    rerand_corr_1 = abs(corrcoef(tgroup_Reg(rp(1:N1),:))) ;
    rerand_corr_2 = abs(corrcoef(tgroup_Reg(rp ((N1+1):N_tgroup),:))) ;
    rerand_corr_1 = rerand_corr_1 - diag(diag(rerand_corr_1));
    rerand_corr_2 = rerand_corr_2 - diag(diag(rerand_corr_2));

    for m = 1:ns
        [corrmatrix1, r] = gretna_R2b(rerand_corr_1, 's', Sparsity(m));
        [corrmatrix2, r] = gretna_R2b(rerand_corr_2, 's', Sparsity(m));
        [eff1]  = gretna_efficiency(corrmatrix1);
        [eff2]  = gretna_efficiency(corrmatrix2);
        rerand_locE12_diff(i,m) = eff1.locE - eff2.locE;
        rerand_gE12_diff(i,m) = eff1.gE - eff2.gE;
    end
end

%
for m = 1:ns
    if deltagE(m) >=0
        Eff.gE.gE12_diff_p(m) = length(find(rerand_gE12_diff(:,m)>deltagE(m)))/(num_rand+1);
    else
        Eff.gE.gE12_diff_p(m) = length(find(rerand_gE12_diff(:,m)<deltagE(m)))/(num_rand+1);
    end
    [sortmaxmingE12diff ] = sort(rerand_gE12_diff(:,m));
    Eff.gE.lower95gE12diff (m)= sortmaxmingE12diff(ceil((num_rand+1)*0.05));
    Eff.gE.upper95gE12diff (m) = sortmaxmingE12diff(end-ceil((num_rand+1)*0.05)-1);
    Eff.gE.rerand_gE12diff_mean (m) = mean(rerand_gE12_diff(:,m));

    if deltalocE(m) >=0
        Eff.locE.locE12_diff_p(m) = length(find(rerand_locE12_diff(:,m)>deltalocE(m)))/(num_rand+1);
    else
        Eff.locE.locE12_diff_p(m) = length(find(rerand_locE12_diff(:,m)<deltalocE(m)))/(num_rand+1);
    end
    [sortmaxminlocE12diff ] = sort(rerand_locE12_diff(:,m));
    Eff.locE.lower95locE12diff (m)= sortmaxminlocE12diff(ceil((num_rand+1)*0.05));
    Eff.locE.upper95locE12diff (m) = sortmaxminlocE12diff(end-ceil((num_rand+1)*0.05)-1);
    Eff.locE.rerand_locE12diff_mean (m) = mean(rerand_locE12_diff(:,m));
end




%the significance of difference in the area under the gE curve
% rerand_agE12_diff = mean(rerand_gE12_diff,2)*(Sparsity(end)-Sparsity(1));
rerand_agE12_diff = (sum(rerand_gE12_diff')' - mean(rerand_gE12_diff(:,[1 end]),2))*deltas;

if deltaagE >=0
    Eff.agE.agE12_diff_p = length(find(rerand_agE12_diff>deltaagE))/(num_rand+1);
else
    Eff.agE.agE12_diff_p = length(find(rerand_agE12_diff<deltaagE))/(num_rand+1);
end
[sortmaxminagE12diff ] = sort(rerand_agE12_diff);
Eff.agE.lower95agE12diff = sortmaxminagE12diff(ceil((num_rand+1)*0.05));
Eff.agE.upper95agE12diff = sortmaxminagE12diff(end-ceil((num_rand+1)*0.05)-1);
Eff.agE.rerand_agE12diff_mean = mean(rerand_agE12_diff);

%the significance of difference in the area under the localE curve
% rerand_alocE12_diff =
% mean(rerand_locE12_diff,2)*(Sparsity(end)-Sparsity(1));
rerand_alocE12_diff = (sum(rerand_locE12_diff')' - mean(rerand_locE12_diff(:,[1 end]),2))*deltas;
if deltaalocE >=0
    Eff.alocE.alocE12_diff_p = length(find(rerand_alocE12_diff>deltaalocE))/(num_rand+1);
else
    Eff.alocE.alocE12_diff_p = length(find(rerand_alocE12_diff<deltaalocE))/(num_rand+1);
end
[sortmaxminalocE12diff] = sort(rerand_alocE12_diff);
Eff.alocE.lower95alocE12diff = sortmaxminalocE12diff(ceil((num_rand+1)*0.05));
Eff.alocE.upper95alocE12diff = sortmaxminalocE12diff(end-ceil((num_rand+1)*0.05)-1);
Eff.alocE.rerand_alocE12diff_mean = mean(rerand_alocE12_diff);


