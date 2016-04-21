function gretna_plot_violin(Data, Gname, Lname, Type)
%==========================================================================
% This function is used to create shading around a mean
%
% Syntax: function  gretna_plot_violin(Data, Gname, Lname, Type)
%
% Inputs:
%       Data:
%            1 x N Cellarry with elements being numerical colums of M x C
%            length(N: categories or group; M: subjects; C: brain regions, conditions or
%            levels. Note: The M maybe unequal, however, the C must be equal!).
%      Gname:
%            group name (e.g.,{'Healthy control','Disease group'} or {'HC','PD','AD'}).
%      Lname:
%            label name (the names of Conditions or ROIs, e.g.,{'INS','TPO','PCUN','PCC'}).
%       Type:
%            'box'
%            'dot'
%
% Examples:
%       We have 2 groups(HC and AD), 10 participants(HC), 20 participants(AD).
%       We found significant differences between groups in three regions.
%       Our input data format should be{rand(10,3),rand(20,3)}).
%
%       gretna_plot_violin({rand(10,3),rand(20,3)},{'HC','AD'},{'INS','PCUN','PCC'},'dot')
%
%
% Hao WANG, CCBD, HZNU, Hangzhou, 2015/11/11, hall.wong@outlook.com
%==========================================================================

if iscell(Data)~=1;
    error('Your input Data must be a 1¡ÁN cell, please check the Examples and Illustration for input:Data in detail.');
end

if nargin < 4
    Type = 'dot';       
end

Numgroup = size(Data,2);
Data = gretna_fill_nan(Data);
[~, dim2] = size(Data);
Numregion = dim2/Numgroup;

NumLname = size(Lname,2);
NumGname = size(Gname,2);

if NumLname ~= Numregion || NumGname ~= Numgroup;
    error('Groups and brain regions must correspond to their names');
end

% Plot the violins
if NumGname < 8
    Color = get(groot,'DefaultAxesColorOrder');
else
    Color = distinguishable_colors(20);
end

F = zeros(2^8,dim2);
U = zeros(2^8,dim2);
Mdata = zeros(dim2,1);

for i=1:dim2
    [f,xi] = ksdensity(Data(:,i),'npoints',2^8);
    f = f/max(f)*0.3;  % Normalize
    F(:,i)=f;
    U(:,i)=xi;
    Mdata(i)=nanmean(Data(:,i));
end

hold on

H = gobjects(1,dim2);
H1 = gobjects(1,dim2);

for i=1:dim2
    H(i)=fill([F(:,i)+i;flipud(i-F(:,i))],[U(:,i);flipud(U(:,i))],[1 1 1],'EdgeColor','none');
    H1(i) = plot([interp1(U(:,i),F(:,i)+i,Mdata(i)), interp1(flipud(U(:,i)),flipud(i-F(:,i)),Mdata(i)) ],[Mdata(i) Mdata(i)],'r','LineWidth',1.5);
end

for j = 1:Numgroup
     set(H(j:Numgroup:dim2),'FaceColor', Color(j,:),'markerfacecolor', 'none');
end
       
switch lower(Type)
    case 'box'
        boxplot(Data,'PlotStyle','compact','BoxStyle','outline','Widths',0.1,'Whisker',1,'Colors','k');
        set(findobj(gcf,'-regexp','Tag','\w*Whisker'),'LineStyle','-');
    case 'dot'
        ch = plotSpread(Data,'distributionColors',{[0.3 0.3 0.3]});
        set(ch{1,3}.Children,'MarkerSize',8);
    otherwise
        error('Other types are not supported')
end

ax = gca;
ax.XTick = ((1+Numgroup)/2):Numgroup:(dim2-(Numgroup-(1+Numgroup)/2));
ax.XTickLabel = Lname;

Gname{1,end+1} = 'Mean';
legend([H(1:Numgroup),H1(1)], Gname, 'Location','northeast');

% line positions
xlines = (Numgroup+0.5):Numgroup:(dim2+0.5-Numgroup);
hx = zeros(size(xlines)); 

for n  = 1:length(xlines);         
    hx(n)= line([xlines(n) xlines(n)],[min(Data(:))-0.309*range(Data(:)), max(Data(:))+0.309*range(Data(:))],...
        'Linestyle','-.','color',.5+zeros(1,3),'tag','separator','LineWidth',1.5);
end

set(gca, 'FontName','arial','box','off', 'TickDir','out','Ylim',[min(Data(:))-range(Data(:)), max(Data(:))+range(Data(:))]);

hold off

return

