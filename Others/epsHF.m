function [x] = epsHF(X)
%EPSHF Huynh-Feldt epsilon.
% The Huynh-Feldt epsilon its a correction of the Greenhouse-Geisser epsilon.
% This due that the Greenhouse-Geisser epsilon tends to underestimate epsilon
% when epsilon is greater than 0.70 (Stevens, 1990). An estimated epsilon
% = 0.96 may be actually 1. Huynh-Feldt correction is less conservative. The
% Huynh-Feldt epsilon is calculated from the Greenhouse-Geisser epsilon.
% As the Greenhouse-Geisser epsilon, Huynh-Feldt epsilon measures how much
% the sphericity assumption or compound symmetry is violated. The idea of both 
% corrections its analogous to pooled vs. unpooled variance Student's t-test:
% if we have to estimate more things because variances/covariances are not 
% equal, then we lose some degrees of freedom and P-value increases. These
% epsilons should be 1.0 if sphericity holds. If not sphericity assumption
% appears violated. We must to have in mind that the greater the number of
% repeated measures, the greater the likelihood of violating assumptions of
% sphericity and normality (Keselman et al, 1996) . Therefore, we nedd to have
% the most conservative F values. These are obtained by setting epsilon to its
% lower bound, which represents the maximum violation of these assumptions.
% When a significant result is obtained, it is assumed to be robust. However,
% since this test may be overly conservative, Greenhouse and Geisser (1958,
% 1959) recommend that when the lower-bound epsilon gives a nonsignificant
% result, it should be followed by an approximate test (based on a sample
% estimate of epsilon).
%
% Syntax: function epsHF(X)
%
% Inputs:
%    X - Input matrix can be a data matrix (size n-data x k-treatments)
% Output:
%    x - Huynh-Feldt epsilon value.
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
% absent/present. Given,
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
%    x=epsHF(X)
%
% Answer is:
%
%    x = 1.2176
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
% Copyright. November 01, 2006.
%
% To cite this file, this would be an appropriate format:
% Trujillo-Ortiz, A., R. Hernandez-Walls, A. Castro-Perez and K. Barba-Rojo. (2006).
%   epsHF:Huynh-Feldt epsilon. A MATLAB file. [WWW document]. URL http://
%   www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=12853
%
% --Special thanks are given to Søren Andersen, Universität Leipzig, Institut
%   Psychologie I, Professur Allgemeine Psychologie & Methodenlehre, Seeburgstr
%   14-20, D-04103 Leipzig, Deutchland, for encouraging us to create this m-file-- 
%
% References:
% Geisser, S, and Greenhouse, S.W. (1958), An extension of Box’s results on
%     the use of the F distribution in multivariate analysis. Annals of
%     Mathematical Statistics, 29:885?91.
% Greenhouse, S.W. and Geisser, S. (1959), On methods in the analysis of
%     profile data. Psychometrika, 24:95-112. 
% Huynh, M. and Feldt, L.S. (1970), Conditions under which mean square rate
%     in repeated measures designs have exact-F distributions. Journal of the
%     American Statistical Association, 65:1982-1989 
% Keselman, J.C, Lix, L.M. and Keselman, H.J. (1996), The analysis of repeated
%     measurements: a quantitative research synthesis. British Journal of
%     Mathematical and Statistical Psychology, 49:275?98.
% Maxwell, S.E. and Delaney, H.D. (1990), Designing Experiments and Analyzing
%     Data: A model comparison perspective. Pacific Grove, CA: Brooks/Cole.
% 

error(nargchk(1,1,nargin));

[n k] = size(X);
eGG = epsGG(X);  %call to the zipped Greenhouse-Geisser epsilon function
epsHF = (n*(k-1)*eGG-2)/((k-1)*((n-1)-(k-1)*eGG));  %Huynh-Feldt epsilon estimation
x = epsHF;

return,