figure
subplot(1,2,1)
gretna_plot_bar({rand(10,3),rand(20,3)},{'HC','AD'},{'INS','PCUN','PCC'},'sem')
subplot(1,2,2)
gretna_plot_bar({rand(10,2),rand(20,2),rand(40,2)},{'HC','aMCI','AD'},{'INS','PCC'},'sem')

figure
subplot(1,2,1)
gretna_plot_dot({rand(10,3),rand(20,3)},{'HC','AD'},{'INS','PCUN','PCC'},'sd')
subplot(1,2,2)
gretna_plot_dot({rand(10,2),rand(20,2),rand(40,2)},{'HC','aMCI','AD'},{'INS','PCC'},'sd')

figure
subplot(2,1,1);
[~] = gretna_plot_hub(rand(36,10),{'A','B','C','D','E','F','G','H','I','J'});
subplot(2,1,2);
[~] = gretna_plot_hub(rand(60,90), 'AAL');
figure
subplot(2,1,1);
[~] = gretna_plot_hub(rand(45,90), 'AAL', 'r', 'b',2);
subplot(2,1,2);
[~] = gretna_plot_hub(rand(45,112), 'HOA');

figure
X=[143 145 146 147 149 150 153 154 155 156 157 158 159 160 162 164]';
Y=[88 85 88 91 92 93 93 95 96 98 97 96 98 99 100 102]';
[mdl] = gretna_plot_regression(Y, X, 'CI');

figure
gretna_plot_shade(linspace(0.05,0.49,23), {rand(30,23)+0.3,rand(50,23)/2}, {'LocE','GlobE'}, 0.4)

figure
subplot(1,2,1)
gretna_plot_violin({rand(10,3),rand(20,3)},{'HC','AD'},{'INS','PCUN','PCC'},'dot')
subplot(1,2,2)
gretna_plot_violin({rand(10,2),rand(20,2),rand(40,2)},{'HC','aMCI','AD'},{'INS','PCC'},'dot')