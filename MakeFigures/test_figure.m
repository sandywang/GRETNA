% just for test the function,the demo was written by Hao Wang, 2016.06

% data
AD = normrnd(3,2,30,3); HC = normrnd(5,2,20,3);
AD(:,2) = AD(:,2)+1;    AD(:,3) = AD(:,3)-1;
HC(:,2) = HC(:,2)-2;

% test
figure
subplot(2,2,1)
gretna_plot_bar({HC,AD},{'HC','AD'},{'INS','PCUN','PCC'},'sem')
subplot(2,2,3)
gretna_plot_dot({HC,AD},{'HC','AD'},{'INS','PCUN','PCC'},'sd')
subplot(1,2,2)
gretna_plot_violin({HC,AD},{'HC','AD'},{'INS','PCUN','PCC'},'dot')
 set(gcf,'Position',[218  104  1050  698])
 
figure
subplot(2,4,1)
gretna_plot_bar({rand(10,1),rand(20,1)},{'HC','AD'},{'INS'},'sd')
subplot(2,4,2)
gretna_plot_bar({rand(10,2)},{'HC'},{'INS','PCC'},'ci')
subplot(1,2,2)
gretna_plot_bar({rand(10,2),rand(20,2),rand(40,2),rand(30,2)},{'HC','aMCI','AD','PD'},{'INS','PCC'},'sem')
subplot(2,2,3)
gretna_plot_bar({rand(10,1),rand(20,1),rand(40,1),rand(10,1),rand(20,1),rand(40,1),rand(10,1)},{'A','B','C','D','E','F','G'},{'INS'},'CI')
set(gcf,'Position',[298    73   852   737])

figure
subplot(2,2,1)
gretna_plot_dot({rand(10,1),rand(20,1)},{'HC','AD'},{'INS'},'sd')
subplot(2,2,2)
gretna_plot_dot({rand(10,2)},{'HC'},{'INS','PCC'},'sem')
subplot(2,1,2)
gretna_plot_dot({rand(10,2),rand(20,2),rand(40,2)},{'HC','aMCI','AD'},{'INS','PCC'},'ci')
set(gcf,'Position',[440   154   623   644])

figure
gretna_plot_hub(rand(36,10),{'A','B','C','D','E','F','G','H','I','J'});
set(gcf,'Position',[440   378   384   420])

figure
subplot(1,2,1);
[ind,~] = gretna_plot_hub(rand(45,90)+0.5, 'AAL',2);
legend off
subplot(1,2,2);
gretna_plot_hub_second(rand(40,90), ind);
set(gcf,'Position',[402     2   528   813])

figure
X=[143 145 146 147 149 150 153 154 155 156 157 158 159 160 162 164]';
Y=[88 85 88 91 92 93 93 95 96 98 97 96 98 99 100 102]';
xdata = (-5:5)';
ydata = (xdata.^2 - 5*xdata - 3 + 5*randn(size(xdata)));
subplot(2,2,1)
gretna_plot_regression(X, Y, 1);
subplot(2,2,2)
gretna_plot_regression(xdata, ydata, 2);
subplot(2,2,3)
gretna_plot_regression(xdata, ydata, 3);
subplot(2,2,4)
gretna_plot_regression(xdata, ydata, 4);
set(gcf,'Position',[327   160   782   606])

figure
gretna_plot_shade(linspace(0.05,0.49,23), {rand(30,23)+0.3,rand(50,23)/2}, {'LocE','GlobE'}, 0.4,'sem')
set(gcf,'Position',[ 440   324   400   474])
 
figure
subplot(3,4,1)
gretna_plot_violin({rand(10,1),rand(16,1)},{'HC','AD'},{'PCC'},'box')
subplot(3,4,2)
gretna_plot_violin({rand(10,2)},{'HC'},{'INS','PCC'},'dot')
subplot(3,4,3)
gretna_plot_violin({rand(10,2)},{'HC'},{'INS','PCC'},'mean')
subplot(3,4,4)
gretna_plot_violin({rand(10,1),rand(16,1)},{'HC','AD'},{'INS'},'meanstd')
subplot(3,4,5)
gretna_plot_violin({rand(18,1),rand(20,1)},{'HC','AD'},{'INS'},'boxfill')
subplot(3,4,6)
gretna_plot_violin({rand(18,1),rand(20,1)},{'HC','AD'},{'MTG'},'dotfill')
subplot(3,4,7)
gretna_plot_violin({rand(18,1),rand(20,1)},{'HC','AD'},{'TPO'},'meanfill')
subplot(3,4,8)
gretna_plot_violin({rand(18,1),rand(20,1)},{'HC','AD'},{'PCC'},'meanstdfill')
subplot(3,2,5)
gretna_plot_violin({rand(23,1),rand(18,1),rand(20,1),rand(18,1),rand(20,1),rand(18,1),rand(20,1)},{'AA','SS','DD','FF','GG','HH','JJ'},{'Testgroup'},'meanstdfill')
subplot(3,2,6)
gretna_plot_violin({rand(10,2),rand(20,2),rand(40,2)},{'HC','aMCI','AD'},{'INS','PCC'},'dotfill')
set(gcf,'Position',[258     0   915   813])
