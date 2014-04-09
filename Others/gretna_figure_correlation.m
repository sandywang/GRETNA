function gretna_figure_correlation(Para, VarOfInterest, Covariate)

%==========================================================================
% This function is used to plot linearly fitted lines between Para and a
% variable of interest.
%
%
% Syntax: function gretna_figure_correlation(Para, VarOfInterest, Cov)
%
% Inputs:
%          Para:
%                m*n array with m being observations and n being variables.
%          VarOfInterest:
%                The directory & filename of a .txt file that contains
%                the varaible (one colume). NOTE, the order of values in
%                VarOfInterest should be the same as those in Para.
%          Covariate (optional):
%                The directory & filename of a .txt file that contains
%                the covariates. NOTE, the order of values in each covarite
%                should be the same as those in Para.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

[~,n] = size(Para);

if n > 9
    warning('VisCorrelation:muchvar','Suggest to contain <= 9 variables in Para for the sake of visualization')
end

Desnmatrix = VarOfInterest;
if nargin == 3
    Desnmatrix = [Desnmatrix Covariate];
end

intercept = zeros(n,1);
slope     = zeros(n,1);
% remove confounding
for i = 1:n
    stat = regstats(Para(:,i), Desnmatrix, 'linear', {'r','tstat'});
    Para(:,i) = stat.tstat.beta(1) + stat.tstat.beta(2).*VarOfInterest + stat.r;
    intercept(i,1) = stat.tstat.beta(1);
    slope(i,1)     = stat.tstat.beta(2);
end

% figure
figure
if n == 1
    Xdata = VarOfInterest;
    Ydata = VarOfInterest.*slope + intercept;
    plot(VarOfInterest, Para, 's', 'MarkerSize',3, 'MarkerFaceColor',[0.04 0.52 0.78], 'MarkerEdgeColor', [0.04 0.52 0.78])
    hold on
    plot(Xdata, Ydata, 'LineStyle', '--', 'Color', [0.04 0.52 0.78], 'LineWidth', 1)
    
elseif 1 < n && n<=3
    for i = 1:n
        Xdata = VarOfInterest;
        Ydata = VarOfInterest.*slope(i) + intercept(i);
        subplot(1,3,i)
        plot(VarOfInterest, Para(:,i), 's', 'MarkerSize',3, 'MarkerFaceColor',[0.04 0.52 0.78], 'MarkerEdgeColor', [0.04 0.52 0.78])
        hold on
        plot(Xdata, Ydata, 'LineStyle', '--', 'Color', [0.04 0.52 0.78], 'LineWidth', 1)
    end
    
elseif 3 < n && n <= 6
    for i = 1:n
        Xdata = VarOfInterest;
        Ydata = VarOfInterest.*slope(i) + intercept(i);
        subplot(2,3,i)
        plot(VarOfInterest, Para(:,i), 's', 'MarkerSize',3, 'MarkerFaceColor',[0.04 0.52 0.78], 'MarkerEdgeColor', [0.04 0.52 0.78])
        hold on
        plot(Xdata, Ydata, 'LineStyle', '--','Color', [0.04 0.52 0.78], 'LineWidth', 1)
    end
    
elseif 6 < n && n <= 9
    for i = 1:n
        Xdata = VarOfInterest;
        Ydata = VarOfInterest.*slope(i) + intercept(i);
        subplot(3,3,i)
        plot(VarOfInterest, Para(:,i), 's', 'MarkerSize',3, 'MarkerFaceColor',[0.04 0.52 0.78], 'MarkerEdgeColor', [0.04 0.52 0.78])
        hold on
        plot(Xdata, Ydata, 'LineStyle', '--', 'Color', [0.04 0.52 0.78], 'LineWidth', 1)
    end
end

set(gca,'TickDir','out')

return