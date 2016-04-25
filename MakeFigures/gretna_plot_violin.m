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
%            'dot' or 'DOT': scatterplot (default).
%            'box' or 'BOX': boxplot.
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

Numregion = Dim2/Numgroup;
Numgname  = size(Gname, 2);
Numlname  = size(Lname, 2);

if Numgroup ~= Numgname
    error('The number of groups must be equal to the number of inputted group names'); end

if Numregion ~= Numlname
    error('The number of variables must be equal to the number of inputted variable names'); end

% Plot the violins
if Numgname < 8
    Color = [0.078 0.631 0.678; 0.878 0.671 0.031; 0.973 0.212 0.047;...
        0.47 0.67 0.19; 0.49 0.18 0.56; 0.8 0.8 0.8; 0.3 0.75 0.93];
else
    Color = distinguishable_colors(100);
end

F     = zeros(2^8, Dim2);
U     = zeros(2^8, Dim2);
Mdata = zeros(Dim2, 1);

for i = 1:Dim2
    [f, xi]  = ksdensity(Data(:,i), 'npoints', 2^8);
    F(:,i)   = f/max(f)*0.3;
    U(:,i)   = xi;
    Mdata(i) = nanmean(Data(:,i));
end

hold on;

H  = gobjects(1, Dim2);
H1 = gobjects(1, Dim2);

for i = 1:Dim2
    H(i)  = fill([F(:,i)+i; flipud(i-F(:,i))],[U(:,i); flipud(U(:,i))], [1 1 1], 'EdgeColor','none');
    H1(i) = plot([interp1(U(:,i), F(:,i)+i, Mdata(i)), interp1(flipud(U(:,i)), flipud(i-F(:,i)), Mdata(i)) ], [Mdata(i) Mdata(i)], 'r', 'LineWidth', 1.5);
end

for j = 1:Numgroup
    set(H(j:Numgroup:Dim2), 'FaceColor', Color(j,:), 'markerfacecolor', 'none');
end

switch lower(Type)
    case 'box'
        boxplot(Data, 'PlotStyle', 'compact', 'BoxStyle', 'outline', 'Widths', 0.1, 'Whisker', 1, 'Colors', 'k');
        set(findobj(gcf, '-regexp', 'Tag', '\w*Whisker'), 'LineStyle', '-');
    case 'dot'
        ch = plotSpread(Data, 'distributionColors', {[0.3 0.3 0.3]});
        set(ch{1,3}.Children, 'MarkerSize', 8);
    otherwise
        error('The inputted Type is not recognized, please check it!');
end

ax            = gca;
ax.XTick      = ((1+Numgroup)/2): Numgroup: (Dim2-(Numgroup-(1+Numgroup)/2));
ax.XTickLabel = Lname;

% legend
Gname{1,end+1} = 'Mean';
legend([H(1:Numgroup),H1(1)], Gname, 'Location','northeast');

% line positions
xlines = (Numgroup+0.5):Numgroup:(Dim2+0.5-Numgroup);
hx     = zeros(size(xlines));

for n  = 1:length(xlines);
    hx(n) = line([xlines(n) xlines(n)], [min(Data(:))-0.309*range(Data(:)), max(Data(:))+0.309*range(Data(:))],...
        'Linestyle' ,'-.' ,'color', .5+zeros(1,3), 'tag', 'separator', 'LineWidth', 1.5);
end

set(gca, 'FontName', 'arial', 'box', 'off', 'TickDir', 'out', 'Ylim', [min(Data(:))-range(Data(:)), max(Data(:))+range(Data(:))]);

hold off;

return