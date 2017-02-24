function gretna_plot_violin(Data, Gname, Lname, Type)

%==========================================================================
% This function is used to plot grouped violin graphs.
%
%
% Syntax: function  gretna_plot_violin(Data, Gname, Lname, Type)
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
%            'box':         boxplot and the violin
%            'boxfill':     boxplot and filling the violin
%            'dot':         scatterplot (default).
%            'dotfill':     scatterplot and filling the violin
%            'mean':        mean and the violin
%            'meanfill':    mean and filling the violin
%            'meanstd':     mean, standard deviation, and violin
%            'meanstdfill': mean, standard deviation, and filling the violin
%
% Example:
%       Suppose that we compared nodal degree for 90 regions between 10 AD
%       patietns and 20 healthy controls, and found significant between-group
%       differences in three regions. The degree values for the three regions
%       were sorted in data1 (10*3) for the AD patients and data2 (20*3)
%       for healthy controls. Then, you can run the code as follows:
%
%       gretna_plot_violin({data1,data2},{'AD','HC'},{'Reg1','Reg2','Reg3'},'dot')
%
% Hao WANG, CCBD, HZNU, Hangzhou, 2015/11/11, hall.wong@outlook.com
%
% Change log:
% 2016-11-24: Fix some bugs, reconfigure the color, plot dividing line, and
% add more plot styles; Modified by Hao Wang.
% 2016-05-09: Fix some bugs for the version below Matlab R2014b and add
% plot GUI; Modified by Sandy.
%==========================================================================

if nargin < 3
    error('At least three arguments are needed!'); end

if nargin == 3
    Type = 'dot'; end

if nargin > 4
    error('At most four arguments are permitted!'); end

if ~iscell(Data) || ~iscell(Gname) || ~iscell(Lname)
    error('The inputted Data, Gname, and Lname MUST be cell format, please check it!'); end

if size(Data,1) ~= 1
    error('The inputted Data must be a 1*N cell, please check it!');
end

Numgroup  = size(Data, 2);

Data      = gretna_fill_nan(Data);
[~, Dim2] = size(Data);
Mdata = nanmean(Data);
Stdata = nanstd(Data);

Numregion = Dim2/Numgroup;
Numgname  = size(Gname, 2);
Numlname  = size(Lname, 2);

if Numgroup ~= Numgname
    error('The number of groups must be equal to the number of inputted group names'); end

if Numregion ~= Numlname
    error('The number of variables must be equal to the number of inputted variable names'); end

if Numgname <= 8
    load('gretna_plot_colorpara.mat');
else
    Color = distinguishable_colors(100);
end

F = zeros(2^8, Dim2);
U = zeros(2^8, Dim2);

for i = 1:Dim2
    [f, xi] = ksdensity(Data(:,i), 'npoints', 2^8);
    F(:,i)  = f/max(f)*0.3;
    U(:,i)  = xi;
end

if sscanf(version,'%f',1)*1000 >= 8400
    H  = gobjects(1, Dim2);
    H1 = gobjects(1, Dim2);
else
    H  = cell(1, Dim2);
    H1 = cell(1, Dim2);
end

hold on;

% Plot the violins
for i = 1:Dim2
    if  sscanf(version,'%f',1)*1000 >= 8400
        H(i) = fill([F(:,i)+i; flipud(i-F(:,i))],[U(:,i); flipud(U(:,i))], [1 1 1], 'EdgeColor','none');
        % H1(i) = plot([interp1(U(:,i), F(:,i)+i, Mdata(i)),
        % interp1(flipud(U(:,i)), flipud(i-F(:,i)), Mdata(i)) ], [Mdata(i) Mdata(i)], 'k', 'LineWidth', 1.5);
    else
        H{1, i} = fill([F(:,i)+i; flipud(i-F(:,i))],[U(:,i); flipud(U(:,i))], [1 1 1], 'EdgeColor','none');
        % H1{1, i} = plot([interp1(U(:,i), F(:,i)+i, Mdata(i)),
        % interp1(flipud(U(:,i)), flipud(i-F(:,i)), Mdata(i)) ], [Mdata(i) Mdata(i)], 'k', 'LineWidth', 1.5);
    end
end

% Add more plot styles
switch lower(Type)
    case {'box','boxfill'}
        boxplot(Data, 'PlotStyle', 'compact', 'BoxStyle', 'outline', 'Widths', 0.1, 'Whisker', 1, 'Colors', 'k');
        set(findobj(gcf, '-regexp', 'Tag', '\w*Whisker'), 'LineStyle', '-');
    case {'dot','dotfill'}
        ch = plotSpread(Data, 'distributionColors', {[0.3 0.3 0.3]});
        HChildren=get(ch{1, 3}, 'Children');    
        set(HChildren, 'MarkerSize', 8);
        H1 = plot(Mdata, 'Color',[1 0 0], 'LineStyle','none','MarkerSize',15,'Marker','.');
    case {'mean','meanfill'}
        H1 = plot(Mdata, 'Color',[1 0 0], 'LineStyle','none','MarkerSize',15,'Marker','.');
    case {'meanstd','meanstdfill'}
        H1 = plot(Mdata, 'Color',[1 0 0], 'LineStyle','none','MarkerSize',15,'Marker','.');
        plot(repmat((1:Dim2),2,1), [Mdata - Stdata; Mdata + Stdata],'LineWidth',1,'Color',[1 0 0]);
    otherwise
        error('The inputted Type is not recognized, please check it!');
end

for j = 1:Numgroup
    for h = j:Numgroup:Dim2
        if strcmpi(Type,'box')||strcmpi(Type,'dot')||strcmpi(Type,'mean')||strcmpi(Type,'meanstd')
            if  sscanf(version,'%f',1)*1000 >= 8400  
                set(H(h), 'FaceColor', [1 1 1], 'EdgeColor', Color(j,:), 'LineWidth', 1);
            else
                set(H{h}, 'FaceColor', [1 1 1], 'EdgeColor', Color(j,:), 'LineWidth', 1);
            end
        else
            if  sscanf(version,'%f',1)*1000 >= 8400  
                set(H(h), 'FaceColor', Color(j,:), 'markerfacecolor','none');
            else
                set(H{h}, 'FaceColor', Color(j,:), 'markerfacecolor','none');
            end
        end
    end
end

set(gca, 'XTick',((1+Numgroup)/2): Numgroup: (Dim2-(Numgroup-(1+Numgroup)/2)), 'XTickLabel', Lname)

% legend
if strcmpi(Type,'box')||strcmpi(Type,'boxfill')
    if  sscanf(version,'%f',1)*1000 >= 8400
        legend(H(1:Numgroup), Gname, 'Orientation','horizontal','Location','northoutside')
        legend('boxoff');
    else
        warning('off','MATLAB:legend:IgnoringExtraEntries');
        legend(cell2mat(H(1:Numgroup)), Gname, 'Orientation','horizontal','Location','northoutside');
        legend('boxoff');
    end
else
    Gname{1,end+1} = 'Mean';
    if  sscanf(version,'%f',1)*1000 >= 8400
        legend([H(1:Numgroup),H1(1)], Gname, 'Orientation','horizontal','Location','northoutside')
        legend('boxoff');
    else
        warning('off','MATLAB:legend:IgnoringExtraEntries');
        legend([cell2mat(H(1:Numgroup)), H1], Gname, 'Orientation','horizontal','Location','northoutside');
        legend('boxoff');
    end
end

% line positions
xlines = (Numgroup+0.5):Numgroup:(Dim2+0.5-Numgroup);
hx     = zeros(size(xlines));

for n  = 1:length(xlines)
    hx(n) = line([xlines(n) xlines(n)], get(gca,'ylim'), 'Linestyle' ,'-.',...
        'color', [0.83 0.82 0.78], 'tag', 'separator', 'LineWidth', 0.5);
end

set(gca, 'FontName', 'arial', 'box', 'off', 'TickDir', 'in', 'Ylim',...
    [min(Data(:))-range(Data(:)), max(Data(:))+range(Data(:))], 'Xlim', [0.38, Dim2+0.62]);

return