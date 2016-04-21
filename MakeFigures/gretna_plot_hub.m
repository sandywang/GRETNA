function [serial] = gretna_plot_hub(Data, Lname, Hubcolor, Nhubcolor, Type)

%==========================================================================
% This function is used to plot the bar figure of hub nodes.
%
%
% Syntax: function [serial] = gretna_plot_hub(Data, Lname, Hubcolor, Nhubcolor, Type)
%
% Inputs:
%       Data:
%            Network parameters (M*N, M = independent variable
%            (e.g.,subjects); N = the number of nodes ).
%      Lname:
%            label name (ROI, Autofill the name of AAL90 and HOA112 atlas, e.g.,'AAL' or 'HOA'.
%            In addition to these two situations, I'm afraid you have to
%            define your own ROI name.   e.g.,{'INS','TPO','PCUN','PCC'}).
%   Hubcolor:
%            An RGB color for Hub nodes(a three-element row vector)
%            or a color string('r','b','k').
%  Nhubcolor:
%            An RGB color for Non-Hub nodes(a three-element row vector)
%            or a color string('r','b','k').
%       Type:
%            1,  top10% hubs
%            2,  mean+1SD hubs
%
% Examples:
%        figure
%        subplot(2,1,1);
%        [~] = gretna_plot_hub(rand(36,10),{'A','B','C','D','E','F','G','H','I','J'});
%        subplot(2,1,2);
%        [~] = gretna_plot_hub(rand(60,90), 'AAL');
%        figure
%        subplot(2,1,1);
%        [~] = gretna_plot_hub(rand(45,90), 'AAL', 'r', 'b',2);
%        subplot(2,1,2);
%        [~] = gretna_plot_hub(rand(45,112), 'HOA');
%
%
% Hao WANG, CCBD, HZNU, Hangzhou, 2014/12/14, hall.wong@outlook.com
%==========================================================================

if nargin < 3
    Hubcolor  = [0.93 0.69 0.13];
    Nhubcolor = [0.80 0.80 0.80];
    Type = 1;
end

tmp = mean(Data);
sd = std(Data);

[~,serial] = sort(tmp,'descend');
tmp = tmp(serial);
sd = sd(serial);
N = length(tmp);

switch lower(Type)
    case 1
        Num = round(N.*0.1);
    case 2
        Num = length(find(tmp>mean(tmp)+std(tmp)));
    otherwise
        error('Unsupported type')
end

LineNub = repmat((1:N)',1,2);
LineData = [(tmp+sd)',tmp'];

if  strcmp(Lname,'AAL')
    Lab_info = gretna_label('AAL');
    Lab = Lab_info.name;
elseif strcmp(Lname,'HOA')
    Lab_info = gretna_label('HOA');
    Lab = Lab_info.name;
else
    Lab = Lname;
    if size(Lab,2)~=N;
        error('brain regions must correspond to their names');
    end
end

nonhub = bar(Num+1:N,tmp(Num+1:end));
hold on
set(nonhub,'BarWidth',0.618,'FaceColor',Nhubcolor,'EdgeColor',Nhubcolor);   % Bar width

hub = bar(1:Num, tmp(1:Num));
set(hub,'BarWidth',0.618,'FaceColor',Hubcolor,'EdgeColor',Hubcolor);

plot(LineNub(1:Num,:)',LineData(1:Num,:)','Color',Hubcolor,'LineWidth',0.5);
plot(LineNub(Num+1:N,:)',LineData(Num+1:N,:)','Color',Nhubcolor,'LineWidth',0.5);

% plot the criterion line
H1 = plot([1 N],[tmp(Num) tmp(Num)],'color','k','LineStyle','-.','Linewidth',0.5);

legend([hub,nonhub,H1],'Hubs','Non-Hubs','Criterion line',...
    'Location','northoutside','Orientation','horizontal');

set(gca, 'XTICK', 1:N);
set(gca,'Xlim',[0 N+1],'XTickLabel',Lab(serial),'fontsize',8,...
    'FontName','arial','XTickLabelRotation',90,'box','off',...
    'TickDir','out' ,'TickLength',[0.005 0.005]);
set(get(gca,'Children'),'linewidth',0.5)

hold off

% saveas(gca,File_filter,'fig');    % save current figure as fig file
return