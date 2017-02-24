function gretna_plot_dot(Data, Gname, Lname, Type)

%==========================================================================
% This function is used to plot grouped dot graphs.
%
%
% Syntax: function gretna_plot_dot(Data, Gname, Lname, Type)
%
% Inputs:
%       Data:
%            1*N cell with each element being a M*C data array (N, the
%            number of groups; M, the number of subjects; C, the number of
%            variables). NOTE, M can vary but C MUST be equal across groups.
%      Gname:
%            Group names (e.g., {'HC','PD','AD'}).
%      Lname:
%            Variable names (e.g., {'INS','TPO','PCUN','PCC'}).
%       Type:
%            'sd'  or 'SD':    standard deviation (default).
%            'sem' or 'SEM':   standard error of the mean.
%            'ci'  or 'CI':    95% confidence interval.
%
% Example:
%       Suppose that we compared nodal degree for 90 regions between 10 AD
%       patietns and 20 healthy controls, and found significant between-group
%       differences in three regions. The degree values for the three regions
%       were sorted in data1 (10*3) for the AD patients and data2 (20*3)
%       for healthy controls. Then, you can run the code as follows:
%
%       gretna_plot_dot({data1,data2},{'AD','HC'},{'Reg1','Reg2','Reg3'},'ci')
%
% Hao WANG, CCBD, HZNU, Hangzhou, 2015/11/11, hall.wong@outlook.com
%
% Change log:
% 2016-11-24: Fix some bugs, reconfigure the color, plot dividing line, and
% replace the mean line by a red dot; Modified by Hao Wang.
% 2016-05-09: Fix some bugs for the version below Matlab R2014b and add
% plot GUI; Modified by Sandy.
%==========================================================================

if nargin < 3
    error('At least three arguments are needed!'); end

if nargin == 3
    Type = 'sd'; end

if nargin > 4
    error('At most four arguments are permitted!'); end

if ~iscell(Data) || ~iscell(Gname) || ~iscell(Lname)
    error('The inputted Data, Gname, and Lname MUST be cell format, please check it!'); end

if size(Data,1) ~= 1
    error('The inputted Data must be a 1*N cell, please check it!');
end

Numgroup  = size(Data,2);

Data      = gretna_fill_nan(Data);
[~, Dim2] = size(Data);

Numregion = Dim2/Numgroup;
Numlname = size(Lname, 2);
Numgname = size(Gname, 2);

yMean = nanmean(Data);
yStd  = nanstd(Data);
ySem  = yStd./sqrt(sum(~isnan(Data)));
yCI   = ySem*2;  % (N>15)
% Krzywinski, M., & Altman, N. (2013). Points of significance: error bars. Nature methods, 10(10), 921-922.

if Numgroup ~= Numgname
    error('The number of groups must be equal to the number of inputted group names'); end

if Numregion ~= Numlname
    error('The number of variables must be equal to the number of inputted variable names'); end

if Numgname <= 8
    load('gretna_plot_colorpara.mat');
else
    Color = distinguishable_colors(100);
end

ratio = 0.15;

hold on;

switch lower(Type)
    case 'sd'
        for i = 1:Dim2
            rectangle('Position', [i-ratio, yMean(i)-yStd(i), 2*ratio, 2*yStd(i)], 'FaceColor', [0.83 0.83 0.78], 'Linestyle', 'none');
        end
    case 'sem'
        for i = 1:Dim2
            rectangle('Position', [i-ratio, yMean(i)-ySem(i), 2*ratio, 2*ySem(i)], 'FaceColor', [0.83 0.83 0.78], 'Linestyle', 'none');
        end
    case 'ci'
        for i = 1:Dim2
            rectangle('Position', [i-ratio, yMean(i)-yCI(i), 2*ratio, 2*yCI(i)], 'FaceColor', [0.83 0.83 0.78], 'Linestyle', 'none');
        end
    otherwise
        error('The inputted Type is not recognized, please check it!')
end

Ch = plotSpread(Data);
H  = get(Ch{1,3}, 'Children');

for j = 1:Numgroup
    set(H(j:Numgroup:Dim2), 'Color', Color(Numgroup+1-j,:), 'MarkerSize', 10, 'Marker', '.', 'markerfacecolor', 'none');
end

plot(yMean, 'Color',[1 0 0], 'LineStyle','none','MarkerSize',15,'Marker','.');
set(gca, 'TickDir', 'in', 'XLim', [0.5 Dim2+0.5], 'YLim', [min(Data(:))-0.309*range(Data(:)), max(Data(:))+0.309*range(Data(:))]);  % 0.309 (0.618/2) to Visualize Better

% line positions
xlines = (Numgroup+0.5):Numgroup:(Dim2+0.5-Numgroup);
hx     = zeros(size(xlines));

for n  = 1:length(xlines)
    hx(n) = line([xlines(n) xlines(n)], get(gca,'ylim'), 'Linestyle' ,'-.',...
        'color', [0.83 0.82 0.78], 'tag', 'separator', 'LineWidth', 0.5);
end

ax = gca;
set(ax, 'XTick', ((1 + Numgroup)/2):Numgroup:(Dim2 - (Numgroup -(1 + Numgroup)/2)));
set(ax, 'XTickLabel', Lname);

legend(H(Numgroup:1), Gname, 'Orientation','horizontal','Location','northoutside');
legend('boxoff');

hold off;

return