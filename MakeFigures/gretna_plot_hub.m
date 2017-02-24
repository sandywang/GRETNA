function  [serial, hubind1] = gretna_plot_hub(Data, Lname, Criteria)

%==========================================================================
% This function is used to plot bar figures of brain hubs.
%
%
% Syntax: function  gretna_plot_hub(Data, Lname, Hubcolor, Nhubcolor, Criteria)
%
% Inputs:
%       Data:
%            M*N data array (M, number of subjects; N, number of nodes or
%            regions).
%      Lname:
%            Label names (e.g.,{'INS','TPO','PCUN','PCC'}). If nodes are
%            from several popular brain atlases (e.g., the Anatomical
%            Automatic Labeling atlas or Harvard-Oxford atlas, just simply
%            type 'AAL' or 'HOA'.
%   Criteria:
%            1: after averaging nodal values across subjects, the top 10%
%               nodes with the highest values are identified as hubs.
%            2: after averaging nodal values across subjects, the nodes with
%               values larger than mean + 1 SD over all nodes are identified
%               as hubs.
% Output:
%     serial:
%            The node ordering is displayed in descending order.
%    hubind1:
%            Hub nodes index (this index is used to calculate the common 
%            hubs across groups). 
%
% Examples:
%        figure
%        subplot(2,1,1);
%        gretna_plot_hub(rand(36,8),{'A','B','C','D','E','F','G','H'});
%        subplot(2,1,2);
%        gretna_plot_hub(rand(60,90), 'AAL');
%        figure
%        subplot(2,1,1);
%        gretna_plot_hub(rand(45,90), 'AAL', 2);
%        subplot(2,1,2);
%        gretna_plot_hub(rand(45,112), 'HOA',1);
%
% Hao WANG, CCBD, HZNU, Hangzhou, 2014/12/14, hall.wong@outlook.com
%
% Change log:
% 2016-11-24: Replace the bar plot by the stem plot to used the figure
% space adequately, and the image is displayed vertically; Modified by Hao
% Wang.
%==========================================================================

if nargin < 2
    error('At least two arguments are needed!'); end

if nargin == 2
    Hubcolor  = [0.93 0.69 0.13];
    Nhubcolor = [0.80 0.80 0.80];
    Criteria = 1;
end

if nargin == 3
    Hubcolor  = [0.93 0.69 0.13];
    Nhubcolor = [0.80 0.80 0.80];
end

if nargin > 3
    error('At most five arguments are permitted!');
end

tmp = mean(Data,1);

[~,serial] = sort(tmp,'descend');
tmp = tmp(serial);
N   = length(tmp);

switch Criteria
    case 1
        Num = round(N.*0.1);
    case 2
        Num = length(find(tmp > mean(tmp)+std(tmp)));
    otherwise
        error('The inputted Type is not recognized, please check it!')
end

if  strcmpi(Lname,'AAL')
    Lab_info = gretna_label('AAL');
    Lab      = Lab_info.abbr;
    
elseif strcmpi(Lname,'HOA')
    Lab_info = gretna_label('HOA');
    Lab      = Lab_info.abbr;
    
else
    Lab = Lname;
    if size(Lab,2) ~= N
        error('The number of brain regions must be equal to the number of inputted names!');
    end
    
end

hubind1 = serial(1:Num);  % Output this index for subsequent statistical analysis

hold on;
nonhub = stem(Num+1:N, tmp(Num+1:end),'LineWidth',0.5,'MarkerSize', -0.02*N+5.28,...
    'Color', Nhubcolor, 'MarkerFaceColor',Nhubcolor,'LineStyle',':');
hub = stem(1:Num, tmp(1:Num),'LineWidth',1,'MarkerSize', -0.02*N+5.28,...
    'Color', Hubcolor, 'MarkerFaceColor',Hubcolor,'LineStyle',':');

% plot the criterion line
H1 = plot([1 N], [tmp(Num) tmp(Num)], 'color', 'k', 'LineStyle', '-.', 'Linewidth', 0.5);

legend([hub,nonhub,H1], 'Hubs', 'Non-Hubs', 'Criterion line',...
    'Orientation','horizontal','Location','northoutside');
legend('boxoff');

set(gca, 'Xlim', [0 N+1], 'fontsize', -0.07*N+12.67,'FontName', 'arial',...
    'box', 'off','XTICK', 1:N, 'XTickLabel', Lab(serial),'ticklength',[0.005 0.05]); 

view(90,90)
set(gca,'YaxisLocation','right');

hold off;

return