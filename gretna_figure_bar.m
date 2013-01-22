function gretna_figure_bar(Para, Index_group1, Index_group2, Covariate)

%==========================================================================
% This function is used plot bar figure of multiple variables between two 
% groups.
%
%
% Syntax: function gretna_figure_bar(Para, Index_group1, Index_group2, Covariate)
%
% Inputs:
%          Para:
%                m*n array with m being observations and n being variables.
%          Index_group1:
%               The index of one group (m1*1 array).
%          Index_group2:
%               The index of the other group (m2*1 array). NOTE, m = m1+m2.
%          Covariate (optional):
%                The directory & filename of a .txt file that contains
%                the covariates. NOTE, the order of values in each covarite
%                should be the same as those in Para.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

[~,n] = size(Para);

N1 = length(Index_group1);
N2 = length(Index_group2);

Para = [Para(Index_group1,:); Para(Index_group2,:)];
Group = [ones(N1,1); zeros(N2,1)];

% remove confounding
if nargin == 4
    Covariate  = [Covariate(Index_group1,:); Covariate(Index_group2,:)];
    Desnmatrix = [Group Covariate];
    
    for i = 1:n
        stat = regstats(Para(:,i), Desnmatrix, 'linear', {'r','tstat'});
        Para(:,i) = stat.tstat.beta(1) + stat.tstat.beta(2)*Group + stat.r;
    end
end

Para_group1 = Para(1:N1,:);        Para_group2 = Para(N1+1:N1+N2,:);
mean_group1 = mean(Para_group1); mean_group2 = mean(Para_group2);
std_group1  = std(Para_group1);  std_group2  = std(Para_group2);

% figure
xlim = [0.4 0.6];

x_spec1 = zeros(n,1);
x_spec2 = zeros(n,1);
for i = 1:n
    x_spec1(i) = xlim(1)+i-1;
    x_spec2(i) = xlim(2)+i-1;
end

bar(x_spec1,mean_group1,0.1,'FaceColor',[1 0.6 0.78],'EdgeColor',[1 0.6 0.78]);
hold on
bar(x_spec2,mean_group2,0.1,'FaceColor',[0.04 0.52 0.78],'EdgeColor',[0.04 0.52 0.78]);
errorbar(x_spec1,mean_group1,std_group1,'LineWidth',2,'Color',[1 0.6 0.78],'LineStyle','none')
errorbar(x_spec2,mean_group2,std_group2,'LineWidth',2,'Color',[0.04 0.52 0.78],'LineStyle','none')

v = axis;
axis([0 n v(3) v(4)])
set(gca,'TickDir','out')
box off

return