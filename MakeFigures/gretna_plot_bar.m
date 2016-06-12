function gretna_plot_bar(Data, Gname, Lname, Type)

%==========================================================================
% This function is used to plot grouped bar graphs.
%
%
% Syntax: function gretna_plot_bar(Data, Gname, Lname, Type)
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
%            'sd'  or 'SD':  standard deviation (default).
%            'sem' or 'SEM': standard error of the mean.
%            'ci'  or 'CI':  95% confidence interval.
%
% Example:
%       Suppose that we compared nodal degree for 90 regions between 10 AD
%       patietns and 20 healthy controls, and found significant between-group
%       differences in three regions. The degree values for the three regions
%       were sorted in data1 (10*3) for the AD patients and data2 (20*3)
%       for healthy controls. Then, you can run the code as follows:
%
%       gretna_plot_bar({data1,data2},{'AD','HC'},{'Reg1','Reg2','Reg3'},'ci')
%
% Hao WANG, CCBD, HZNU, Hangzhou, 2015/05/19, hall.wong@outlook.com
% =========================================================================

if nargin < 3
    error('At least three arguments are needed!'); end

if nargin == 3
    Type = 'sd'; end

if nargin > 4
    error('At most four arguments are permitted!'); end

if ~iscell(Data) || ~iscell(Gname) || ~iscell(Lname)
    error('The inputted Data, Gname and Lname all MUST be cell format, please check it!'); end

if size(Data,1) ~= 1
    error('The inputted Data must be a 1*N cell, please check it!');
end

Numgroup  = size(Data,2);

Data      = gretna_fill_nan(Data);
[~, Dim2] = size(Data);

Numregion = Dim2/Numgroup;
Numlname  = size(Lname, 2);
Numgname  = size(Gname, 2);

if Numgroup ~= Numgname
    error('The number of groups must be equal to the number of inputted group names'); end

if Numregion ~= Numlname
    error('The number of variables must be equal to the number of inputted variable names'); end

yMean = nanmean(Data);
yStd  = nanstd(Data);
ySem  = yStd./sqrt(sum(~isnan(Data)));
yCI   = ySem*2;  % (N > 15)
% Krzywinski, M., & Altman, N. (2013). Points of significance: error bars. Nature methods, 10(10), 921-922.

yMean = reshape(yMean, Numgroup, Numregion)';
yStd  = reshape(yStd, Numgroup, Numregion)';
ySem  = reshape(ySem, Numgroup, Numregion)';
yCI   = reshape(yCI, Numgroup, Numregion)';

groupwidth = min(0.8, Numgroup/(Numgroup+1.5));
% criteria = groupwidth/(4*Numgroup-1)*0.5;

if Numgname < 8
    Color = [0.078 0.631 0.678; 0.878 0.671 0.031; 0.973 0.212 0.047;...
        0.47 0.67 0.19; 0.49 0.18 0.56; 0.8 0.8 0.8; 0.3 0.75 0.93];
else
    Color = distinguishable_colors(100);
end

if Numgroup == 1
    
    x = 1:Numregion;
    H = bar(yMean, 'LineStyle', '-');
    set(H, 'BarWidth', 0.66, 'FaceColor', [0.49 0.49 0.49]);
    set(gca, 'xlim', [0 Numregion+1], 'xtick', x, 'YGrid', 'off', 'box', 'off', 'TickDir', 'out');
    
    hold on;
    %% Modified by Sandy, Show the upper or lower half error bar
    switch lower(Type)
        case 'sd'
            %plot([x; x], [yMean - yStd yMean + yStd]', 'color', [0.49 0.49 0.49], 'LineWidth', 2);
            yErr=yStd;
        case 'sem'
            %plot([x; x], [yMean - ySem yMean + ySem]', 'color', [0.49 0.49 0.49], 'LineWidth', 2);
            yErr=ySem;
        case 'ci'
            %plot([x; x], [yMean - yCI  yMean + yCI]',  'color',  [0.49 0.49 0.49], 'LineWidth', 2);
            yErr=yCI;
        otherwise
            error('The inputted Type is not recognized, please check it!')
    end
    yErrBar=zeros(Numregion, 2);
    for nr=1:Numregion
        yOneMean=yMean(nr, 1);
        if yOneMean >=0
            yErrBar(nr, 1)=yOneMean;
            yErrBar(nr, 2)=yOneMean + yErr(nr, 1);
        else
            yErrBar(nr, 1)=yOneMean - yErr(nr, 1);
            yErrBar(nr, 2)=yOneMean;            
        end
    end
    plot([x; x], yErrBar',  'color',  [0.49 0.49 0.49], 'LineWidth', 2);
else
    
    if Numregion == 1
        
        yMean_new = diag(yMean);
        H = bar(yMean_new, 'stack');
        
        for i = 1:Numgroup
            set(H(i), 'FaceColor', Color(i,:), 'BarWidth', 0.66); 
        end
        
        hold on;
        
        for i = 1:Numgroup;
           %% Modified by Sandy, Show the upper or lower half error bar
            switch lower(Type)
                case 'sd'
                    %plot([i; i], [yMean(:,i) - yStd(:,i);  yMean(:,i) + yStd(:,i)]', 'color', Color(i,:), 'LineWidth', 2);
                    yErr = yStd;
                case 'sem'
                    %plot([i; i], [yMean(:,i) - ySem(:,i);  yMean(:,i) + ySem(:,i)]', 'color', Color(i,:), 'LineWidth', 2);
                    yErr = ySem;
                case 'ci'
                    %plot([i; i], [yMean(:,i) - yCI(:,i);   yMean(:,i) + yCI(:,i)]',  'color', Color(i,:), 'LineWidth', 2);
                    yErr = yCI;
                otherwise
                    error('The inputted Type is not recognized, please check it!')
            end
            yErrBar=zeros(Numregion, 2);
            for nr=1:Numregion
                yOneMean=yMean(nr, i);
                if yOneMean >=0
                    yErrBar(nr, 1)=yOneMean;
                    yErrBar(nr, 2)=yOneMean + yErr(nr, i);
                else
                    yErrBar(nr, 1)=yOneMean - yErr(nr, i);
                    yErrBar(nr, 2)=yOneMean;            
                end
            end
            plot([i; i], yErrBar',  'color', Color(i,:), 'LineWidth', 2);
        end
        
        set(gca, 'xlim', [0 Numgroup + 1], 'xtick', median(1:Numgroup), 'YGrid', 'off', 'box', 'off', 'TickDir', 'out');
        
    else
        
        H = bar(yMean, 'LineStyle', '-');
        hold on;
        set(gca, 'Xlim', [0.3 Numregion + 0.7], 'xtick', 1:Numregion, 'YGrid', 'off', 'box', 'off', 'TickDir', 'out');
        
        for i = 1:Numgroup
            
            set(H(i), 'FaceColor', Color(i,:), 'BarWidth', 0.66);
            
            % Aligning error bar with individual bar (Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange)
            x = (1:Numregion) - groupwidth/2 + (2*i-1) * groupwidth / (2*Numgroup);
           %% Modified by Sandy, Show the upper or lower half error bar 
            switch lower(Type)
                case 'sd'
                    %plot([x; x], [yMean(:,i) - yStd(:,i)  yMean(:,i) + yStd(:,i)]', 'color', Color(i,:), 'LineWidth', 2);
                    % plot([x-criteria; x+criteria],[yMean(:,i)+yStd(:,i) yMean(:,i)+yStd(:,i)]','color',color(i,:),'LineWidth', 2);
                    yErr = yStd;
                case 'sem'
                    %plot([x; x], [yMean(:,i) - ySem(:,i)  yMean(:,i) + ySem(:,i)]', 'color', Color(i,:), 'LineWidth', 2);
                    % plot([x-criteria; x+criteria],[yMean(:,i)+ySem(:,i) yMean(:,i)+ySem(:,i)]','color',color(i,:),'LineWidth', 2);
                    yErr = ySem;
                case 'ci'
                    %plot([x; x], [yMean(:,i) - yCI(:,i)   yMean(:,i) + yCI(:,i)]',  'color', Color(i,:), 'LineWidth', 2);
                    % plot([x-criteria; x+criteria],[yMean(:,i)+yCI(:,i)  yMean(:,i)+yCI(:,i)]','color',color(i,:),'LineWidth', 2);
                    yErr = yCI;
                otherwise
                    error('The inputted Type is not recognized, please check it');
            end
            yErrBar=zeros(Numregion, 2);
            for nr=1:Numregion
                yOneMean=yMean(nr, i);
                if yOneMean >=0
                    yErrBar(nr, 1)=yOneMean;
                    yErrBar(nr, 2)=yOneMean + yErr(nr, i);
                else
                    yErrBar(nr, 1)=yOneMean - yErr(nr, i);
                    yErrBar(nr, 2)=yOneMean;            
                end
            end
            plot([x; x], yErrBar',  'color', Color(i,:), 'LineWidth', 2);            
        end
        
    end
    
end

ax = gca;   
%ax.XTickLabel = Lname; Modified by Sandy, Compatibility
set(ax, 'XTickLabel', Lname);

legend(H, Gname, 'Location', 'northeast');
legend('boxoff');

hold off;

return