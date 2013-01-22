% --------------------------------------------------------------
% The relationship p value and statistical (Z, T, X^2, F) values
% P {T(n)>Talpha(n)} = alpha
% if P (i.e.alpha) is obtained by a two-tailed test, so Pvalue = P/2; 
% for example, in a two-tailed two-sample t test with 15 normal controls
% and 15 patients , P = 0.05, so df =28, t = 2.0484, 
% namely, Pvalue = 0.025; df = 28;
% Tscores = spm_invtcdf(1-Pvalue, df) = 2.0484;
% Yong He, BIC, MNI, McGill U, 2005/07/22
% --------------------------------------------------------------

% 1------------------------------------------------ 
% Z scores & p value
% The relationship of p values to Z scores
Pvalue = [0.05 0.01];
Zscores = spm_invNcdf(1 - Pvalue)

% The relationship of Z scores to p values 
%one tailed: 1.64 corresponds to P =0.05
%two tailed: 1.96 corresponds to P =0.05
Zscores = [1.6449 2.3263]; 
Pvalue = 1 - spm_Ncdf(Zscores)

% 2------------------------------------------------
% T scores & p value
% The relationship of p values to T scores
Pvalue = [0.05 0.01]; df = 12;
Tscores = spm_invtcdf(1 - Pvalue,df)

% The relationship of T score to p values 
Tscores = [1.7823 2.6810]; df = 12;
Pvalue = 1 - spm_Tcdf(Tscores,df)

% 3------------------------------------------------
% chi-square score & p value
% The relationship of p values to chi-square scores
Pvalue = [0.05 0.01]; df = 12;
Xscores = spm_invXcdf(1-Pvalue,df)

% The relationship of chi-square score to p values 
Xscores = [21.0261 26.2170]; df = 12;
Pvalue = 1 - spm_Xcdf(Xscores,df)


% 4------------------------------------------------
% F score & p value
% The relationship of p values to F scores
Pvalue = [0.05 0.01]; df = [12,20];
Fscores = spm_invfcdf(1-Pvalue,df)

% The relationship of F score to p values 
Fscores = [2.2776    3.2311]; df = [12,20];
Pvalue = 1 - spm_Fcdf(Fscores,df)

% t to z
Tvalue = 1.7823; df = 12;
Zscores = spm_t2z(1.7823,12);
Pvalue = 1 - spm_Ncdf(Zscores);


