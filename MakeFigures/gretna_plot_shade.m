function gretna_plot_shade(Xdata, Ydata, Gname, FaceAlpha, Type)

%==========================================================================
% This function is used to plot line graphs with shading.
%
%
% Syntax: function gretna_plot_shade(Xdata, Ydata, Gname, FaceAlpha, Type)
%
% Inputs:
%       Xdata:
%            1*C data array.
%       Ydata:
%            1*N cell with each element being a M*C data array (N, the
%            number of groups; M, the number of subjects; C, the number of
%            sampling points in Xdata). NOTE, M can vary across groups.
%       Gname:
%            Group names (e.g.,{'HC','AD'}).
%   FaceAlpha:
%            The transparency of shading (default is 0.4).
%        Type:
%            'sd'  or 'SD':  standard deviation (default).
%            'sem' or 'SEM': standard error of the mean.
%            'ci'  or 'CI':  95% confidence interval.
%
% Example:
%       Suppose that we compared global efficiency of functional brain
%       netowrks between 10 AD patietns and 20 healthy controls over a
%       series of successive network sparsities (S = [0.05 0.06 0.07 0.08]),
%       and found significant between-group differences. The global efficiency
%       were sorted in data1 (10*4) for the AD patients and data2 (20*4)
%       for healthy controls. Then, you can run the code as follows:
%
%        gretna_plot_shade(S, {data1,data2}, {'AD','HC'})
%
% Hao WANG, CCBD, HZNU, Hangzhou, 2015/3/30, hall.wong@outlook.com
%==========================================================================

if nargin < 3
    error('At least three arguments are needed!'); end

if nargin == 3
    FaceAlpha = 0.4; Type = 'sd'; end

if nargin == 4
    Type = 'sd'; end

if nargin > 5
    error('At most five arguments are permitted!'); end

if ~iscell(Ydata) || ~iscell(Gname)
    error('The inputted Data must be cell format, please check it!'); end

if size(Ydata,1) ~= 1
    error('The inputted Data must be a 1*N cell, please check it!');
end

Dim2     = size(Ydata, 2);
Numgname = size(Gname, 2);

if Numgname ~= Dim2;
    error('The number of groups must be equal to the number of inputted group names');
end

if Numgname < 8
    Color = [0.078 0.631 0.678; 0.878 0.671 0.031; 0.973 0.212 0.047;...
        0.47 0.67 0.19; 0.49 0.18 0.56; 0.8 0.8 0.8; 0.3 0.75 0.93];
else
    Color = distinguishable_colors(100);
end

FullMatlabVersion = sscanf(version,'%d.%d.%d.%d%s');

if FullMatlabVersion(1)*1000+FullMatlabVersion(2)>=8*1000+4  % Modified by Sandy
    
    H = gobjects(1,Dim2);
    
    for i = 1:Dim2
        Datatmp = Ydata{1,i};
        Xbar    = mean(Datatmp);  N = size(Datatmp,1);
        
        switch lower(Type)
            case 'sd'
                fill([Xdata fliplr(Xdata)], [Xbar+std(Datatmp) fliplr(Xbar-std(Datatmp))], Color(i,:), 'FaceAlpha', FaceAlpha, 'linestyle', 'none');
            case 'sem'
                fill([Xdata fliplr(Xdata)], [Xbar+std(Datatmp)/sqrt(N) fliplr(Xbar-std(Datatmp)/sqrt(N))], Color(i,:), 'FaceAlpha', FaceAlpha, 'linestyle', 'none');
            case 'ci'
                ts = tinv([0.975 0.025], N-1);                % T-Score
                UpCI = Xbar + ts(1)*(std(Datatmp)/sqrt(N));   % upper boundary of 95% confidence interval
                LoCI = Xbar + ts(2)*(std(Datatmp)/sqrt(N));   % lower boundary of 95% confidence interval
                fill([Xdata fliplr(Xdata)], [UpCI fliplr(LoCI)], Color(i,:), 'FaceAlpha', FaceAlpha, 'linestyle', 'none');
            otherwise
                error('The inputted Type is not recognized, please check it!')
        end
        
        hold on;
        
        H(i) = plot(Xdata, Xbar, 'color', Color(i,:), 'linewidth', 1.5);
        set(gca, 'Xlim', [min(Xdata) max(Xdata)], 'Tickdir', 'out');
    end
    
    legend(H, Gname, 'Location', 'northeast');
    
else
    
    H = cell(1,Dim2);
    
    for i = 1:Dim2
        Datatmp = Ydata{1,i};
        Xbar    = mean(Datatmp);  N = size(Datatmp,1);
        
        switch lower(Type)
            case 'sd'
                fill([Xdata fliplr(Xdata)], [Xbar+std(Datatmp) fliplr(Xbar-std(Datatmp))], Color(i,:), 'FaceAlpha', FaceAlpha, 'linestyle', 'none');
            case 'sem'
                fill([Xdata fliplr(Xdata)], [Xbar+std(Datatmp)/sqrt(N) fliplr(Xbar-std(Datatmp)/sqrt(N))], Color(i,:), 'FaceAlpha', FaceAlpha, 'linestyle', 'none');
            case 'ci'
                ts = tinv([0.975 0.025], N-1);                % T-Score
                UpCI = Xbar + ts(1)*(std(Datatmp)/sqrt(N));   % upper boundary of 95% confidence interval
                LoCI = Xbar + ts(2)*(std(Datatmp)/sqrt(N));   % lower boundary of 95% confidence interval
                fill([Xdata fliplr(Xdata)], [UpCI fliplr(LoCI)], Color(i,:), 'FaceAlpha', FaceAlpha, 'linestyle', 'none');
            otherwise
                error('The inputted Type is not recognized, please check it!')
        end
        
        hold on;
        
        H{i} = plot(Xdata, Xbar, 'color', Color(i,:), 'linewidth', 1.5);
        set(gca, 'Xlim', [min(Xdata) max(Xdata)], 'Tickdir', 'out');
    end
    
    legend(cell2mat(H)', Gname', 'Location', 'northeast');
    
end

hold off;

return