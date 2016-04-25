% data
AD = normrnd(3,2,30,3); HC = normrnd(5,2,20,3);
AD(:,2) = AD(:,2)+1;    AD(:,3) = AD(:,3)-1;
HC(:,2) = HC(:,2)-2;

% test
figure
subplot(2,2,1)
gretna_plot_bar({HC,AD},{'HC','AD'},{'INS','PCUN','PCC'},'sem')
subplot(2,2,2)
gretna_plot_dot({HC,AD},{'HC','AD'},{'INS','PCUN','PCC'},'sem')
subplot(2,2,3)
gretna_plot_violin({HC,AD},{'HC','AD'},{'INS','PCUN','PCC'},'dot')

figure
subplot(2,2,1)
gretna_plot_bar({rand(10,1),rand(20,1)},{'HC','AD'},{'INS'},'sem')
subplot(2,2,2)
gretna_plot_bar({rand(10,2),rand(20,2),rand(40,2)},{'HC','aMCI','AD'},{'INS','PCC'},'sem')
subplot(2,2,3)
gretna_plot_bar({rand(10,3)},{'HC'},{'INS','PCC','TPO'},'sem')

figure
subplot(2,2,1)
gretna_plot_dot({rand(10,1),rand(20,1)},{'HC','AD'},{'INS'},'sd')
subplot(2,2,2)
gretna_plot_dot({rand(10,2),rand(20,2),rand(40,2)},{'HC','aMCI','AD'},{'INS','PCC'},'sd')
subplot(2,2,3)
gretna_plot_dot({rand(10,3)},{'HC'},{'INS','PCC','TPO'},'sem')


figure
subplot(2,1,1);
gretna_plot_hub(rand(36,10),{'A','B','C','D','E','F','G','H','I','J'});
subplot(2,1,2);
gretna_plot_hub(rand(60,90), 'AAL');
figure
subplot(2,1,1);
gretna_plot_hub(rand(45,90), 'AAL', 'r', 'b',2);
subplot(2,1,2);
gretna_plot_hub(rand(45,112), 'HOA');

figure
X=[143 145 146 147 149 150 153 154 155 156 157 158 159 160 162 164]';
Y=[88 85 88 91 92 93 93 95 96 98 97 96 98 99 100 102]';
[mdl] = gretna_plot_regression(X, Y, 'CI');

figure
gretna_plot_shade(linspace(0.05,0.49,23), {rand(30,23)+0.3,rand(50,23)/2}, {'LocE','GlobE'}, 0.4,'sem')

figure
subplot(2,2,1)
gretna_plot_violin({rand(10,1),rand(20,1)},{'HC','AD'},{'INS'},'dot')
subplot(2,2,2)
gretna_plot_violin({rand(10,2),rand(20,2),rand(40,2)},{'HC','aMCI','AD'},{'INS','PCC'},'dot')
subplot(2,2,3)
gretna_plot_violin({rand(10,3)},{'HC'},{'INS','PCC','TPO'},'box')