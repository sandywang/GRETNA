function gretna_plot_dot(Data, Gname, Lname, Type)
%==========================================================================
% This function is used to plot dot.
% The distribution of the data and the sample size are critical considerations 
% when selecting statistical tests. dot plot immediately convey this important information.
%
% Syntax: function gretna_plot_dot(Data, Gname, Lname, Type)
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
%            'sd'  (standard deviation)
%            'sem' (standard error of the mean)
%            'CI'  (95% confidence level)
%            'mean'(just plot dots and mean values)   
%
% Examples:
%       We have 2 groups(HC and AD), 10 participants(HC), 20 participants(AD).
%       We found significant differences between groups in three regions.
%       Our input data format should be{rand(10,3),rand(20,3)}).
%
%       gretna_plot_dot({rand(10,3),rand(20,3)},{'HC','AD'},{'INS','PCUN','PCC'},'sd')
%
%
% Hao WANG, CCBD, HZNU, Hangzhou, 2015/11/11, hall.wong@outlook.com
%==========================================================================

if iscell(Data)~=1;
    error('Your input Data must be a 1¡ÁN cell, please check the Examples and Illustration for input:Data in detail.');
end

if nargin < 4
    Type = 'sd';       % standard deviation (default)
end

Numgroup = size(Data,2);
Data = gretna_fill_nan(Data);   % fill nan to make the cell to a matix
[~, dim2] = size(Data);
Numregion = dim2/Numgroup;

yMean = nanmean(Data);
yStd  = nanstd(Data);
ySem  = yStd./sqrt(sum(~isnan(Data)));
yCI   = ySem*2;  % (N>15)
% Krzywinski, M., & Altman, N. (2013). Points of significance: error bars. Nature methods, 10(10), 921-922.

NumLname = size(Lname,2);
NumGname = size(Gname,2);

if NumLname ~= Numregion || NumGname ~= Numgroup;
    error('Groups and brain regions must correspond to their names');
end

ratio = 0.15;

switch lower(Type)
    case 'sd'
        for i = 1:dim2
            rectangle('Position',[i-ratio,yMean(i)-yStd(i),2*ratio,2*yStd(i)],'FaceColor',[0.83 0.83 0.78],'Linestyle','none');
            % rectangle('Position',[i-ratio,yMean(i)-yCI(i),2*ratio,2*yCI(i)],'FaceColor',[0.5 0.5 0.5],'Linestyle','none');
        end
    case 'sem'
        for i = 1:dim2
            % rectangle('Position',[i-ratio,yMean(i)-yCI(i),2*ratio,2*yCI(i)],'FaceColor',[0.5 0.5 0.5],'Linestyle','none');
            rectangle('Position',[i-ratio,yMean(i)-ySem(i),2*ratio,2*ySem(i)],'FaceColor',[0.83 0.83 0.78],'Linestyle','none');
        end
    case 'ci'
        for i = 1:dim2
            rectangle('Position',[i-ratio,yMean(i)-yCI(i),2*ratio,2*yCI(i)],'FaceColor',[0.83 0.83 0.78],'Linestyle','none');
        end
    case 'mean'
        display('just plot dots and mean values')
    otherwise
        error('Other types are not supported')
end

Ch = plotSpread(Data);
H = Ch{1,3}.Children;

if NumGname < 8
    Color = get(groot,'DefaultAxesColorOrder');
else
    Color = distinguishable_colors(20);
end

for j = 1:Numgroup
    set(H(j:Numgroup:dim2),'Color', Color(Numgroup+1-j,:),'MarkerSize',10,'Marker','.','markerfacecolor', 'none');
end

Databar = nanmean(Data);
Lxlim = (1:dim2)-ratio; Rxlim = (1:dim2)+ratio;
plot([Lxlim; Rxlim],[Databar; Databar],'k-','linewidth',1.5);
set(gca,'TickDir','out','XLim',[0.5 dim2+0.5],'YLim', [min(Data(:))-0.309*range(Data(:)), max(Data(:))+0.309*range(Data(:))]);  % 0.618/2 to Visualize Better

ax = gca;
ax.XTick = ((1+Numgroup)/2):Numgroup:(dim2-(Numgroup-(1+Numgroup)/2));
ax.XTickLabel = Lname;

legend(H(Numgroup:1), Gname, 'Location','northeast');

hold off

return