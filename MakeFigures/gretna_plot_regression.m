function [mdl] = gretna_plot_regression(Y, X, Type, Type_hist)
%==========================================================================
% This function is used to perform regress analysis.
%
% Syntax: [mdl] = gretna_plot_regression(Y, X, Type, Type_hist)
%
% Inputs:
%        Y: 
%           is an n-by-1 vector of observed responses.
%        X: 
%           is an n-by-1 matrix of predictors at each of n observations.
%
%     Type: 
%           'PI' or  'CI' (Either 'observation' (the default) to compute
%            prediction intervals for new observations at the values in X, or 'curve'
%            to compute confidence intervals for the fit evaluated at the values in X).
% Type_hist: 
%           'on' or 'off'.
%
% Examples:
%           X=[143 145 146 147 149 150 153 154 155 156 157 158 159 160 162 164]';
%           Y=[88 85 88 91 92 93 93 95 96 98 97 96 98 99 100 102]';
%           [mdl] = gretna_plot_regression(Y, X, 'CI');
%
%
% Hao WANG, CCBD, HZNU, Hangzhou, 2015/11/18, hall.wong@outlook.com
%==========================================================================

if nargin < 3
    Type = 'ci';  Type_hist = 'off';
end

if nargin < 4
    Type_hist = 'off';  
end

tbl = table(Y, X);
mdl = fitlm(tbl, 'Y~1+X');

Y = Y'; X = X';
% plot(X, Y,'k.','Markersize',15);
[p,s] = polyfit(X, Y, 1);

switch lower(Type)
    case 'ci'
        [yfit,dy] = polyconf(p,X ,s,'predopt','curve');       %  'curve' to compute confidence intervals.
    case 'pi'
        [yfit,dy] = polyconf(p,X ,s,'predopt','observation'); %  'observation' (the default) to compute prediction intervals.
    otherwise
        error('Other types are not supported')
end

switch lower(Type_hist)
    case 'on'
        scatterhist(X,Y,'Marker','.','MarkerSize',10, 'Color','k', 'Nbins', round(length(X)./3), 'Direction','out','Kernel','overlay'); % Nbin: the number of the bins.
    case 'off'
        scatter(X,Y,'o','k');
    otherwise
        error('Other types are not supported')
end

hold on;
line(X,yfit,'color',[0 0.45 0.74],'Linewidth',2);
Border = [yfit+dy; yfit-dy];

[X,index] = sort(X);
Border = Border(:,index);

fill([X fliplr(X)],[Border(1,:) fliplr(Border(2,:))],[0.5 0.5 0.5], 'FaceAlpha', 0.4, 'linestyle', 'none');
set(gca,'TickDir','out','box','on','Xlim',[min(X) max(X)]);

% Add a legend.
switch lower(Type)
    case 'ci'
        legend( 'Data','Fit curve','95% CI');
    case 'pi'
        legend( 'Data','Fit curve','95% PI');
end
hold off;
return