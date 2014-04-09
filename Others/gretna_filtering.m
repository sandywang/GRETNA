function [Fil_data] = gretna_filtering(Data, SamplePeriod, FreBand)

%==========================================================================
% This function is used to perform temporal filtering of time series by
% ideal rectangular filter.
%
%
% Syntax: function [Fil_data] = gretna_IdealFilter(Data, SamplePeriod, Band)
%
% Inputs:
%       Data:
%                   Multidimensional array with the last dim of observations
%                   (i.e., sampling point).
%       SamplePeriod:
%                   Sample period of time series.
%       FreBand:
%                   The frequency band for filtering (1*2 array). E.g.,
%                   FreBand = [f1 f2]  for band pass filtering: f1 < f < f2;
%                   FreBand = [0 f1]   for low  pass filtering: f < f1;
%                   FreBand = [f1 inf] for high pass filtering: f > f1.
%
% Output:
%       Fil_data:
%                   The resultant filtered data.
%
% Jinhui WANG, CCBD, HNU, Hangzhou, 2012/09/17, Jinhui.Wang.1982@gmail.com
%==========================================================================

ndim = ndims(Data);
siz = size(Data);

Data = Data - repmat(mean(Data,ndim),[ones(1,ndim-1) siz(ndim)]);

sampleFreq 	 = 1/SamplePeriod;
sampleLength = size(Data,ndim);

NFFT = gretna_nextpow2(sampleLength);
Data = fft(Data, NFFT, ndim);

f = sampleFreq/2*linspace(0,1,NFFT/2+1);
f = [f(1:end-1) fliplr(f)];
f(end) = [];

if isinf(FreBand(2))
    ind = f < FreBand(1);
else
    ind = f > FreBand(2) | f < FreBand(1);
end

Data = reshape(Data, numel(Data)/NFFT, NFFT);

Data(:,ind) = 0;

Data = ifft(Data, NFFT, 2);

Fil_data = Data(:,1:sampleLength);
Fil_data = reshape(Fil_data,siz);

return