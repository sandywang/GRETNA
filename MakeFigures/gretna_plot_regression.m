function  gretna_plot_regression(Xdata, Ydata, NumDegree, Type_hist)

%==========================================================================
% This function is used to plot a linear fitted line between two variables.
%
%
% Syntax: function gretna_plot_regression(Xdata, Ydata, NumDegree, Type_hist)
%
% Inputs:
%      Xdata:
%            N*1 data array for the x-axis.
%      Ydata:
%            N*1 data array for the y-axis.
%  NumDegree:
%            Degree of polynomial fit, specified as a positive integer
%            scalar [e.g., 1 or 2 or 3 etc.]
%  Type_hist:
%            'on' or 'off'.
%
% Example:
%          X = [143 145 146 147 149 150 153 154 155 156 157 158 159 160 162 164]';
%          Y = [88 85 88 91 92 93 93 95 96 98 97 96 98 99 100 102]';
%          gretna_plot_regression(X, Y, 1);
%
% Hao WANG, CCBD, HZNU, Hangzhou, 2015/11/18, hall.wong@outlook.com
%
% Change log:
% 2016-11-24: Fix some bugs, display figure title, and discard the function
% (fitlm.m); Modified by Hao Wang.
%==========================================================================

if nargin < 2
    error('At least two arguments are needed!'); end

if nargin == 2
    NumDegree = 1;  Type_hist = 'off'; end

if nargin == 3
    Type_hist = 'off'; end

if nargin > 4
    error('At most four arguments are permitted');
end

if size(Xdata,2) ~= 1 || size(Ydata,2) ~= 1
    error('The input X and Y must be n-by-1 arrays'); end

% FullMatlabVersion = sscanf(version,'%d.%d.%d.%d%s');
% if (FullMatlabVersion(1)*1000+FullMatlabVersion(2)>=8*1000+4)
%     tbl = table(Ydata, Xdata); 
%     mdl = fitlm(tbl, 'Ydata~1+Xdata', 'RobustOpts', 'off');
% else
%     mdl= regstats(Ydata, Xdata, 'linear');
% end
% tbl = table(Ydata, Xdata); %Modified by Sandy
% mdl = fitlm(tbl, 'Ydata~1+Xdata', 'RobustOpts', 'on');

[r_tmp, p_tmp] = corr(Xdata, Ydata,'type','pearson');

if NumDegree == 1
    fprintf('\n')
    fprintf('====================================================\n')
    fprintf('%s \n',['The Pearson correlation coefficient is ', num2str(r_tmp, '%.3f')])
    fprintf('%s \n',['The P value is ', num2str(p_tmp)])
    fprintf('====================================================\n')
end

% To ensure data monotony
[Xdata,index] = sort(Xdata);
Ydata = Ydata(index);
[p, s] = polyfit(Xdata, Ydata, NumDegree);
[yfit, dy] = polyconf(p, Xdata, s, 'predopt', 'curve');       %  'curve' to compute confidence intervals.

switch lower(Type_hist)
    case 'on'
        scatterhist(Xdata, Ydata, 'Marker','.','MarkerSize', 12,'Color', 'k',...
            'Nbins', round(length(Xdata)./3),'Direction','out','Kernel','off'); % Nbin: the number of the bins.
    case 'off'
        plot(Xdata, Ydata, 'k.' ,'Markersize', 12);
    otherwise
        error('The inputted Type_hist is not recognized, please check it!')
end

hold on;

% plot shade
Border = [yfit+dy, yfit-dy]';
Xdata  = Xdata';
fill([Xdata fliplr(Xdata)], [Border(1,:) fliplr(Border(2,:))], [0.5 0.5 0.5], 'FaceAlpha', 0.4, 'linestyle', 'none');

% plot fit curve
plot(Xdata, yfit, 'color', [0 0.45 0.74], 'Linewidth', 2);

% Add title and legend 
title(['{\it Fit: }','\it',gretna_polystr(round(100*p)/100)],'FontSize',12,...
    'FontName','Times New Roman');
legend('Data', '95% CI', 'Fitted curve','Location','best');
legend('boxoff');
set(gca, 'TickDir', 'in', 'box', 'on', 'Xlim', [min(Xdata) max(Xdata)]);

hold off;

end


