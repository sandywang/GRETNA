function [Graph] = gretna_tc2graph(TC, TR)

%==========================================================================
% This function is used to convert a time course to a binary graph
% according to the principle of visibility method (Lacasa et al.,2008,PNAS).
%
%
% Syntax: function [graph] = gretna_tc2graph(TC, TR)
%
% Inputs:
%       TC:
%                   The n*1 time course.
%       TR:
%                   The sample rate of TC.
%
% Output:
%       Graph:
%                   The resultant binary network.
%
% Reference:
% 1. Lacasa et al. (2008): From time series to complex networks: The
%    visibility graph. PNAS.
%
% Jinhui WANG, NKLCNL, BNU, BeiJing, 2011/10/23, Jinhui.Wang.1982@gmail.com
%==========================================================================

len_tc = size(TC,1);
scope = zeros(len_tc);
Graph = zeros(len_tc);

for i = 1:len_tc - 1
    for j = i+1:len_tc
        scope(i,j) = (TC(j) - TC(i))/(TR*(j - i));
    end
end

scope = scope + scope';

for i = 1:len_tc-2
    for j = i+2:len_tc
        if scope(i+1:j-1,j)>scope(i,j)
            Graph(i,j) = 1;
        end
    end
end

for i = 1:len_tc - 1
    Graph(i,i+1) = 1;
end

Graph = Graph + Graph';

return