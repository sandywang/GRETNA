function [Para, R2]= gretna_degree_distribution(Deg, Nbins)

%==========================================================================
% This function is used to fit the degree (also betweenness and others)
% distribution of a network G in terms of three types:
%    Tpye1: exponential truncated power law fitting
%                p(k) = a * k^(alpha-1) * exp(-k/kc);
%    Tpye2: power law fitting
%                p(k) = a * k^(1-alpha);
%    Tpye3: exponential fitting
%                p(k) = a * exp(-alpha/k).
%
% Syntax: functiona [Para, R2]= gretna_degree_distribution_fit(Deg,Nbins)
%
% Inputs:
%          Deg:
%             Nodal degree (n*1 array).
%          Nbins:
%             The number of equally spaced containersthe that the elements
%             in 'Deg' is binned (default Nbins = 10).
% Outputs:
%          Para.exponentialtruncated:
%             The fitting parameters for exponential truncated power law
%             fitting.
%          Para.powerlaw:
%             The fitting parameters for power law fitting.
%          Para.exponential:
%             The fitting parameters for exponential fitting.
%          R2.exponentialtruncated:
%             The goodness-of-fit (a value closer to 1 indicates a better
%             fitting) for exponential truncated power law fitting.
%          R2.powerlaw:
%             The goodness-of-fit (a value closer to 1 indicates a better
%             fitting) for power law fitting.
%          R2.exponential:
%             The goodness-of-fit (a value closer to 1 indicates a better
%             fitting) for exponential fitting.
%
% References:
% 1. Achard et al. (2006): A Resilient, Low-Frequency, Small-World Human
%    Brain Functional Network with Highly Connected Association Cortical Hubs.
% 2. Gong et al. (2009): Mapping Anatomical Connectivity Patterns of Human
%    Cerebral Cortex Using In Vivo Diffusion Tensor Imaging Tractography.
%
% Yong HE,     BIC,    MNI, McGill,  2006/08/01
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2012/08/16, Jinhui.Wang.1982@gmail.com
%==========================================================================

if nargin == 1
    Nbins = 10; end

[n,xout] = hist(Deg, Nbins);

xdata = xout;

% cumulative probability
ydata = fliplr(cumsum(n));
ydata = ydata./ydata(1);

s = fitoptions('Method','NonlinearLeastSquares');

f = fittype('a*x.^(b-1).*exp(-x./c)','independent','x','options',s);
[para1, gof1] = fit(xdata',ydata',f);

Para.exponentialtruncated.a     = para1.a;
Para.exponentialtruncated.alpha = para1.b;
Para.exponentialtruncated.kc    = para1.c;
R2.exponentialtruncated         = gof1.rsquare;
fity_truncated = para1.a*(xdata.^(-1+para1.b)).*exp(-xdata./para1.c);

% power law fitting
f = fittype('a*x.^(1-b)','independent','x','options',s);
[para2, gof2] = fit(xdata',ydata',f);

Para.powerlaw.a     = para2.a;
Para.powerlaw.alpha = para2.b;
R2.powerlaw         = gof2.rsquare;
fity_power = para2.a*(xdata.^(1-para2.b));

% exponential fitting
f = fittype('a.*exp(-b.*x)','independent','x','options',s);
[para3, gof3] = fit(xdata',ydata',f);

Para.exponential.a     = para3.a;
Para.exponential.alpha = para3.b;
R2.exponential         = gof3.rsquare;
fity_exponential       = para3.a.*exp(-para3.b.*xdata);

% figure
plot(log(xdata),log(ydata),'k+','MarkerSize',4)
xlabel('log(degree)')
ylabel('log(cumulative distribution)')
hold on

plot(log(xdata),log(fity_truncated),'-r','Linewidth',2)
plot(log(xdata),log(fity_power),':k','Linewidth',2)
plot(log(xdata),log(fity_exponential),'--b','Linewidth',2)

legend('real data', 'exponentially truncated power law', 'power law', 'exponential')

return
