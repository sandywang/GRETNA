function [hubind2] = gretna_plot_hub_second(Data, Index, Criteria)

%==========================================================================
% This function is used to plot the second hubs figure in a combinatorial figure.
% E.g., the first figure is hubs with node degree for all 90 cortical regions,
% displayed in order of degree, from top to bottom. This node ordering is
% maintained across all remaining plots in this figure, including node
% strength, betweenness, and closeness.
% 
% Inputs:
%       Data:
%            M*N data array (M, number of subjects; N, number of nodes or
%            regions).
%      Index:
%            The node ordering of first figure (could be obtained from
%            'gretna_plot_hub.m').
%   Criteria:
%            1: after averaging nodal values across subjects, the top 10%
%               nodes with the highest values are identified as hubs.
%            2: after averaging nodal values across subjects, the nodes with
%               values larger than mean + 1 SD over all nodes are identified
%               as hubs.
% Output:
%    hubind2:
%            Hub nodes index (this index is used to calculate the common 
%            hubs across groups). 
%
% Hao WANG, CCBD, HZNU, Hangzhou, 2014/12/14, hall.wong@outlook.com
%==========================================================================
if nargin < 2
    error('At least two arguments are needed!'); end

if nargin == 2
    Criteria = 1;
end

if nargin > 3
    error('At most three arguments are permitted!');
end

tmp = mean(Data,1);
tmp = tmp(Index);
N = length(tmp);

switch Criteria
    case 1
        Num = round(N.*0.1);
    case 2
        Num = length(find(tmp > mean(tmp)+std(tmp)));
    otherwise
        error('The inputted Type is not recognized, please check it!')
end

[~,serial2] = sort(tmp,'descend');
tmp1 = tmp(serial2);
ind = find(tmp>=tmp1(Num)); 

hubind2 = Index(ind);  % Output this index for subsequent statistical analysis

Nonind = setdiff(1:N,ind);

hold on
stem(Nonind,tmp(Nonind),'LineWidth', 0.5,'MarkerSize', -0.02*N+5.28,...
    'Color', [0.80 0.80 0.80],'MarkerFaceColor',[0.80 0.80 0.80],'LineStyle',':');
stem(ind, tmp(ind),'LineWidth', 1,'MarkerSize', -0.02*N+5.28,...
    'Color', [0.93 0.69 0.13],'MarkerFaceColor',[0.93 0.69 0.13],'LineStyle',':');

plot([1 N], [tmp1(Num) tmp1(Num)], 'color', 'k', 'LineStyle', '-.', 'Linewidth', 0.5);

set(gca, 'Xlim', [0 N+1], 'fontsize', -0.07*N+12.67,'FontName', 'arial',...
    'box', 'off', 'xtick',[], 'ticklength',[0.005 0.05]); 

view(90,90)

set(gca,'YaxisLocation','right');

hold off;

% saveas(gca,File_filter,'fig');    % save current figure as fig file

return



