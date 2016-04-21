function gretna_plot_bar(Data, Gname, Lname, Type)
%==========================================================================
% This function is used to plot a grouped bar graph with error bars
% placed in between each group of bars.
%
% Syntax: function  gretna_plot_bar(Data, Gname, Lname, Type)
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
%            'sd' (standard deviation)
%            'sem'(standard error of the mean)
%            'CI' (95% confidence level)
%
% Examples:
%       We have 2 groups(HC and AD), 10 participants(HC), 20 participants(AD).
%       We found significant differences between groups in three regions.
%       Our input data format should be{rand(10,3),rand(20,3)}).
%
%       gretna_plot_bar({rand(10,3),rand(20,3)},{'HC','AD'},{'INS','PCUN','PCC'},'sem')
%
%
% Hao WANG, CCBD, HZNU, Hangzhou, 2015/05/19, hall.wong@outlook.com
% =========================================================================

if iscell(Data)~=1;
    error('Your input Data must be a 1¡ÁN cell, please check the Examples and Illustration for input:Data in detail.');
end

if nargin < 4
    Type = 'sd';       % standard deviation (default)
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

yMean = nanmean(Data);
yStd  = nanstd(Data);
ySem  = yStd./sqrt(sum(~isnan(Data)));
yCI   = ySem*2;  % (N>15)
% Krzywinski, M., & Altman, N. (2013). Points of significance: error bars. Nature methods, 10(10), 921-922.

yMean = reshape(yMean, Numgroup, Numregion)';
yStd = reshape(yStd, Numgroup, Numregion)';
ySem = reshape(ySem, Numgroup, Numregion)';
yCI = reshape(yCI, Numgroup, Numregion)';

groupwidth = min(0.8, Numgroup/(Numgroup+1.5));
% criteria = groupwidth/(4*Numgroup-1)*0.5;
color = parula(Numgroup);

if Numgroup == 1
    
    x = 1:Numregion;
    H = bar(yMean,'LineStyle','none');
    set(H,'BarWidth',0.66, 'FaceColor',[0 0.45 0.74]);
    set(gca,'xlim',[0 Numregion+1],'xtick', x,'YGrid','off','box','off','TickDir','out');
    hold on
    
    switch lower(Type)
        case 'sd'
            plot([x; x], [yMean yMean+yStd]','color',[0 0.45 0.74],'LineWidth', 2);
        case 'sem'
            plot([x; x], [yMean yMean+ySem]','color',[0 0.45 0.74],'LineWidth', 2);
        case 'ci'
            plot([x; x], [yMean yMean+yCI]','color',[0 0.45 0.74],'LineWidth', 2);
        otherwise
            error('Other types are not supported')
    end
    
else
    
    H = bar(yMean,'LineStyle','none');
    hold on;
    set(H,'BarWidth',0.66);
    set(gca,'Xlim',[0.3 Numregion+0.7],'YGrid','off','box','off','TickDir','out');
    
    for i = 1:Numgroup
        
        x = (1:Numregion) - groupwidth/2 + (2*i-1) * groupwidth / (2*Numgroup);  % Aligning error bar with individual bar (Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange)
        switch lower(Type)
            case 'sd'
                plot([x; x],[yMean(:,i) yMean(:,i)+yStd(:,i)]','color',color(i,:),'LineWidth', 2);
                % plot([x-criteria; x+criteria],[yMean(:,i)+yStd(:,i) yMean(:,i)+yStd(:,i)]','color',color(i,:),'LineWidth', 2);
            case 'sem'
                plot([x; x],[yMean(:,i) yMean(:,i)+ySem(:,i)]','color',color(i,:),'LineWidth', 2);
                % plot([x-criteria; x+criteria],[yMean(:,i)+ySem(:,i) yMean(:,i)+ySem(:,i)]','color',color(i,:),'LineWidth', 2);
            case 'ci'
                plot([x; x],[yMean(:,i) yMean(:,i)+yCI(:,i)]','color', color(i,:),'LineWidth', 2);
                % plot([x-criteria; x+criteria],[yMean(:,i)+yCI(:,i)  yMean(:,i)+yCI(:,i)]','color',color(i,:),'LineWidth', 2);
            otherwise
                error('Other types are not supported, please type: sd or sem or ci ')
        end
        
    end
    
end

ax = gca;
ax.XTickLabel = Lname;
legend(H, Gname, 'Location','northeast');
legend('boxoff');

hold off