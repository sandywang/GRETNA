function  gretna_plot_hub(Data, Lname, Hubcolor, Nhubcolor, Criteria)

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
%   Hubcolor:
%            Color assigned to hubs (1*3 vector of RGB values or a color
%            string, e.g., 'r').
%  Nhubcolor:
%            Color assigned to non-hubs (1*3 vector of RGB values or a color
%            string, e.g., 'b').
%   Criteria:
%            1: after averaging nodal values across subjects, the top 10%
%               nodes with the highest values are identified as hubs.
%            2: after averaging nodal values across subjects, the nodes with
%               values larger than mean + 1 SD over all nodes are identified
%               as hubs.
%
% Examples:
%        figure
%        subplot(2,1,1);
%        gretna_plot_hub(rand(36,8),{'A','B','C','D','E','F','G','H'});
%        subplot(2,1,2);
%        gretna_plot_hub(rand(60,90), 'AAL');
%        figure
%        subplot(2,1,1);
%        gretna_plot_hub(rand(45,90), 'AAL', 'r', 'b', 2);
%        subplot(2,1,2);
%        gretna_plot_hub(rand(45,112), 'HOA');
%
% Hao WANG, CCBD, HZNU, Hangzhou, 2014/12/14, hall.wong@outlook.com
%==========================================================================

if nargin < 2
    error('At least two arguments are needed!'); end

if nargin == 2
    Hubcolor  = [0.93 0.69 0.13];
    Nhubcolor = [0.80 0.80 0.80];
    Criteria = 1;
end

if nargin == 3
    Nhubcolor = [0.80 0.80 0.80];
    Criteria = 1;
end

if nargin == 4
    Criteria = 1;
end

if nargin > 5
    error('At most five arguments are permitted!');
end

tmp = mean(Data);
sd  = std(Data);

[~,serial] = sort(tmp,'descend');
tmp = tmp(serial);
sd  = sd(serial);
N   = length(tmp);

switch Criteria
    case 1
        Num = round(N.*0.1);
    case 2
        Num = length(find(tmp > mean(tmp)+std(tmp)));
    otherwise
        error('The inputted Type is not recognized, please check it!')
end

LineNub  = repmat((1:N)',1,2);
LineData = [(tmp+sd)',tmp'];

if  strcmp(Lname,'AAL')
    Lab_info = gretna_label('AAL');
    Lab      = Lab_info.abbr;
    
elseif strcmp(Lname,'HOA')
    Lab_info = gretna_label('HOA');
    Lab      = Lab_info.abbr;
    
else
    Lab = Lname;
    if size(Lab,2) ~= N;
        error('The number of brain regions must be equal to the number of inputted names!');
    end
    
end

nonhub = bar(Num+1:N, tmp(Num+1:end));

hold on;

set(nonhub, 'BarWidth', 0.618, 'FaceColor', Nhubcolor, 'EdgeColor', Nhubcolor);   % Bar width

hub = bar(1:Num, tmp(1:Num));
set(hub,'BarWidth', 0.618, 'FaceColor', Hubcolor, 'EdgeColor', Hubcolor);

plot(LineNub(1:Num,:)',   LineData(1:Num,:)',   'Color', Hubcolor,  'LineWidth', 0.5);
plot(LineNub(Num+1:N,:)', LineData(Num+1:N,:)', 'Color', Nhubcolor, 'LineWidth', 0.5);

% plot the criterion line
H1 = plot([1 N], [tmp(Num) tmp(Num)], 'color', 'k', 'LineStyle', '-.', 'Linewidth', 0.5);

legend([hub,nonhub,H1], 'Hubs', 'Non-Hubs', 'Criterion line',...
    'Location', 'northoutside', 'Orientation', 'horizontal');

%set(gca, 'XTICK', 1:N, 'Xlim', [0 N+1], 'XTickLabel', Lab(serial), 'fontsize', 8,...
%    'FontName', 'arial', 'XTickLabelRotation', 90, 'box', 'off',...
%    'TickDir', 'out', 'TickLength', [0.005 0.005]);
set(gca, 'Xlim', [0 N+1], 'fontsize', 8,...
    'FontName', 'arial', 'box', 'off',...
    'TickDir', 'out', 'TickLength', [0.005 0.005]);

FullMatlabVersion = sscanf(version,'%d.%d.%d.%d%s');
if (FullMatlabVersion(1)*1000+FullMatlabVersion(2)>=8*1000+4)
    set(gca, 'XTICK', 1:N, 'XTickLabelRotation', 90, 'XTickLabel', Lab(serial));
else
    xticklabel_rotate(1:N, 90, Lab(serial));
end

set(get(gca, 'Children'), 'linewidth', 0.5)

hold off;

% saveas(gca,File_filter,'fig');    % save current figure as fig file
return