function [Sparsity, PathLen, ClustCoff, Sigma] =...
    gretna_swdiff_sparsity (group1, group2, s1, s2, deltas, num_rand, brandnetwork)

% *************************************************************************
% The function is used to calculate the differences in the small-world
% parameters between the groups (e.g. normal vs. patient) over a large
% range of sparsity threshold. For example, when selecting a given sparisty
% threshold (e.g. 0.1) for the two groups, we can calculate the small-world
% properties (clustering and shortest path length) of each network and
% compare the between-group difference using random permutation methods. It
% should be noted that the edges of each thresholded network are those
% connections showing the top higher correlations (e.g. 0.1*(N*(N-1)/2), N
% is the number of brain regions) in each group. If there are significant
% differences in small-world properties, so we can conclude that the
% small-world differences might reflect the different brain organization
% between the groups since the two networks have the same number of nodes
% and sparsity (corresponding to the same number of edges). This function
% can also calculate the area under the Cp,Lp (Gamma, Lambda, Sigma) curves
% ([s1 s2]) and its signficance of between-group difference.
%
% function [Sparsity, PathLen, ClustCoff, Sigma] =
%               gretna_swdiff_sparsity(group1, group2, s1, s2, deltas,
%               num_rand, brandnetwork)
%
% input:
%           group1:
%                   cortical thickness matrix of group1 (s*N ). s: the
%                   number of subjects in group1; N: the number of brain
%                   regions (54 cortical regions in the jacob template).
%           group2:
%                   cortical thickness matrix of group2 (s*N ). s: the
%                   number of subjects in group2; N: the number of brain
%                   regions.
%           s1,s2,deltas:
%                   The sparsity threshold of the graph. 0<s1<=s2<1. deltas
%                   = 0.1(default);
%           num_rand:
%                   The number of random permutations;
%           brandnetwork:
%                   0: no random networks; only calucating the differneces
%                   in the Cp and Lp values between the two groups; 1:
%                   generating random networks to calucate the differences
%                   in the Gamma, Lambda and Sigma values between the two
%                   groups while calcuating small-world attributes.
%
% output:
%       PathLen:
%                   1). PathLen.Lp1 (PathLen.Lp2): The global average shortest
%                   path length of the group1(group2) networks over a large
%                   range of sparsity threshold;
%                   PathLen.lower95Lp12diff(PathLen.upper95Lp12diff): When
%                   performing 1000 random permutation test, the 95
%                   percentile points of the distribution of between-group
%                   differences in path length over a large range of
%                   sparsity threshold;
%                   PathLen.Lp12_diff_p: When performing 1000 random
%                   permutation test, the significance of the between-group
%                   difference in path length over a large range of
%                   sparsity threshold.
%
%                   2). PathLen.Lambda1(PathLen.Lambda2): The global
%                   average shortest path length ratio (Lpreal/Lprand)of
%                   the group1(group2) networks over a large range of
%                   sparsity threshold.
%                   PathLen.lower95Lambda12diff
%                   (PathLen.upper95Lambda12diff): When performing 1000
%                   random permutation test, the 95 percentile points of
%                   the distribution of between-group differences in path
%                   length ratio (real/random) over a large range of
%                   sparsity threshold.
%                   PathLen.Lambda12_diff_p: When performing 1000 random
%                   permutation test, the significance of the between-group
%                   difference in path length ratio over a large range of
%                   sparsity threshold.
%
%                   3). PathLen.aLp1 (PathLen.aLp2): The area under the Lp
%                   curves of the group1(group2) networks.
%                   PathLen.lower95aLp12diff(PathLen.upper95aLp12diff): When
%                   performing 1000 random permutation test, the 95
%                   percentile points of the distribution of between-group
%                   differences in the area under the Lp curves.
%                   PathLen.aLp12_diff_p: When performing 1000 random
%                   permutation test, the significance of the between-group
%                   difference in the area under the Lp curves.
%
%                    4). PathLen.aLambda1 (PathLen.aLambda2): The area
%                    under the Lambda curves of the group1(group2)
%                    networks.
%                    PathLen.lower95aLambda12diff
%                    (PathLen.upper95aLambda12diff): When  performing 1000
%                    random permutation test, the 95 percentile points of
%                    the distribution of between-group differences in the
%                    area under the Lambda curves.
%                    PathLen.aLambda12_diff_p: When performing 1000 random
%                    permutation test, the significance of the
%                    between-group difference in the area under the Lambda
%                    curves.
%
%       ClustCoff:
%                   1). ClustCoff.Cp1 (ClustCoff.Cp2): The global average
%                   cluster coefficient of the group1 (group2) network over
%                   a large range of sparsity threshold.
%                   ClustCoff.lower95Cp12diff (ClustCoff.upper95Cp12diff):
%                   When performing 1000 random permutation test, the 95
%                   percentile points of the distribution of between-group
%                   differences in clustering coefficient over a large
%                   range of sparsity threshold.  ClustCoff.Cp12_diff_p:
%                   When performing 1000 random permutation test, the
%                   significance of the between-group difference in
%                   clustering coefficienct over a large range of sparsity
%                   threshold.
%
%                  2). ClustCoff.Gamma1 (ClustCoff.Gamma2):The global
%                  average cluster coefficient ratio of the group1 (group2)
%                  network over a large range of sparsity threshold.
%                  ClustCoff.lower95Gamma12diff
%                  (ClustCoff.upperer95Gamma12diff):  When performing 1000
%                  random permutation test, the 95 percentile points of the
%                  distribution of between-group differences in clustering
%                  coefficient ratio over a large range of sparsity
%                  threshold. ClustCoff.Gamma12_diff_p: When performing
%                  1000 random permutation test, the significance of the
%                  between-group difference in clustering coefficienct
%                  ratio over a large range of sparsity threshold.
%
%                  3). ClustCoff.aCp1 (ClustCoff.aCp2): The area of Cp
%                  curve of the group1 (group2) network.
%                  ClustCoff.lower95aCp12diff (ClustCoff.upper95aCp12diff):
%                  When performing 1000 random permutation test, the 95
%                  percentile points of the distribution of between-group
%                  differences in the area under the Cp curves.
%                  ClustCoff.aCp12_diff_p: When performing 1000 random
%                  permutation test, the significance of the between-group
%                  difference in the area under the Cp curves
%
%                  4). ClustCoff.aGamma1 (ClustCoff.aGamma2):The area under
%                  the Gamma curves of the group1 (group2) network.
%                  ClustCoff.lower95aGamma12diff
%                  (ClustCoff.upperer95aGamma12diff):  When performing 1000
%                  random permutation test, the 95 percentile points of the
%                  distribution of between-group differences in the area
%                  under the Gamma curves. ClustCoff.aGamma12_diff_p: When
%                  performing 1000 random permutation test, the
%                  significance of the between-group difference in the area
%                  under the Gamma curves.
%
%        Sigma:
%                  1). Sigma.Sigma1 (Sigma.Sigma2): The small-worldness of
%                  the group1 (group2) network over a large range of sparsity
%                  threshold.  Sigma.lower95Sigma12diff,
%                  Sigma.upperer95Sigma12diff: When performing 1000 random
%                  permutation test, the 95 percentile points of the
%                  distribution of between-group differences in
%                  small-worldness over a large range of sparsity
%                  threshold.  Sigma.Sigma12_diff_p: When performing 1000
%                  random permutation test, the significance of the
%                  between-group difference in small-worldness over a large
%                  range of sparsity threshold.
%
%                  2). Sigma.aSigma1 (Sigma.aSigma2): The area under the
%                  Sigma curves of the group1 (group2) network.
%                  Sigma.lower95aSigma12diff, Sigma.upperer95aSigma12diff:
%                  When performing 1000 random permutation test, the 95
%                  percentile points of the distribution of between-group
%                  differences in the area under the Sigma curves.
%                  Sigma.aSigma12_diff_p: When performing 1000 random
%                  permutation test, the significance of the between-group
%                  difference in the area under the sigma curves.
%
%
%       Sparsity:
%                  The sparsity of a network was defined as the number of
%                  connections divided by the maximum possible number of
%                  connections in the network. Here it should be the same
%                  for the two groups.
%
% Examples:
% 1. (A)calculating the small-world differences (Cp,Lp) between groups at
%     an sparsity threshold of 0.1; (1000 permutation test).
%
%     [Sparsity, PathLen, ClustCoff, Sigma] = gretna_swdiff_sparsity
%     (group1, group2, 0.1, 0.1, 0.2, 1000);
%
%     (B)calculating the small-world differences (Cp,Lp, Gamma, Lambda,
%     Sigma) between groups at an sparsity threshold of 0.1; (1000
%     permutation test).(50 random networks,default).
%
%     [Sparsity, PathLen, ClustCoff, Sigma] = gretna_swdiff_sparsity
%     (group1, group2, 0.1, 0.1, 0.2, 1000, 1);
%
% 2. (A)calculating the small-world differences (Cp,Lp) between groups over
%     a range of sparsity threshold of 0.01~0.4 at an interval of 0.02;
%     (1000 permutation test).
%
%     [Sparsity, PathLen, ClustCoff, Sigma] =  gretna_swdiff_sparsity
%     (group1, group2, 0.01, 0.4, 0.02, 1000);
%
%     (B)calculating the small-world differences (Cp,Lp, Gamma, Lambda,
%     Sigma, aCp,aLp,aGamma, aLambda, aSigma) between groups over a range
%     of sparsity threshold of 0.01~0.4 at an interval of 0.02; (1000
%     permutation test) (50 random networks, default).
%
%     [Sparsity, PathLen, ClustCoff, Sigma] =  gretna_swdiff_sparsity
%     (group1, group2, 0.01, 0.4, 0.02, 1000, 1);
%
% Yong HE, BIC,MNI, McGill 2007/05/01
% *************************************************************************


if nargin < 2
    error('No parameters');end

if nargin == 2
    N1 = size(group1,2);
    s1 = 0.01; s2 = 0.40; deltas = 0.02; num_rand = 400;end

if nargin == 6
    brandnetwork = 0;end

if nargin > 7
    error('The number of parameters:<7'); end

% the number of random networks when diagonising small-world properties.
randwiring = 50;

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

Sparsity = s1:deltas:s2
ns = length(Sparsity);

if brandnetwork ==0;
    PathLen.Lp.Lp1 = zeros(1,ns);
    ClustCoff.Cp.Cp1 = zeros(1,ns);
    PathLen.Lp.Lp2 = zeros(1,ns);
    ClustCoff.Cp.Cp2 = zeros(1,ns);
    rerand_Lp12_diff =zeros(num_rand,ns);
    rerand_Cp12_diff =zeros(num_rand,ns);
else
    PathLen.Lambda.Lambda1 = zeros(1,ns);
    ClustCoff.Gamma.Gamma1 = zeros(1,ns);
    Sigma.Sigma.Sigma1 = zeros(1,ns);
    PathLen.Lambda.Lambda2 = zeros(1,ns);
    ClustCoff.Gamma.Gamma2 = zeros(1,ns);
    Sigma.Sigma.Sigma2 = zeros(1,ns);
    rerand_Lambda12_diff =zeros(num_rand,ns);
    rerand_Gamma12_diff =zeros(num_rand,ns);
    rerand_Sigma12_diff =zeros(num_rand,ns);
end


fprintf('\nCalculating the network parameters of two groups.\n')
for m = 1:ns
    fprintf('\nm = %d\n',m);

    % Cp Lp in the group1
    [corrmatrix1, r] = gretna_R2b(R_matrix1, 's', Sparsity(m));
    if brandnetwork == 0
        [NN, KK, degree, sw1]  = gretna_sw_harmonic(corrmatrix1,0,0);
    else
        [NN, KK, degree, sw1]  = gretna_sw_harmonic(corrmatrix1,1,randwiring);
        PathLen.Lambda.Lambda1(1,m) = sw1.Lambda;
        ClustCoff.Gamma.Gamma1(1,m) = sw1.Gamma;
        Sigma.Sigma.Sigma1 (1,m) = sw1.Sigma;
    end
    PathLen.Lp.Lp1(1,m) = sw1.Lp;
    ClustCoff.Cp.Cp1(1,m) = sw1.Cp;

    % Cp Lp in the group2
    [corrmatrix2, r] = gretna_R2b(R_matrix2, 's', Sparsity(m));
    if brandnetwork == 0
        [NN, KK, degree, sw2]  = gretna_sw_harmonic(corrmatrix2,0,0);
    else
        [NN, KK, degree, sw2]  = gretna_sw_harmonic(corrmatrix2,1,randwiring);
        PathLen.Lambda.Lambda2(1,m) = sw2.Lambda;
        ClustCoff.Gamma.Gamma2(1,m) = sw2.Gamma;
        Sigma.Sigma.Sigma2 (1,m) = sw2.Sigma;
    end
    PathLen.Lp.Lp2(1,m) = sw2.Lp;
    ClustCoff.Cp.Cp2(1,m) = sw2.Cp;
end

clear NN KK aveden degree sw1 sw2


deltaLp = PathLen.Lp.Lp1 - PathLen.Lp.Lp2;
deltaCp = ClustCoff.Cp.Cp1 - ClustCoff.Cp.Cp2;

% the area under the Cp, Lp curves of the two networks over a range of sparsity.
ClustCoff.aCp.aCp1 = (sum(ClustCoff.Cp.Cp1) -  sum(ClustCoff.Cp.Cp1([1 end]))/2)*deltas;
% mean(ClustCoff.Cp.Cp2)* (Sparsity(end)-Sparsity(1));
ClustCoff.aCp.aCp2 = (sum(ClustCoff.Cp.Cp2) -  sum(ClustCoff.Cp.Cp2([1 end]))/2)*deltas;
PathLen.aLp.aLp1 = (sum(PathLen.Lp.Lp1) -  sum(PathLen.Lp.Lp1([1 end]))/2)*deltas;
PathLen.aLp.aLp2 = (sum(PathLen.Lp.Lp2) -  sum(PathLen.Lp.Lp2([1 end]))/2)*deltas;
deltaaCp = ClustCoff.aCp.aCp1 - ClustCoff.aCp.aCp2;
deltaaLp = PathLen.aLp.aLp1 - PathLen.aLp.aLp2;


if brandnetwork==1
    deltaGamma = ClustCoff.Gamma.Gamma1 - ClustCoff.Gamma.Gamma2;
    deltaLambda = PathLen.Lambda.Lambda1 - PathLen.Lambda.Lambda2;
    deltaSigma = Sigma.Sigma.Sigma1 - Sigma.Sigma.Sigma2;

    % the area under the Gamma, Lambda, Sigma curves of the two networks
    % over a range of sparsity. % need to be revised

    ClustCoff.aGamma.aGamma1 = (sum(ClustCoff.Gamma.Gamma1) -  sum(ClustCoff.Gamma.Gamma1([1 end]))/2)*deltas;
    ClustCoff.aGamma.aGamma2 = (sum(ClustCoff.Gamma.Gamma2) -  sum(ClustCoff.Gamma.Gamma2([1 end]))/2)*deltas;
    PathLen.aLambda.aLambda1 = (sum(PathLen.Lambda.Lambda1) -  sum(PathLen.Lambda.Lambda1([1 end]))/2)*deltas;
    PathLen.aLambda.aLambda2 = (sum(PathLen.Lambda.Lambda2) -  sum(PathLen.Lambda.Lambda2([1 end]))/2)*deltas;
    Sigma.aSigma.aSigma1 = (sum(Sigma.Sigma.Sigma1) -  sum(Sigma.Sigma.Sigma1([1 end]))/2)*deltas;
    Sigma.aSigma.aSigma2 = (sum(Sigma.Sigma.Sigma2) -  sum(Sigma.Sigma.Sigma2([1 end]))/2)*deltas;

    deltaaGamma = ClustCoff.aGamma.aGamma1 - ClustCoff.aGamma.aGamma2;
    deltaaLambda = PathLen.aLambda.aLambda1 - PathLen.aLambda.aLambda2;
    deltaaSigma = Sigma.aSigma.aSigma1 - Sigma.aSigma.aSigma2;
end

% a randomization procedure is used to detect the significance of the
% difference of Cp Lp
fprintf('\n\nCalculating the network parameters of randomized groups.\n')
for i = 1: num_rand
    fprintf('\n i = %d\n',i);
    %fprintf('-');
    rp = randperm(N_tgroup);
    rerand_corr_1 = abs(corrcoef(tgroup_Reg(rp(1:N1),:))) ;
    rerand_corr_2 = abs(corrcoef(tgroup_Reg(rp ((N1+1):N_tgroup),:))) ;
    rerand_corr_1 = rerand_corr_1 - diag(diag(rerand_corr_1));
    rerand_corr_2 = rerand_corr_2 - diag(diag(rerand_corr_2));

    for m = 1:length(Sparsity)
        [corrmatrix1, r] = gretna_R2b(rerand_corr_1, 's', Sparsity(m));
        [corrmatrix2, r] = gretna_R2b(rerand_corr_2, 's', Sparsity(m));

        if brandnetwork == 0
            [NN, KK, degree, sw1]  = gretna_sw_harmonic(corrmatrix1,0,0);
            [NN, KK, degree, sw2]  = gretna_sw_harmonic(corrmatrix2,0,0);
        else
            [NN, KK, degree, sw1]  = gretna_sw_harmonic(corrmatrix1,1,randwiring);
            [NN, KK, degree, sw2]  = gretna_sw_harmonic(corrmatrix2,1,randwiring);
            rerand_Lambda12_diff(i,m) = sw1.Lambda - sw2.Lambda;
            rerand_Gamma12_diff(i,m) = sw1.Gamma - sw2.Gamma;
            rerand_Sigma12_diff(i,m) = sw1.Sigma - sw2.Sigma;
        end
        rerand_Lp12_diff(i,m) = sw1.Lp - sw2.Lp;
        rerand_Cp12_diff(i,m) = sw1.Cp - sw2.Cp;
        clear NN KK aveden degree sw1 sw2
    end
end

%
for m = 1:length(Sparsity)
    if deltaLp(m) >=0
        PathLen.Lp.Lp12_diff_p(m) = length(find(rerand_Lp12_diff(:,m)>deltaLp(m)))/(num_rand+1);
    else
        PathLen.Lp.Lp12_diff_p(m) = length(find(rerand_Lp12_diff(:,m)<deltaLp(m)))/(num_rand+1);
    end
    [sortmaxminLp12diff ] = sort(rerand_Lp12_diff(:,m));
    PathLen.Lp.lower95Lp12diff (m)= sortmaxminLp12diff(ceil((num_rand+1)*0.05));
    PathLen.Lp.upper95Lp12diff (m) = sortmaxminLp12diff(end-ceil((num_rand+1)*0.05)-1);
    PathLen.Lp.rerand_Lp12diff_mean (m) = mean(rerand_Lp12_diff(:,m));


    if deltaCp(m) >=0
        ClustCoff.Cp.Cp12_diff_p(m) = length(find(rerand_Cp12_diff(:,m)>deltaCp(m)))/(num_rand+1);
    else
        ClustCoff.Cp.Cp12_diff_p(m) = length(find(rerand_Cp12_diff(:,m)<deltaCp(m)))/(num_rand+1);
    end
    [sortmaxminCp12diff ] = sort(rerand_Cp12_diff(:,m));
    ClustCoff.Cp.lower95Cp12diff (m)= sortmaxminCp12diff(ceil((num_rand+1)*0.05));
    ClustCoff.Cp.upper95Cp12diff (m) = sortmaxminCp12diff(end-ceil((num_rand+1)*0.05)-1);
    ClustCoff.Cp.rerand_Cp12diff_mean (m) = mean(rerand_Cp12_diff(:,m));

    if brandnetwork ==1
        if deltaLambda(m) >=0
            PathLen.Lambda.Lambda12_diff_p(m) = length(find(rerand_Lambda12_diff(:,m)>deltaLambda(m)))/(num_rand+1);
        else
            PathLen.Lambda.Lambda12_diff_p(m) = length(find(rerand_Lambda12_diff(:,m)<deltaLambda(m)))/(num_rand+1);
        end
        [sortmaxminLambda12diff ] = sort(rerand_Lambda12_diff(:,m));
        PathLen.Lambda.lower95Lambda12diff (m)= sortmaxminLambda12diff(ceil((num_rand+1)*0.05));
        PathLen.Lambda.upper95Lambda12diff (m) = sortmaxminLambda12diff(end-ceil((num_rand+1)*0.05)-1);
        PathLen.Lambda.rerand_Lambda12diff_mean (m) = mean(rerand_Lambda12_diff(:,m));

        if deltaGamma(m) >=0
            ClustCoff.Gamma.Gamma12_diff_p(m) = length(find(rerand_Gamma12_diff(:,m)>deltaGamma(m)))/(num_rand+1);
        else
            ClustCoff.Gamma.Gamma12_diff_p(m) = length(find(rerand_Gamma12_diff(:,m)<deltaGamma(m)))/(num_rand+1);
        end
        [sortmaxminGamma12diff ] = sort(rerand_Gamma12_diff(:,m));
        ClustCoff.Gamma.lower95Gamma12diff (m)= sortmaxminGamma12diff(ceil((num_rand+1)*0.05));
        ClustCoff.Gamma.upper95Gamma12diff (m) = sortmaxminGamma12diff(end-ceil((num_rand+1)*0.05)-1);
        ClustCoff.Gamma.rerand_Gamma12diff_mean (m) = mean(rerand_Gamma12_diff(:,m));

        if deltaSigma(m) >=0
            Sigma.Sigma.Sigma12_diff_p(m) = length(find(rerand_Sigma12_diff(:,m)>deltaSigma(m)))/(num_rand+1);
        else
            Sigma.Sigma.Sigma12_diff_p(m) = length(find(rerand_Sigma12_diff(:,m)<deltaSigma(m)))/(num_rand+1);
        end
        [sortmaxminSigma12diff ] = sort(rerand_Sigma12_diff(:,m));
        Sigma.Sigma.lower95Sigma12diff (m)= sortmaxminSigma12diff(ceil((num_rand+1)*0.05));
        Sigma.Sigma.upper95Sigma12diff (m) = sortmaxminSigma12diff(end-ceil((num_rand+1)*0.05)-1);
        Sigma.Sigma.rerand_Sigma12diff_mean (m) = mean(rerand_Sigma12_diff(:,m));

    end
end


%the significance of difference in the area under the Cp curve
% rerand_aCp12_diff = mean(rerand_Cp12_diff,2)*(Sparsity(end)-Sparsity(1));
rerand_aCp12_diff = (sum(rerand_Cp12_diff')' - mean(rerand_Cp12_diff(:,[1 end]),2))*deltas;
if deltaaCp >=0
    ClustCoff.aCp.aCp12_diff_p = length(find(rerand_aCp12_diff>deltaaCp))/(num_rand+1);
else
    ClustCoff.aCp.aCp12_diff_p = length(find(rerand_aCp12_diff<deltaaCp))/(num_rand+1);
end
[sortmaxminaCp12diff ] = sort(rerand_aCp12_diff);
ClustCoff.aCp.lower95aCp12diff = sortmaxminaCp12diff(ceil((num_rand+1)*0.05));
ClustCoff.aCp.upper95aCp12diff = sortmaxminaCp12diff(end-ceil((num_rand+1)*0.05)-1);
ClustCoff.aCp.rerand_aCp12diff_mean = mean(rerand_aCp12_diff);

%the significance of difference in the area under the Lp curve
% rerand_aLp12_diff = mean(rerand_Lp12_diff,2)*(Sparsity(end)-Sparsity(1));
rerand_aLp12_diff = (sum(rerand_Lp12_diff')' - mean(rerand_Lp12_diff(:,[1 end]),2))*deltas;
if deltaaLp >=0
    PathLen.aLp.aLp12_diff_p = length(find(rerand_aLp12_diff>deltaaLp))/(num_rand+1);
else
    PathLen.aLp.aLp12_diff_p = length(find(rerand_aLp12_diff<deltaaLp))/(num_rand+1);
end
[sortmaxminaLp12diff ] = sort(rerand_aLp12_diff);
PathLen.aLp.lower95aLp12diff = sortmaxminaLp12diff(ceil((num_rand+1)*0.05));
PathLen.aLp.upper95aLp12diff = sortmaxminaLp12diff(end-ceil((num_rand+1)*0.05)-1);
PathLen.aLp.rerand_aLp12diff_mean = mean(rerand_aLp12_diff);

if brandnetwork ==1
    %the significance of difference in the area under the Gamma curve.
    %%need to revise
    %     rerand_aGamma12_diff = mean(rerand_Gamma12_diff,2)*(Sparsity(end)-Sparsity(1));
    rerand_aGamma12_diff = (sum(rerand_Gamma12_diff')' - mean(rerand_Gamma12_diff(:,[1 end]),2))*deltas;

    if deltaaGamma >=0
        ClustCoff.aGamma.aGamma12_diff_p = length(find(rerand_aGamma12_diff>deltaaGamma))/(num_rand+1);
    else
        ClustCoff.aGamma.aGamma12_diff_p = length(find(rerand_aGamma12_diff<deltaaGamma))/(num_rand+1);
    end
    [sortmaxminaGamma12diff ] = sort(rerand_aGamma12_diff);
    ClustCoff.aGamma.lower95aGamma12diff = sortmaxminaGamma12diff(ceil((num_rand+1)*0.05));
    ClustCoff.aGamma.upper95aGamma12diff = sortmaxminaGamma12diff(end-ceil((num_rand+1)*0.05)-1);
    ClustCoff.aGamma.rerand_aGamma12diff_mean = mean(rerand_aGamma12_diff);

    %the significance of difference in the area under the Lambda curve
    rerand_aLambda12_diff = (sum(rerand_Lambda12_diff')' - mean(rerand_Lambda12_diff(:,[1 end]),2))*deltas;
    if deltaaLambda >=0
        PathLen.aLambda.aLambda12_diff_p = length(find(rerand_aLambda12_diff>deltaaLambda))/(num_rand+1);
    else
        PathLen.aLambda.aLambda12_diff_p = length(find(rerand_aLambda12_diff<deltaaLambda))/(num_rand+1);
    end
    [sortmaxminaLambda12diff ] = sort(rerand_aLambda12_diff);
    PathLen.aLambda.lower95aLambda12diff = sortmaxminaLambda12diff(ceil((num_rand+1)*0.05));
    PathLen.aLambda.upper95aLambda12diff = sortmaxminaLambda12diff(end-ceil((num_rand+1)*0.05)-1);
    PathLen.aLambda.rerand_aLambda12diff_mean = mean(rerand_aLambda12_diff);

    %the significance of difference in the area under the Sigma curve
    rerand_aSigma12_diff = (sum(rerand_Sigma12_diff')' - mean(rerand_Sigma12_diff(:,[1 end]),2))*deltas;
    if deltaaSigma >=0
        Sigma.aSigma.aSigma12_diff_p = length(find(rerand_aSigma12_diff>deltaaSigma))/(num_rand+1);
    else
        Sigma.aSigma.aSigma12_diff_p = length(find(rerand_aSigma12_diff<deltaaSigma))/(num_rand+1);
    end
    [sortmaxminaSigma12diff ] = sort(rerand_aSigma12_diff);
    Sigma.aSigma.lower95aSigma12diff = sortmaxminaSigma12diff(ceil((num_rand+1)*0.05));
    Sigma.aSigma.upper95aSigma12diff = sortmaxminaSigma12diff(end-ceil((num_rand+1)*0.05)-1);
    Sigma.aSigma.rerand_aSigma12diff_mean = mean(rerand_aSigma12_diff);
end

if brandnetwork ==0
    Sigma =[];
end
