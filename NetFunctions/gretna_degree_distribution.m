function [Para, R2]= gretna_degree_distribution(Deg, Nbins)

%==========================================================================
% This function is used to fit the degree (also betweenness and others) 
% distribution of a network G in terms of three types:
%    Tpye1: exponential truncated power law fitting
%                p(k) = a * k^(alpha-1) * exp(-k/kc);
%    Tpye2: power law fitting
%                p(k) = a * k^(-alpha);
%    Tpye3: exponential fitting
%                p(k) = a * exp(-alpha*k).
%
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

% exponential truncated power law fitting
fun_truncated = @(x,xdata)x(1)*(xdata.^(-1+x(2))).*exp(-1*xdata/x(3));
[x]= lsqcurvefit(fun_truncated,[1 1 1],xdata,ydata);
fity = x(1)*(xdata.^(-1+x(2))).*exp(-1*xdata/x(3));

Para.exponentialtruncated.a     = x(1);
Para.exponentialtruncated.alpha = x(2);
Para.exponentialtruncated.kc    = x(3);
R2.exponentialtruncated = gretna_rsquare(ydata,fity);

% power law fitting
fun_power = @(x,xdata)x(1)*(xdata.^(-x(2)));
[x]= lsqcurvefit(fun_power,[1 1],xdata,ydata);
fity = x(1)*(xdata.^(-x(2)));

Para.powerlaw.a     = x(1);
Para.powerlaw.alpha = x(2);
R2.powerlaw = gretna_rsquare(ydata,fity);

% exponential fitting
fun_exponential = @(x,xdata)x(1).*(exp(-x(2)*xdata));
[x]= lsqcurvefit(fun_exponential,[1 1],xdata,ydata);
fity = x(1).*exp(-x(2)*xdata);

Para.exponential.a     = x(1);
Para.exponential.alpha = x(2);
R2.exponential = gretna_rsquare(ydata,fity);


% plotting
plot(log(xdata),log(ydata),'k+','MarkerSize',4)
xlabel('log(degree)')
ylabel('log(cumulative distribution)')
hold on;

plotx = xdata;

ploty = Para.exponentialtruncated.a*(plotx.^(-1+Para.exponentialtruncated.alpha)).*exp(-1*plotx/Para.exponentialtruncated.kc);
plot(log(plotx),log(ploty),'-r','Linewidth',2)

ploty = Para.powerlaw.a*(plotx.^(-Para.powerlaw.alpha));
plot(log(plotx),log(ploty),':k','Linewidth',2)

ploty = Para.exponential.a.*exp(-Para.exponential.alpha*plotx);
plot(log(plotx),log(ploty),'--b','Linewidth',2)

legend('real data', 'exponentially truncated power law', 'power law', 'exponential')

return