function [x] = epsGG(X)
%EPSGG Greenhouse-Geisser epsilon.
% The Greenhouse-Geisser epsilon value measures by how much the sphericity
% assumption is violated. Epsilon is then used to adjust for the potential 
% bias in the F statistic. Epsilon can be 1, which means that the sphericity
% assumption is met perfectly. An epsilon smaller than 1 means that the
% sphericity assumption is violated. The further it deviates from 1, the worse
% the violation; it can be as low as epsilon = 1/(k - 1), which produces
% the lower bound of epsilon (the worst case scenario). The worst case scenario
% depends on k, the number of levels in the repeated measure factor. In real
% life epsilon is rarely exactly 1. If it is not much smaller than 1, then we
% feel comfortable with the results of repeated measure ANOVA. 
% The Greenhouse-Geisser epsilon is derived from the variance-covariance matrix
% of the data. For its evaluation we need to first calculate the variance-
% covariance matrix of the variables (S). The diagonal entries are the variances
% and the off diagonal entries are the covariances. From this variance-covariance
% matrix, the epsilon statistic can be estimated. Also we need the mean of the
% entries on the main diagonal of S, the mean of all entries, the mean of all
% entries in row i of S, and the individual entries in the variance-covariance
% matrix. There are three important values of epsilon. It can be 1 when the
% sphericity is met perfectly. This epsilon procedure was proposed by Greenhouse
% and Geisser (1959).
%
% Syntax: function epsGG(X)
%
% Inputs:
%    X - Input matrix can be a data matrix (size n-data x k-treatments)
% Output:
%    x - Greenhouse-Geisser epsilon value.
%
% $$We suggest you could take-a-look to the PDF document ''This Week's 
%   Citation Classics'' CCNumber 28, July 12, 1982, web-page [http://
%   garfield.library.upenn.edu/classics1982/A1982NW45700001.pdf]$$
%
% Example 2 of Maxwell and Delaney (p.497). This is a repeated measures example
% with two within and a subject effect. We have one dependent variable:reaction
% time, two independent variables: visual stimuli are tilted at 0, 4, and 8 
% degrees; with noise absent or present. Each subject responded to 3 tilt and 2
% noise given 6 trials. Data are,
%
%                      0           4           8                  
%                 -----------------------------------
%        Subject    A     P     A     P     A     P
%        --------------------------------------------
%           1      420   480   420   600   480   780
%           2      420   360   480   480   480   600
%           3      480   660   480   780   540   780
%           4      420   480   540   780   540   900
%           5      540   480   660   660   540   720
%           6      360   360   420   480   360   540
%           7      480   540   480   720   600   840
%           8      480   540   600   720   660   900
%           9      540   480   600   720   540   780
%          10      480   540   420   660   540   780
%        --------------------------------------------
%
% The three measurements of reaction time were averaging across noise 
% ausent/present. Given,
%
%                         Tilt
%                  -----------------
%        Subject     0     4     8    
%        ---------------------------
%           1       450   510   630
%           2       390   480   540
%           3       570   630   660
%           4       450   660   720
%           5       510   660   630
%           6       360   450   450
%           7       510   600   720
%           8       510   660   780
%           9       510   660   660
%          10       510   540   660
%        ---------------------------
%
% We need to estimate the Greenhouse-Geisser epsilon associated with the angle
% of rotation of the stimulii. 
%
% Data matrix must be:
%      X=[450 510 630;390 480 540;570 630 660;450 660 720;510 660 630;
%      360 450 450;510 600 720;510 660 780;510 660 660;510 540 660];
% 
% Calling on Matlab the function: 
%    x=epsGG(X)
%
% Answer is:
%
%    x = 0.9616
%
% Created by A. Trujillo-Ortiz, R. Hernandez-Walls, A. Castro-Perez
%            and K. Barba-Rojo
%            Facultad de Ciencias Marinas
%            Universidad Autonoma de Baja California
%            Apdo. Postal 453
%            Ensenada, Baja California
%            Mexico.
%            atrujo@uabc.mx
%
% Copyright. October 31, 2006.
%
% --Special thanks are given to Søren Andersen, Universität Leipzig, Institut
%   Psychologie I, Professur Allgemeine Psychologie & Methodenlehre, Seeburgstr
%   14-20, D-04103 Leipzig, Deutchland, for encouraging us to create this m-file-- 
%
% To cite this file, this would be an appropriate format:
% Trujillo-Ortiz, A., R. Hernandez-Walls, A. Castro-Perez and K. Barba-Rojo. (2006).
%   epsGG:Greenhouse-Geisser epsilon. A MATLAB file. [WWW document]. URL http://
%   www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=12839
%
% Reference:
% Greenhouse, S.W. and Geisser, S. (1959), On methods in the analysis
%     of profile data. Psychometrika, 24:95-112. 
% Maxwell, S.E. and Delaney, H.D. (1990), Designing Experiments and 
%     Analyzing Data: A model comparison perspective. Pacific Grove,
%     CA: Brooks/Cole.
%

error(nargchk(1,1,nargin));

k = size(X,2);  %number of treatments
S = cov(X);  %variance-covariance matrix
mds = mean(diag(S));  %mean of the entries on the main diagonal of S
ms = mean(mean(S));  %the mean of all entries of S
msr = mean(S,2);  %mean of all entries in row i of S
N = k^2*(mds-ms)^2;
D = (k-1)*(sum(sum(S.^2))-2*k*sum(msr.^2)+k^2*ms^2);
epsGG = N/D;  %Greenhouse-Geisser epsilon estimation
x = epsGG;

return,