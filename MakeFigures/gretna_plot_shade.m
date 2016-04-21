function gretna_plot_shade(X, Data, Gname, FaceAlpha, Type)
%==========================================================================
% This function is used to create shading around a mean
%
% Syntax: function gretna_plot_shade(X, Data, Gname, FaceAlpha, Type)
%
% Inputs:
%           X:
%            The X-axis (sparsities, etc)
%        Data:
%            1 x N Cellarry with elements being numerical colums of M x C
%            length(N: categories or group; M: subjects; C: conditions, sparsities, or
%            levels. Note: The M maybe unequal, however, the C must be equal!).
%       Gname:
%            group name (e.g.,{'Healthy control','Disease group'} or network mertic{'LocE','GlobE'}).
%   FaceAlpha:
%            The transparency of shade (0.4 is better in vision)
%        Type:
%            'sd'.  (standard deviation)
%            'sem'. (standard error of the mean)
%            'CI'.  (95% confidence level)
%
% Examples:
%        gretna_plot_shade(linspace(0.05,0.49,23), {rand(30,23)+0.3,rand(50,23)/2}, {'LocE','GlobE'}, 0.4)
%
%
% Hao WANG, CCBD, HZNU, Hangzhou, 2015/3/30, hall.wong@outlook.com
%==========================================================================

if nargin < 5
    Type = 'sd';       % standard error of the mean (default)
end

[~,dim2] = size(Data);
NumGname = size(Gname,2);

if NumGname ~= dim2;
    error('Groups must correspond to their names');
end

if NumGname < 8
    Color = get(groot,'DefaultAxesColorOrder');
else
    Color = distinguishable_colors(20);
end

H = gobjects(1,dim2);

for i = 1:dim2
    Datatmp = Data{1,i};
    Xbar = mean(Datatmp);  N = size(Datatmp,1);
    switch lower(Type)
        case 'sd'
            fill([X fliplr(X)],[Xbar+std(Datatmp) fliplr(Xbar-std(Datatmp))], Color(i,:), 'FaceAlpha', FaceAlpha, 'linestyle', 'none');
        case 'sem'
            fill([X fliplr(X)],[Xbar+std(Datatmp)/sqrt(N) fliplr(Xbar-std(Datatmp)/sqrt(N))], Color(i,:), 'FaceAlpha', FaceAlpha, 'linestyle', 'none');
        case 'ci'
            ts = tinv([0.975 0.025], N-1);                % T-Score
            UpCI = Xbar + ts(1)*(std(Datatmp)/sqrt(N));   % upper boundary of 95% confidence level
            LoCI = Xbar + ts(2)*(std(Datatmp)/sqrt(N));   % lower boundary of 95% confidence level
            fill([X fliplr(X)],[UpCI fliplr(LoCI)], Color(i,:), 'FaceAlpha', FaceAlpha, 'linestyle', 'none');
        otherwise
            error('Error.\You shoule specify the parameter =type=!')
    end
    
    hold on
    H(i) = plot(X, Xbar, 'color', Color(i,:), 'linewidth',1.5);
    set(gca,'Xlim',[min(X) max(X)],'Tickdir','out');
end
legend(H, Gname, 'Location','northeast');
hold off;

end