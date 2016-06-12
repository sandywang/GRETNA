function  [mdl] = gretna_plot_regression(Xdata, Ydata, Type, Type_hist)

%==========================================================================
% This function is used to plot a linear fitted line between two variables.
%
%
% Syntax: function [mdl] = gretna_plot_regression(Xdata, Ydata, Type, Type_hist)
%
% Inputs:
%    Xdata:
%           N*1 data array for the x-axis.
%    Ydata:
%           N*1 data array for the y-axis.
%     Type:
%           'ci' or 'CI': 95% confidence intervals for the fitted line 
%                         evaluated at the values in Xdata (default).
%           'pi' or 'PI': 95% prediction intervals for new observations at
%                          the values in Xdata.
% Type_hist:
%           'on' or 'off'.
%
% Output:
%       md1:
%           The linear fitted model.
%
% Example:
%          X = [143 145 146 147 149 150 153 154 155 156 157 158 159 160 162 164]';
%          Y = [88 85 88 91 92 93 93 95 96 98 97 96 98 99 100 102]';
%          [mdl] = gretna_plot_regression(X, Y, 'ci');
%
% Hao WANG, CCBD, HZNU, Hangzhou, 2015/11/18, hall.wong@outlook.com
%==========================================================================

if nargin < 2
    error('At least two arguments are needed!'); end

if nargin == 2
    Type = 'ci';  Type_hist = 'off'; end

if nargin == 3
    Type_hist = 'off'; end

if nargin > 4
    error('At most four arguments are permitted');
end

if size(Xdata,2) ~= 1 || size(Ydata,2) ~= 1
    error('The input X and Y must be n-by-1 arrays'); end

FullMatlabVersion = sscanf(version,'%d.%d.%d.%d%s');
if (FullMatlabVersion(1)*1000+FullMatlabVersion(2)>=8*1000+4)
    tbl = table(Ydata, Xdata); %Modified by Sandy
    mdl = fitlm(tbl, 'Ydata~1+Xdata', 'RobustOpts', 'off');    
else
    mdl= regstats(Ydata, Xdata, 'linear');
end
%tbl = table(Ydata, Xdata); %Modified by Sandy
%mdl = fitlm(tbl, 'Ydata~1+Xdata', 'RobustOpts', 'on');

Xdata = Xdata'; Ydata = Ydata';
[p, s] = polyfit(Xdata, Ydata, 1);

switch lower(Type)
    case 'ci'
        [yfit, dy] = polyconf(p, Xdata, s, 'predopt', 'curve');       %  'curve' to compute confidence intervals.
    case 'pi'
        [yfit, dy] = polyconf(p, Xdata, s, 'predopt', 'observation'); %  'observation' to compute prediction intervals.
    otherwise
        error('The inputted Type is not recognized, please check it!');
end

switch lower(Type_hist)
    case 'on'
        scatterhist(Xdata, Ydata, 'Marker','.','MarkerSize', 12, 'Color', 'k', 'Nbins', round(length(Xdata)./3), 'Direction','out','Kernel','overlay'); % Nbin: the number of the bins.
    case 'off'
        plot(Xdata, Ydata, 'k.' ,'Markersize', 12);
    otherwise
        error('The inputted Type_hist is not recognized, please check it!')
end

hold on;

Xraw = Xdata;

% plot shade
Border    = [yfit+dy; yfit-dy];
[Xdata,index] = sort(Xdata);
Border    = Border(:,index);
fill([Xdata fliplr(Xdata)], [Border(1,:) fliplr(Border(2,:))], [0.5 0.5 0.5], 'FaceAlpha', 0.4, 'linestyle', 'none');

% plot fit curve
[~,ind1] = min(Xraw);
[~,ind2] = max(Xraw);

plot([Xraw(ind1); Xraw(ind2)], [yfit(ind1); yfit(ind2)], 'color', [0 0.45 0.74], 'Linewidth', 2);

% Add a legend
switch lower(Type)
    case 'ci'
        legend('Data', 'Fitted curve', '95% CI');
    case 'pi'
        legend('Data', 'Fitted curve', '95% PI');
end

set(gca, 'TickDir', 'out', 'box', 'on', 'Xlim', [min(Xdata) max(Xdata)]);

hold off;

return